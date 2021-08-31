import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../layouts/TextInputWithIcon.dart';
import '../utils/helpers.dart';

class SignUp extends StatefulWidget {
  static final routeName = '/signup';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _authData = {};
  String _name;
  String _email;
  String _phone;
  String _password;
  String _confirmPassword;
  String _referralCode;
  bool _isLoading = false;

  bool _isPasswordFormated = true;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future submit(context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_name.isEmpty ||
          _password.isEmpty ||
          _email.isEmpty ||
          _confirmPassword.isEmpty) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Required fields can't be empty"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_password != _confirmPassword) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Password must match"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (!validateStructure(_password)) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Password is not strong enough!"),
            backgroundColor: Colors.red,
          ),
        );
      }
      Future.delayed(Duration.zero).then((value) async => {
            setState(() {
              _isLoading = true;
            }),
            await Provider.of<Auth>(context, listen: false)
                .signUp(context, _name, _email, _password, _referralCode),
            setState(() {
              _isLoading = false;
            }),
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                          "Let get you started!",
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  child: TextInputWithIcon(
                    labelText: "Name",
                    iconName: Icons.person,
                    onSave: (value) => {this._name = value},
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
                    labelText: "Phone",
                    iconName: Icons.phone,
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Invalid Phone Number!';
                      }
                    },
                    onSave: (value) => {this._phone = value},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  child: TextInputWithIcon(
                    labelText: "Password",
                    iconName: Icons.lock,
                    obscureText: true,
                    onSave: (value) => {this._password = value},
                    error: !_isPasswordFormated,
                    onChange: (value) {
                      String pattern =
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                      RegExp regExp = new RegExp(pattern);
                      _isPasswordFormated = regExp.hasMatch(value);
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  child: Text(
                    "Password must have one small, large, symbol and numeric character with min length of 8.",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black38,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  child: TextInputWithIcon(
                    labelText: "Confirm password",
                    iconName: Icons.lock,
                    obscureText: true,
                    onSave: (value) => {this._confirmPassword = value},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  child: TextInputWithIcon(
                    labelText: "Referral code",
                    iconName: Icons.group,
                    onSave: (value) => {this._referralCode = value},
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.15,
                      right: MediaQuery.of(context).size.width * 0.15,
                      top: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Text(
                                "Sign Up",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Consumer<Auth>(
                                    builder: (ctx, auth, child) => ClipOval(
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
                                          // onTap: () => submit(context),
                                          onTap: () => submit(context),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: InkWell(
                                child: Text(
                                  "Already on Earn show? ",
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
                                onTap: () => routeToReplacement(
                                    context, Login.routeName, {}),
                                child: Text(
                                  "Sign In",
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
        ),
      )),
    );
  }
}
