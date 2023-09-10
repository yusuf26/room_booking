import 'package:booking_room_app/network/RoomService.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constant.dart';
import 'room_page.dart';

class NewRoom extends StatefulWidget {
  final int? id;
  NewRoom({Key? key, this.id}) : super(key: key);

  @override
  _NewRoomState createState() => _NewRoomState();
}

class _NewRoomState extends State<NewRoom> {
  _NewRoomState();
  final roomNameController = TextEditingController();
  final typeController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  bool _isLoading = false;
  bool _isFirstLoadRunning = false;
  String titlePage = 'Add New Room';

  Future<void> createRoom() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl = Uri.parse(ApiConstants.baseUrl + ApiConstants.roomsEndpoint);
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
        'room_name': roomNameController.text,
        'type': typeController.text,
        'location': locationController.text,
        'price': priceController.text
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
        MaterialPageRoute(builder: (context) => RoomPage()),
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

  Future<void> editRoom() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.roomsEndpoint +
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
        'room_name': roomNameController.text,
        'type': typeController.text,
        'location': locationController.text,
        'price': priceController.text
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
        MaterialPageRoute(builder: (context) => RoomPage()),
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
        titlePage = 'Edit Room';
      });
      await RoomService().getRoomDetail(widget.id!).then((value) {
        roomNameController.text = value![0].room_name;
        typeController.text = value[0].type;
        locationController.text = value[0].location;
        priceController.text = value[0].price.toString();
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
    // nameController.dispose();
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
                                      controller: roomNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'Room Name ',
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
                                      controller: typeController,
                                      decoration: const InputDecoration(
                                        hintText: 'Type',
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
                                      controller: locationController,
                                      decoration: const InputDecoration(
                                        hintText: 'Location',
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
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'Price',
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
                                          editRoom();
                                        } else {
                                          createRoom();
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
