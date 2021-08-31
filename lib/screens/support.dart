import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/constants.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/layouts/RecTextInputRightIcon.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Support extends StatefulWidget {
  static final routeName = '/support';

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _title;
  String _description;

  void submit() async {
    final token = Provider.of<Auth>(context, listen: false).token;
    _formKey.currentState.save();
    if (_title.isEmpty || _description.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Required Fields can't be empty",
            style: TextStyle(color: Colors.grey),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    try {
      final response = await http.post(DEFAULT_HOST_URL + '/accounts/support/',
          body: {"subject": _title, "description": _description},
          headers: {"Authorization": "Token " + token.toString()});
      if (response.statusCode == 201) {
        _formKey.currentState.reset();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Thanks! We have received your query, Will contact you soon.",
              style: TextStyle(color: Colors.grey),
            ),
            backgroundColor: Colors.greenAccent,
          ),
        );
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Customer Support",
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: DEVICE_SIZE.width * 0.9,
            margin: EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(5, 5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: TextFormField(
                      onSaved: (value) => _title = value,
                      decoration: InputDecoration(
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
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.grey),
                          labelText: "Subject Title"),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(5, 5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: TextFormField(
                      onSaved: (value) => _description = value,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
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
                          alignLabelWithHint: true,
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.grey),
                          labelText: "Description"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () => submit(),
                          child: SizedBox(
                            width: 100,
                            height: 50,
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          color: Theme.of(context).secondaryHeaderColor,
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
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
    );
  }
}
