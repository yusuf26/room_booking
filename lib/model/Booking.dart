import 'dart:convert';

class Booking {
  final int id;
  final int room_id;
  final int customer_id;
  final String booking_number;
  final String start_date;
  final String end_date;
  final String booking_date;
  final int total_date;
  final String status;
  final String room_name;
  final int room_price;
  final String room_price_format;
  final String customer_name;
  final String total_format;

  Booking(
      {required this.id,
      required this.room_id,
      required this.customer_id,
      required this.booking_number,
      required this.start_date,
      required this.end_date,
      required this.booking_date,
      required this.total_date,
      required this.status,
      required this.room_name,
      required this.room_price,
      required this.room_price_format,
      required this.customer_name,
      required this.total_format});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json["id"],
      room_id: json["room_id"],
      customer_id: json["customer_id"],
      booking_number: json["booking_number"],
      start_date: json["start_date"],
      end_date: json["end_date"],
      booking_date: json["booking_date"],
      total_date: json["total_date"],
      status: json["status"],
      room_name: json["room_name"],
      room_price: json["room_price"],
      room_price_format: json["room_price_format"],
      customer_name: json["customer_name"],
      total_format: json["total_format"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "room_id": room_id,
      "customer_id": customer_id,
      "booking_number": booking_number,
      "start_date": start_date,
      "end_date": end_date,
      "booking_date": booking_date,
      "total_date": total_date,
      "status": status,
      "room_name": room_name,
      "room_price": room_price,
      "room_price_format": room_price_format,
      "customer_name": customer_name,
      "total_format": total_format
    };
  }
}

List<Booking> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Booking>.from(data['data'].map((item) => Booking.fromJson(item)));
}
