import 'package:booking_room_app/views/user_detail_page.dart';

import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'user_new_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/User.dart';
import '../network/UserService.dart';
// import '../network/api_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String email = "";
  List _posts = [];
  late List<User>? _userModel = [];

  final _baseUrl = 'http://127.0.0.1:8000/api/user';
  int _page = 0;
  final int _limit = 20;

  bool _hasNextPage = true;

  bool _isFirstLoadRunning = false;

  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PageLogin(),
        ),
        (route) => false,
      );
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    UserService().getUsers().then((value) {
      setState(() {
        _userModel = value;
        _isFirstLoadRunning = false;
      });
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        final res =
            await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page"),
      ),
      drawer: SideMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          _navigateToAddScreen(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: _isFirstLoadRunning
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: _userModel!.length,
                      itemBuilder: (_, index) => GestureDetector(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetail(user: _userModel![index]),
                                ),
                              ),
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: ListTile(
                              title: Text(_userModel![index].name +
                                  ' || ' +
                                  _userModel![index].role_name),
                              subtitle: Text(_userModel![index].email),
                            ),
                          ))),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            ),
    );
  }

  _navigateToAddScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewUser()),
    );
  }
}
