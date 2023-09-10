import 'package:booking_room_app/network/CustomerService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'customer_page.dart';
import '../constant.dart';

class NewCustomer extends StatefulWidget {
  final int? id;
  NewCustomer({Key? key, this.id}) : super(key: key);

  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  _NewCustomerState();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final freeRoomController = TextEditingController();
  final addressController = TextEditingController();
  bool _isLoading = false;
  bool _isFirstLoadRunning = false;
  String titlePage = 'Add New Customer';

  Future<void> createCustomer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.customersEndpoint);
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'free_room': freeRoomController.text,
        'address': addressController.text
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          data['message'].toString(),
          style: TextStyle(fontSize: 16),
        )),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          data['message'].toString(),
          style: TextStyle(fontSize: 16),
        )),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> editCustomer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.customersEndpoint +
        '/' +
        widget.id.toString());
    setState(() {
      _isLoading = true;
    });
    final response = await http.put(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'free_room': freeRoomController.text,
        'address': addressController.text
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          data['message'].toString(),
          style: TextStyle(fontSize: 16),
        )),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          data['message'].toString(),
          style: TextStyle(fontSize: 16),
        )),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  getEditData() async {
    if (widget.id != null) {
      setState(() {
        _isFirstLoadRunning = true;
        titlePage = 'Edit Customer';
      });
      await CustomerService().getDetail(widget.id!).then((value) {
        nameController.text = value![0].name;
        emailController.text = value[0].email;
        freeRoomController.text = value[0].free_room.toString();
        addressController.text = value[0].address;
        setState(() {
          _isFirstLoadRunning = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEditData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titlePage),
        ),
        body: _isFirstLoadRunning
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Card(
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Name',
                                      ),
                                      validator: (value) {},
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                      ),
                                      validator: (value) {},
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        hintText: 'Address',
                                      ),
                                      maxLines: 4,
                                      validator: (value) {},
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: freeRoomController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'Free Room',
                                      ),
                                      validator: (value) {},
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size.fromHeight(50), // NEW
                                      ),
                                      onPressed: () {
                                        if (widget.id != null) {
                                          editCustomer();
                                        } else {
                                          createCustomer();
                                        }
                                      },
                                      child: Text('Save',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                              if (_isLoading)
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                            ],
                          ))),
                ),
              )));
  }
}
