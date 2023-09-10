import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";
  String token = "";
  int? role_id;
  int totalCustomer = 0;
  int totalRoom = 0;
  int totalBooking = 0;
  int totalInvoice = 0;
  int totalBookingCompleted = 0;
  int totalUser = 0;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
        token = pref.getString("token")!;
        role_id = pref.getInt("role_id")!;
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

  void getDashboard() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    final response = await http
        .get(Uri.parse(ApiConstants.baseUrl + '/dashboard'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        totalCustomer = data['data']['customer'];
        totalRoom = data['data']['room'];
        totalBooking = data['data']['booking'];
        totalInvoice = data['data']['invoice'];
        totalBookingCompleted = data['data']['booking_completed'];
        totalUser = data['data']['user'];
      });
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
    getDashboard();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: SideMenu(),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem(
                "Total Customer", totalCustomer, FontAwesomeIcons.users),
            makeDashboardItem("Total Rooms", totalRoom, FontAwesomeIcons.house),
            makeDashboardItem(
                "Total Booking", totalBooking, FontAwesomeIcons.calendarDays),
            makeDashboardItem(
                "Total Invoice", totalInvoice, FontAwesomeIcons.fileInvoice),
            makeDashboardItem("Total Booking Completed", totalBookingCompleted,
                FontAwesomeIcons.calendarCheck),
            makeDashboardItem(
                "Total Users", totalUser, FontAwesomeIcons.circleUser)
          ],
        ),
      ),
    );
  }
}

Card makeDashboardItem(String title, int total, IconData icon) {
  return Card(
      elevation: 1.0,
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
        child: InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 20.0),
              Center(
                  child: Icon(
                icon,
                size: 30.0,
                color: Colors.black,
              )),
              SizedBox(height: 20.0),
              Center(
                child: Text(title,
                    style: TextStyle(fontSize: 14.0, color: Colors.black)),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(total.toString(),
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
              )
            ],
          ),
        ),
      ));
}
