import 'package:flutter/material.dart';
import '../model/Customer.dart';

import '../network/CustomerService.dart';
import 'customer_new_page.dart';
import 'customer_page.dart';

class CustomerDetail extends StatefulWidget {
  Customer customer;
  CustomerDetail({required this.customer});

  @override
  _CustomerDetailState createState() => _CustomerDetailState(this.customer);
}

class _CustomerDetailState extends State<CustomerDetail> {
  // late Future<List<Episode>> episodes;
  final Customer customer;
  _CustomerDetailState(this.customer);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSuccess = true;

  void _deleteCustomer() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Are you sure want to delete data ?"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  CustomerService()
                      .deleteCustomer(customer.id)
                      .then((isSuccess) {
                    if (isSuccess!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Delete data successful',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                      Navigator.of(context).pushReplacementNamed('/customer');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Delete data failed',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                    }
                  });
                },
              ),
              ElevatedButton(
                child: Text("No"),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(_scaffoldKey.currentContext!).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    // episodes = fetchEpisodes(widget.item);
    isSuccess = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Detail'),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 4.0,
            color: Colors.blue[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name : ${customer.name}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email : ${customer.email}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Address : ${customer.address}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Free Room : ${customer.free_room.toString()}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Free Room Remaining : ${customer.free_room_remaining.toString()}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewCustomer(id: customer.id),
                            ),
                          );
                        },
                        child: Text('Edit'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        onPressed: () {
                          _deleteCustomer();
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
