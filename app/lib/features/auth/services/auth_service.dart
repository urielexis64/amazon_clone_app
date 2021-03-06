import 'dart:convert';

import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Sign In User
  Future<void> signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final response =
          await http.post(Uri.parse('${GlobalVariables.uri}/api/signin'),
              body: jsonEncode({
                'email': email,
                'password': password,
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErroHandler(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            context.read<UserProvider>().setUser(response.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(response.body)['token']);
            Navigator.pushReplacementNamed(context, BottomBar.routeName);
          });
    } catch (e) {
      showSnackBar(context, message: e.toString());
    }
  }

  // Get user data
  Future<void> getUserData({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token != null) {
        prefs.setString('x-auth-token', '');
      }

      final tokenResponse = await http
          .get(Uri.parse('${GlobalVariables.uri}/api/user'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token.toString(),
      });

      var response = jsonDecode(tokenResponse.body);

      if (response) {
        final userResponse =
            await http.get(Uri.parse('${GlobalVariables.uri}/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token.toString(),
        });

        context.read<UserProvider>().setUser(userResponse.body);
      }
    } catch (e) {
      showSnackBar(context, message: e.toString());
    }
  }
}
