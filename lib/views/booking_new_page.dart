import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/Customer.dart';
import '../network/CustomerService.dart';
import '../model/Room.dart';
import '../network/RoomService.dart';
import 'package:intl/intl.dart';
import '../constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking_page.dart';

class NewBooking extends StatefulWidget {
  NewBooking();

  @override
  _NewBookingState createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> {
  _NewBookingState();
  // Initial Selected Value
  int? roomValue;
  int? customerValue;

  late List<Customer>? _customerModel = [];
  late List<Room>? _roomModel = [];
  final dateinput = TextEditingController();
  final dateinput_end = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;

  void _firstLoad() async {
    CustomerService().getCustomers().then((value) {
      setState(() {
        _customerModel = value;
      });
    });
    RoomService().getRooms().then((value) {
      setState(() {
        _roomModel = value;
      });
    });
  }

  Future<void> createBooking() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.bookingsEndpoint);
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
        'room_id': roomValue,
        'customer_id': customerValue,
        'start_date': dateinput.text,
        'end_date': dateinput_end.text
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
        MaterialPageRoute(builder: (context) => BookingPage()),
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

  @override
  void initState() {
    // getPref();
    super.initState();
    _firstLoad();
    // _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Booking Room'),
        ),
        body: Form(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: [
                              DropdownButton(
                                // Initial Value
                                value: customerValue,
                                isExpanded: true,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                hint: const Text("Select Customer"),

                                // Array list of items
                                items: _customerModel!.map((items) {
                                  return DropdownMenuItem(
                                    value: items.id,
                                    child: Text(items.name),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (int? newValue) {
                                  setState(() {
                                    customerValue = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              DropdownButton(
                                // Initial Value
                                value: roomValue,
                                isExpanded: true,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                hint: const Text("Select Room"),

                                // Array list of items
                                items: _roomModel!.map((items) {
                                  return DropdownMenuItem(
                                    value: items.id,
                                    child: Text(items.room_name),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    roomValue = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(children: [
                              Expanded(
                                  child: TextField(
                                controller:
                                    dateinput, //editing controller of this TextField
                                decoration: InputDecoration(
                                    icon: Icon(Icons
                                        .calendar_today), //icon of text field
                                    labelText:
                                        "Start Date" //label text of field
                                    ),
                                readOnly:
                                    true, //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd').format(
                                            pickedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      dateinput.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              )),
                              Expanded(
                                  child: TextField(
                                controller:
                                    dateinput_end, //editing controller of this TextField
                                decoration: InputDecoration(
                                    icon: Icon(Icons
                                        .calendar_today), //icon of text field
                                    labelText: "End Date" //label text of field
                                    ),
                                readOnly:
                                    true, //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd').format(
                                            pickedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      dateinput_end.text =
                                          formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              ))
                            ])),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50), // NEW
                                ),
                                onPressed: () {
                                  createBooking();
                                },
                                child: Text('Save',
                                    style: TextStyle(color: Colors.white)),
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
