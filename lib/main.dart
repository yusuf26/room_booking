import 'package:booking_room_app/views/booking_page.dart';
import 'package:booking_room_app/views/invoice_page.dart';
import 'package:booking_room_app/views/report_page.dart';
import 'package:booking_room_app/views/room_page.dart';
import 'package:flutter/material.dart';
import 'views/customer_page.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/user_page.dart';
import 'dart:io';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Booking Room App',
    home: PageLogin(),
    routes: {
      '/home': (BuildContext ctx) => const HomePage(),
      '/customer': (BuildContext ctx) => const CustomerPage(),
      '/user': (BuildContext ctx) => const UserPage(),
      '/room': (BuildContext ctx) => const RoomPage(),
      '/booking': (BuildContext ctx) => const BookingPage(),
      '/invoice': (BuildContext ctx) => const InvoicePage(),
      '/report' : (BuildContext ctx) => const ReportPage()
    },
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
