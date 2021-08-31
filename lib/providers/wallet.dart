import 'dart:convert';

import 'package:EarnShow/constants.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class WalletProvider extends ChangeNotifier {
  int _balance;
  String authToken;

  void updates(String authToken) {
    this.authToken = authToken;
  }

  Future<void> fetchBalance() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/wallet/1',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        _balance = jsonDecode(response.body.toString())["balance"];
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error in loading Wallet Balance", timeInSecForIosWeb: 5);
    }
    notifyListeners();
  }

  int get balance => _balance;
}
