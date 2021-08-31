import 'package:EarnShow/screens/Login.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onClick;

  RoundedButton({this.label, this.onClick});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Text(
        this.label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w300,
        ),
      ),
      color: Theme.of(context).secondaryHeaderColor,
      onPressed: this.onClick,
    );
  }
}
