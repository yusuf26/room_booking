import 'dart:convert';

class Customer {
  final int free_room;
  final String name;
  final int id;
  final int free_room_remaining;
  final String email;
  final String address;

  Customer(
      {required this.id,
      required this.free_room,
      required this.name,
      required this.free_room_remaining,
      required this.email,
      required this.address});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json["id"],
        free_room: json["free_room"],
        free_room_remaining: json["free_room_remaining"],
        name: json["name"],
        email: json["email"],
        address: json["address"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "free_room": free_room,
      "free_room_remaining": free_room_remaining,
      "name": name,
      "email": email,
      "address": address
    };
  }
}

List<Customer> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Customer>.from(
      data['data'].map((item) => Customer.fromJson(item)));
}

List<Customer> userFromJson_2(String jsonData) {
  final data = json.decode(jsonData);
  List data_2 = [];
  data_2.add(data['data']);
  return List<Customer>.from(data_2.map((item) => Customer.fromJson(item)));
}
