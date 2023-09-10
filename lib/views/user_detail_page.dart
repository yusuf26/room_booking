import 'package:flutter/material.dart';
import '../model/User.dart';

import '../network/UserService.dart';
import 'user_page.dart';
import 'user_new_page.dart';

class UserDetail extends StatefulWidget {
  User user;
  UserDetail({required this.user});

  @override
  _UserDetailState createState() => _UserDetailState(this.user);
}

class _UserDetailState extends State<UserDetail> {
  // late Future<List<Episode>> episodes;
  final User user;
  _UserDetailState(this.user);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSuccess = true;

  void _deleteUser() {
    UserService().deleteUser(user.id).then((isSuccess) {
      if (isSuccess!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Delete data successful',
            style: const TextStyle(fontSize: 16),
          )),
        );
        Navigator.of(context).pushReplacementNamed('/user');
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
        title: Text(user.name),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Card(
            elevation: 4.0,
            color: Colors.blue[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${user.email}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${user.name}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "${user.role_name}",
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
                              builder: (context) => NewUser(id: user.id),
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text(
                                      "Are you sure want to delete data profile ${user.name}?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        _deleteUser();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        Navigator.of(
                                                _scaffoldKey.currentContext!)
                                            .pop();
                                      },
                                    )
                                  ],
                                );
                              });
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
