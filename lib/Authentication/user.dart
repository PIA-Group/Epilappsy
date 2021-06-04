import 'dart:convert';

class User {
  String name;
  String email;
  String role;

  User(this.name, this.email, this.role);

  User.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    name = data["name"];
    email = data["email"];
    role = data["role"];
  }

  String toJson() => jsonEncode(
        {
          "name": name,
          "email": email,
          "role": role,
        },
      );
}