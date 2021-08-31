import 'package:EarnShow/screens/ForgotPassword.dart';
import 'package:EarnShow/screens/Profile.dart';
import 'package:EarnShow/screens/SignUp.dart';
import 'package:flutter/material.dart';
import '../layouts/TextInputWithIcon.dart';
import './Dashboard.dart';
import '../utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:EarnShow/providers/auth.dart';

class Login extends StatefulWidget {
  static final routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // For Email and Password
  String _email;
  String _password;

  // For Loading
  bool _isloading = false;

  void onSubmit(context) async {
    setState(() {
      _isloading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_email.isEmpty || _password.isEmpty) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Required fields can't be empty!"),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          _isloading = false;
        });
        return;
      }
      await Provider.of<Auth>(context, listen: false)
          .signIn(context, this._email, this._password);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
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
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "A trendy way to earn money",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 10, bottom: 10),
                child: TextInputWithIcon(
                  labelText: "Email",
                  iconName: Icons.email,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSave: (value) => {this._email = value},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 10, bottom: 10),
                child: TextInputWithIcon(
                  labelText: "Password",
                  iconName: Icons.vpn_key,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the password';
                    }
                  },
                  onSave: (value) => {this._password = value},
                ),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Text(
                              "Sign In",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          _isloading
                              ? ClipOval(
                                  child: Material(
                                    color: Colors.white, // button color
                                    child: InkWell(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                )
                              : ClipOval(
                                  child: Material(
                                    color: Colors.blue, // button color
                                    child: InkWell(
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          )),
                                      onTap: () => onSubmit(context),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () =>
                                routeTo(context, ForgotPassword.routeName, {}),
                            child: Text(
                              "Forgot password",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              child: Text(
                                "Not on Earn show? ",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              onTap: () =>
                                  routeTo(context, SignUp.routeName, {}),
                              child: Text(
                                "Sign Up",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
