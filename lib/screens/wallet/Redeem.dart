import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/constants.dart';

class Redeem extends StatelessWidget {
  static final routeName = '/redeem';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _redeemCodeFormValue;

  @override
  Widget build(BuildContext context) {
    void redeem(BuildContext context) async {
      final token = Provider.of<Auth>(context, listen: false).token;
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        final response = await http.post(DEFAULT_HOST_URL + '/redeem/',
            body: {"code": _redeemCodeFormValue},
            headers: {"Authorization": "Token " + token.toString()});
        if (response.statusCode == 201) {
          _formKey.currentState.reset();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "Redeem Successful",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.greenAccent,
            ),
          );
        }
      }
    }

    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Redeem",
      ),
      body: SingleChildScrollView(
        child: Container(
          width: DEVICE_SIZE.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Card(
                  elevation: 8,
                  child: Container(
                      width: DEVICE_SIZE.width * 0.8,
                      height: DEVICE_SIZE.height * 0.3,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Redeem EarnShow Cash",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                key: _formKey,
                                child: Container(
                                  width: DEVICE_SIZE.width * 0.4,
                                  child: TextFormField(
                                    onSaved: (value) =>
                                        _redeemCodeFormValue = value,
                                    textAlign: TextAlign.center,
                                    decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.teal)),
                                      hintText: 'Enter code',
                                    ),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: RaisedButton(
                              elevation: 5,
                              onPressed: () => redeem(context),
                              child: Text(
                                "REDEEM",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
    );
  }
}
