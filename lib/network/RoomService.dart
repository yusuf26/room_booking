import 'dart:developer';

import '../model/Room.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'dart:convert';

class RoomService {
  Future<List<Room>?> getRooms() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.roomsEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        List<Room> _model = userFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Room>?> getRoomDetail(int id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.get(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.roomsEndpoint +
              '/' +
              id.toString()),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        // var data = json.decode(response.body);
        List<Room> _model = userFromJson_2(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> deleteRoom(int id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('token')!;
      final response = await http.delete(
          Uri.parse(ApiConstants.baseUrl +
              ApiConstants.roomsEndpoint +
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
