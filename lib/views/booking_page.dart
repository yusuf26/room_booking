import 'package:booking_room_app/model/Booking.dart';
import 'package:booking_room_app/network/BookingService.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'booking_new_page.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'booking_detail_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String email = "";

  late List<Booking>? _bookingModel = [];
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
    BookingService().getBooking().then((value) {
      setState(() {
        _bookingModel = value;
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
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Booking Page"),
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
                    itemCount: _bookingModel!.length,
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
                                  child: Icon(FontAwesomeIcons.calendarDays,
                                      color: Colors.white),
                                ),
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _bookingModel![index].booking_number,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _bookingModel![index].customer_name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        _bookingModel![index].room_name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        _bookingModel![index].booking_date,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        _bookingModel![index].status,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ]),

                                // subtitle: Row(
                                //   children: <Widget>[
                                //     Padding(
                                //         padding: const EdgeInsets.only(top: 10),
                                //         child: Text(
                                //             _bookingModel![index].booking_date +
                                //                 ' || (' +
                                //                 _bookingModel![index].status,
                                //             style:
                                //                 TextStyle(color: Colors.white)))
                                //   ],
                                // ),
                                trailing: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_right,
                                      color: Colors.white, size: 30.0),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingDetail(
                                            booking: _bookingModel![index]),
                                      ),
                                    );
                                  },
                                ),
                              )));
                    },
                  ),
                )
              ]));
  }

  _navigateToAddScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewBooking()),
    );
  }
}
