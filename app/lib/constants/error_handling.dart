import 'dart:convert';

import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

void httpErroHandler(
    {required Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      return onSuccess();
    case 400:
      return showSnackBar(context,
          message: jsonDecode(response.body)['message']);
    case 500:
      return showSnackBar(context, message: jsonDecode(response.body)['error']);
    default:
      return showSnackBar(context, message: 'Something went wrong');
  }
}
