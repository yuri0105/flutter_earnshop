import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecTextInputRightIcon extends StatelessWidget {
  final labelName;
  final iconName;

  RecTextInputRightIcon(this.labelName, this.iconName);

  @override
  Widget build(BuildContext context) {
    const routeName = '/reset-password';
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.elliptical(5, 5)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ]),
      child: TextField(
        decoration: InputDecoration(
            suffixIcon: Icon(this.iconName,
                color: Theme.of(context).secondaryHeaderColor),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0.0,
              ),
            ),
            labelStyle: TextStyle(
                fontSize: 20.0, color: Colors.grey),
            labelText: this.labelName),
      ),
    );
  }
}
