import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/layouts/RecTextInputRightIcon.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/screens/Login.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../layouts/HorizontalTabBar.dart';
import '../layouts/RoundedButton.dart';
import '../layouts/TextInputWithIcon.dart';

class ChangePassword extends StatefulWidget {
  static final routeName = '/resetPassword';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String oldPassword;

  String newPassword;

  String confirmPassword;

  void submit(context) async {
    _formKey.currentState.save();
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill required fields!",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          timeInSecForIosWeb: 5);
      return;
    }
    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(
          msg: "Password don't match!",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          timeInSecForIosWeb: 5);
      return;
    }
    final isChangedPassword = await Provider.of<Auth>(context, listen: false)
        .changePassword(oldPassword, newPassword);
    if (!isChangedPassword) {
      Fluttertoast.showToast(
          msg: "Network Error!",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          timeInSecForIosWeb: 5);
    }
    Fluttertoast.showToast(
        msg: "Password Updated",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        timeInSecForIosWeb: 5);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: new MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "EarnMore",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(top: 20, bottom: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: TextInputWithIcon(
                        labelText: "Current Password",
                        iconName: Icons.vpn_key,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the password';
                          }
                        },
                        onSave: (value) => {this.oldPassword = value},
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: TextInputWithIcon(
                        labelText: "New Password",
                        iconName: Icons.vpn_key,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the password';
                          }
                        },
                        onSave: (value) => {this.newPassword = value},
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: TextInputWithIcon(
                        labelText: "Confirm Password",
                        iconName: Icons.vpn_key,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the password';
                          }
                        },
                        onSave: (value) => {this.confirmPassword = value},
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10)),
                        child: Text("Update"),
                        color: Theme.of(context).secondaryHeaderColor,
                        textColor: Colors.white,
                        onPressed: () => submit(context),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 80),
                      child: RoundedButton(
                        label: "Sign out",
                        onClick: () => routeTo(context, Login.routeName, {}),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
    );
  }
}
