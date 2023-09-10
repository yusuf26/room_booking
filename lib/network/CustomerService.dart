import 'dart:developer';

import '../model/Customer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class CustomerService {
  Future<List<Customer>?> getCustomers() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.customersEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        List<Customer> _model = userFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Customer>?> getDetail(int id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.customersEndpoint +
              '/' +
              id.toString()),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        // var data = json.decode(response.body);
        List<Customer> _model = userFromJson_2(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> deleteCustomer(int id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.delete(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.customersEndpoint +
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
}
