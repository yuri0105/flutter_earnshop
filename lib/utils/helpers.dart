import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void routeTo(BuildContext context, routeName, arguments) {
  if (ModalRoute.of(context).settings.name != routeName) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}

void routeToReplacement(BuildContext context, routeName, arguments) {
  Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
}

void handleErrorResponse(String response) {
  final jsonResponse = jsonDecode(response);
  Map map = jsonResponse;
  map.keys.forEach((key) {
    print(key);
    if (map[key].runtimeType == String) {
      Fluttertoast.showToast(
        msg: map[key],
        timeInSecForIosWeb: 5,
      );
    } else {
      Fluttertoast.showToast(
        msg: map[key][0],
        timeInSecForIosWeb: 5,
      );
    }
  });
}
