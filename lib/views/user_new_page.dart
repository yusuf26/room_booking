import 'package:booking_room_app/network/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_page.dart';

import '../constant.dart';

class NewUser extends StatefulWidget {
  final int? id;
  const NewUser({Key? key, this.id}) : super(key: key);
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  _NewUserState();
  int? roleValue;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isFirstLoadRunning = false;
  String titlePage = 'Add New User';

  List<DropdownMenuItem<int>> get rolesItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text("Administrator"), value: 1),
      DropdownMenuItem(child: Text("Marketing"), value: 2),
      DropdownMenuItem(child: Text("Finance"), value: 3),
      DropdownMenuItem(child: Text("Operation"), value: 4),
    ];
    return menuItems;
  }

  Future<void> createUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl = Uri.parse(ApiConstants.baseUrl + '/register');
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
        'password': passwordController.text,
        'role_id': roleValue
      }),
    );
    // print(response);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Successful request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          data['message'].toString(),
          style: TextStyle(fontSize: 16),
        )),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
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

  Future<void> editUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final apiUrl =
        Uri.parse(ApiConstants.baseUrl + '/user/' + widget.id.toString());
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
        'password': passwordController.text,
        'role_id': roleValue
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
        MaterialPageRoute(builder: (context) => UserPage()),
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
        titlePage = 'Edit User';
      });
      await UserService().getDetail(widget.id!).then((value) {
        nameController.text = value![0].name;
        emailController.text = value[0].email;
        setState(() {
          _isFirstLoadRunning = false;
          roleValue = value[0].role_id;
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
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(titlePage)),
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
                                      decoration: const InputDecoration(
                                        hintText: 'Name',
                                      ),
                                      validator: (value) {},
                                      onChanged: (value) {},
                                      onSaved: (String? val) {
                                        nameController.text = val!;
                                      },
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
                                      decoration: const InputDecoration(
                                        hintText: 'Email',
                                      ),
                                      validator: (value) {},
                                      onChanged: (value) {},
                                      onSaved: (String? val) {
                                        emailController.text = val!;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: passwordController,
                                      decoration: const InputDecoration(
                                        hintText: 'Password',
                                      ),
                                      obscureText: true,
                                      validator: (value) {},
                                      onChanged: (value) {},
                                      onSaved: (String? val) {
                                        passwordController.text = val!;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children: [
                                    DropdownButton(
                                      // Initial Value
                                      value: roleValue,
                                      isExpanded: true,
                                      // Down Arrow Icon
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      hint: Text("Select Role"),
                                      // Array list of items
                                      items: rolesItems,
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          roleValue = newValue!;
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size.fromHeight(50), // NEW
                                      ),
                                      onPressed: () {
                                        if (widget.id != null) {
                                          editUser();
                                        } else {
                                          createUser();
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
