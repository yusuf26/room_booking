import 'dart:developer';

import '../model/Invoice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'dart:convert';

class InvoiceService {
  Future<List<Invoice>?> getInvoice() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.invoicesEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        List<Invoice> _model = userFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> deleteInvoice(int id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.delete(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.invoicesEndpoint +
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

  Future<bool?> processInvoice(
      int booking_id, int total_date, int room_price) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.invoicesEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
            {'booking_id': booking_id, 'qty': total_date, 'price': room_price}),
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
