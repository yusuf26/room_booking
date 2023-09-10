import 'package:booking_room_app/views/room_detail_page.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'room_new_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import '../network/RoomService.dart';
import 'room_detail_page.dart';
import '../model/Room.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String email = "";
  late List<Room>? _roomModel = [];
  bool _isFirstLoadRunning = false;

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
    RoomService().getRooms().then((value) {
      setState(() {
        _roomModel = value;
        _isFirstLoadRunning = false;
      });
    });
  }

  void _loadMore() async {}

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
          title: const Text("Room Page"),
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
            : Column(children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _roomModel!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.white24))),
                                child: Icon(
                                  FontAwesomeIcons.peopleRoof,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                _roomModel![index].room_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(_roomModel![index].type,
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white, size: 30.0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RoomDetail(room: _roomModel![index]),
                                    ),
                                  );
                                },
                              ),
                            )),
                      );
                    },
                  ),
                )
              ]));
  }

  _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewRoom()),
    );
  }
}
