import 'package:flutter/material.dart';
import '../model/Booking.dart';

import '../network/BookingService.dart';

import '../network/InvoiceService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking_page.dart';

class BookingDetail extends StatefulWidget {
  Booking booking;
  BookingDetail({required this.booking});

  @override
  _BookingDetailState createState() => _BookingDetailState(this.booking);
}

class _BookingDetailState extends State<BookingDetail> {
  // late Future<List<Episode>> episodes;
  final Booking booking;
  _BookingDetailState(this.booking);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSuccess = true;
  int? role_id;

  void _deleteBooking() {
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
                  BookingService().deleteBooking(booking.id).then((isSuccess) {
                    if (isSuccess!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Delete data successful',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                      Navigator.of(context).pushReplacementNamed('/booking');
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

  void _processBooking() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Are you sure want to process data ?"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  BookingService()
                      .processBooking(booking.id, booking.customer_id)
                      .then((isSuccess) {
                    if (isSuccess!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Process data successful',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                      Navigator.of(context).pushReplacementNamed('/booking');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Process data failed',
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

  void _generatePDF() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Are you sure want to generate data ?"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  InvoiceService()
                      .processInvoice(
                          booking.id, booking.total_date, booking.room_price)
                      .then((isSuccess) {
                    if (isSuccess!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Generate data successful',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                      Navigator.of(context).pushReplacementNamed('/booking');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Generate data failed',
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

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        role_id = pref.getInt("role_id")!;
      });
    }
  }

  @override
  void initState() {
    getPref();
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
        title: Text('Booking Detail'),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 4.0,
            color: Colors.blue[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Booking Number : ${booking.booking_number}",
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
                        "Room : ${booking.room_name}",
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
                        "Customer : ${booking.customer_name}",
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
                      Expanded(
                          child: Text(
                        "Booking Date : ${booking.booking_date}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ))
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Price : ${booking.room_price_format}",
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
                        "Quantity : ${booking.total_date.toString()}",
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
                        "Total : ${booking.total_format}",
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
                        "Status : ${booking.status}",
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
                      if ((role_id == 1 || role_id == 4) &&
                          booking.status == 'WAITING')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Background color
                          ),
                          onPressed: () {
                            _processBooking();
                          },
                          child: Text('Process'),
                        ),
                      if ((role_id == 1 || role_id == 3) &&
                          booking.status == 'INVOICING') ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange, // Background color
                          ),
                          onPressed: () {
                            _generatePDF();
                          },
                          child: Text('Generate Invoice'),
                        ),
                      ]
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
