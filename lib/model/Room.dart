import 'dart:convert';

class Room {
  final int id;
  final String room_name;
  final String type;
  final String location;
  final int price;
  final String price_format;

  Room(
      {required this.id,
      required this.room_name,
      required this.type,
      required this.location,
      required this.price,
      required this.price_format});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json["id"],
        room_name: json["room_name"],
        type: json["type"],
        location: json["location"],
        price: json["price"],
        price_format: json["price_format"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "room_name": room_name,
      "type": type,
      "location": location,
      "price": price,
      "price_format": price_format
    };
  }
}

List<Room> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Room>.from(data['data'].map((item) => Room.fromJson(item)));
}

List<Room> userFromJson_2(String jsonData) {
  final data = json.decode(jsonData);
  List data_2 = [];
  data_2.add(data['data']);
  return List<Room>.from(data_2.map((item) => Room.fromJson(item)));
}
