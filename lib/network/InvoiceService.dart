import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/Invoice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'dart:convert';

class InvoiceService {
  
  final directory = "/storage/emulated/0/Download/BookingRoom";
  
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

  Future<dynamic> downloadInvoice() async {

    if(!await _requestPermissions()) {
      throw Exception("Please allow permission storage");
      return;
    }
    var folderPath;
    try {
      if(!Directory(directory).existsSync()) {
        Directory(directory).createSync(recursive: true);
      }
    } catch(e) {
      throw Exception(e.toString());
    }
    //ENDPOINT TO DOWNLOAD FILE
    final url = 'https://www.africau.edu/images/default/sample.pdf';
    //FILENAME
    final filename = 'sample.pdf';
    final response = await http.get(Uri.parse(url));
    final filePath = '$directory/$filename';

    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    print('File downloaded to: $filePath');

    return response;
  }

  Future<bool> _requestPermissions() async {
    // Check and request storage permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage, // for both read and write permissions
    ].request();

    // Handle the result
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}
