import 'dart:convert';

class User {
  final String name;
  final String email;
  final String password;
  final String? id;
  final String? address;
  final String? type;
  final String? token;

  User(
      {required this.name,
      required this.email,
      required this.password,
      this.address,
      this.type,
      this.id,
      this.token});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'id': id,
      'address': address,
      'type': type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      id: map['_id'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  factory User.empty() => User(
        name: '',
        email: '',
        password: '',
        address: '',
        type: '',
        id: '',
        token: '',
      );
}
