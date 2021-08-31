import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputWithIcon extends StatelessWidget {
  final labelText;
  final iconName;
  final inputType;
  var bindedInput;
  final validator;
  final obscureText;
  final Function onSave;
  final Function onChange;
  final bool error;

  TextInputWithIcon(
      {@required this.labelText,
      this.iconName,
      this.inputType = TextInputType.text,
      @required this.bindedInput,
      @required this.validator,
      this.obscureText = false,
      @required this.onSave,
      this.error = false,
      this.onChange = null});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon:
                Icon(this.iconName, color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: this.error ? Colors.red : Colors.transparent,
                width: 0.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: this.error ? Colors.red : Colors.transparent,
                width: 0.0,
              ),
            ),
            labelStyle: TextStyle(
                fontSize: 20.0, color: Theme.of(context).primaryColor),
            labelText: this.labelText),
        obscureText: this.obscureText,
        onSaved: onSave,
        onChanged: this.onChange,
      ),
    );
  }
}
