import 'dart:developer';

import '../model/Booking.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'dart:convert';

class BookingService {
  Future<List<Booking>?> getBooking() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.bookingsEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        List<Booking> _model = userFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> deleteBooking(int id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.delete(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.bookingsEndpoint +
              '/' +
              id.toString()),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> processBooking(int id, int customer_id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.post(
        Uri.parse(
            ApiConstants.baseUrl + ApiConstants.bookingsEndpoint + '/process'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'id': id, 'customer_id': customer_id}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
