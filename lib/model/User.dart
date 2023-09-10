import 'dart:convert';

class User {
  final int role_id;
  final int id;
  final String name;
  final String email;
  final String role_name;
  // final String password;

  User(
      {required this.id,
      required this.role_id,
      required this.name,
      required this.email,
      required this.role_name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        role_id: json["role_id"],
        name: json["name"],
        email: json["email"],
        role_name: json["role_name"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role_id": role_id,
      "name": name,
      "email": email,
      "role_name": role_name
    };
  }
  // @override
  // String toString() {
  //   return 'User{id: $id,role_id: $role_id, name: $name, email: $email}';
  // }
}

List<User> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data['data'].map((item) => User.fromJson(item)));
}

List<User> userFromJson_2(String jsonData) {
  final data = json.decode(jsonData);
  List data_2 = [];
  data_2.add(data['data']);
  return List<User>.from(data_2.map((item) => User.fromJson(item)));
}
