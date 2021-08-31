import 'package:EarnShow/layouts/CircularButton.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../layouts/TextInputWithIcon.dart';
import '../utils/helpers.dart';

class ForgotPassword extends StatefulWidget {
  static final routeName = '/forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeyResetEmail = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResetCode = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyRestChangePassword =
      new GlobalKey<FormState>();
  String _email;
  String _code;
  String _newPassword;
  String _confirmPassword;
  bool _isLoading;

  Future<void> passwordResetEmail() async {
    _formKeyResetEmail.currentState.save();
    if (_email == null || _email == '') {
      Fluttertoast.showToast(msg: "Email is required!", timeInSecForIosWeb: 5);
      return;
    }
    if (_code == null) {
      setState(() {
        _isLoading = true;
      });
      final isEmailSend = await Provider.of<Auth>(context, listen: false)
          .passwordResetEmail(_email);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> passwordResetVerify() async {
    _formKeyResetCode.currentState.save();
    if (_email != null && _code != null) {
      setState(() {
        _isLoading = true;
      });
      final isPasswordResetVerify =
          await Provider.of<Auth>(context, listen: false)
              .passwordResetVerify(_code);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> passwordResetChangePassword() async {
    _formKeyRestChangePassword.currentState.save();
    if (_newPassword == null || _newPassword != _confirmPassword) {
      Fluttertoast.showToast(
          msg: "Password didn't match!", timeInSecForIosWeb: 5);
    }
    if (_email != null && _code != null) {
      setState(() {
        _isLoading = true;
      });
      final isPasswordResetChangePassword =
          await Provider.of<Auth>(context, listen: false)
              .passwordResetChangePassword(_newPassword);
      if (isPasswordResetChangePassword) {
        routeTo(context, Dashboard.routeName, {});
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordResetEmail =
        Provider.of<Auth>(context).passwordResetEmailValue;
    final passwordResetCode = Provider.of<Auth>(context).passwordResetCode;

    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            child: ChangeNotifierProvider<Auth>(
              create: (context) => Auth(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Earn Show",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: Colors.white),
                          ),
                          Text(
                            "A trendy way to earn money",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            child: Text(
                              "Forgot Password!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (passwordResetEmail == null)
                      Column(
                        children: [
                          Form(
                            key: _formKeyResetEmail,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextInputWithIcon(
                                labelText: "Email",
                                iconName: Icons.email_rounded,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the password';
                                  }
                                },
                                onSave: (value) => {_email = value},
                              ),
                            ),
                          ),
                          CircularButton(
                            isLoading: _isLoading,
                            onTap: () => this.passwordResetEmail(),
                          )
                        ],
                      ),
                    if (passwordResetEmail != null && passwordResetCode == null)
                      Column(
                        children: [
                          Form(
                            key: _formKeyResetCode,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextInputWithIcon(
                                labelText: "code",
                                iconName: Icons.verified_outlined,
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the password';
                                  }
                                },
                                onSave: (value) => {_code = value},
                              ),
                            ),
                          ),
                          CircularButton(
                            isLoading: _isLoading,
                            onTap: () => this.passwordResetVerify(),
                          )
                        ],
                      ),
                    if (passwordResetEmail != null && passwordResetCode != null)
                      Form(
                        key: _formKeyRestChangePassword,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextInputWithIcon(
                                labelText: "New Password",
                                iconName: Icons.vpn_key,
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the password';
                                  }
                                },
                                onSave: (value) => {_newPassword = value},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              child: TextInputWithIcon(
                                labelText: "Confirm Password",
                                iconName: Icons.vpn_key,
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the password';
                                  }
                                },
                                onSave: (value) => {_confirmPassword = value},
                              ),
                            ),
                            CircularButton(
                              isLoading: _isLoading,
                              onTap: () => this.passwordResetChangePassword(),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
