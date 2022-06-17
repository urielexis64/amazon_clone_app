import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Sign Up User
  Future<void> signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      final user = User(name: name, email: email, password: password);
      final response = await http.post(
          Uri.parse('${GlobalVariables.uri}/api/signup'),
          body: user.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErroHandler(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, message: 'Account created successfully');
          });
    } catch (e) {
      showSnackBar(context, message: e.toString());
    }
  }
}
