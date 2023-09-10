import 'dart:convert';

class Invoice {
  final int id;
  final int booking_id;
  final String invoice_number;
  final int total;
  final String total_format;
  final String customer_name;
  final String room_name;
  final String file_url;

  Invoice(
      {required this.id,
      required this.booking_id,
      required this.invoice_number,
      required this.total,
      required this.total_format,
      required this.customer_name,
      required this.room_name,
      required this.file_url});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        id: json["id"],
        booking_id: json["booking_id"],
        invoice_number: json["invoice_number"],
        total: json["total"],
        total_format: json["total_format"],
        customer_name: json["customer_name"],
        room_name: json["room_name"],
        file_url: json["file_url"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "booking_id": booking_id,
      "invoice_number": invoice_number,
      "total": total,
      "total_format": total_format,
      "customer_name": customer_name,
      "room_name": room_name,
      "file_url": file_url
    };
  }
}

List<Invoice> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Invoice>.from(data['data'].map((item) => Invoice.fromJson(item)));
}
