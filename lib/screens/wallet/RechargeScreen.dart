import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/recharge.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RechargeScreen extends StatefulWidget {
  static final routeName = '/recharge';

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _number;
  String _amount;
  String _provider;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Pay2All>(context, listen: false).fetchProviders();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void recharge() {
    _formKey.currentState.save();
    if (_number == null || _number.isEmpty) {
      Fluttertoast.showToast(
          msg: "Mobile no. is required!", timeInSecForIosWeb: 5);
    }
    if (_amount != null || _amount.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter amount!", timeInSecForIosWeb: 5);
    }
    if (_provider != null && _provider.isNotEmpty) {
      _formKey.currentState.save();
      Provider.of<Pay2All>(context, listen: false)
          .recharge(_number, _provider, _amount);
    } else {
      Fluttertoast.showToast(
          msg: "Please select a provider!", timeInSecForIosWeb: 5);
    }
  }

  void setProvider(String provider) {
    setState(() {
      _provider = provider;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
      appBar: MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Recharge",
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                width: DEVICE_SIZE.width,
                padding: EdgeInsets.only(left: DEVICE_SIZE.width * 0.1),
                margin: EdgeInsets.only(top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: DEVICE_SIZE.width * 0.8,
                        margin: EdgeInsets.only(bottom: 20, top: 20),
                        child: TextFormField(
                          onSaved: (value) => {_number = value},
                          decoration: InputDecoration(
                            labelText: "Enter Mobile no.",
                            prefix: Text("+91"),
                          ),
                        ),
                      ),
                      Container(
                        width: DEVICE_SIZE.width * 0.4,
                        child: TextFormField(
                          onSaved: (value) => {_amount = value},
                          decoration: InputDecoration(
                            labelText: "Amount",
                            prefix: Text("Rs."),
                          ),
                        ),
                      ),
                      Container(
                        child: Text("Min amount: Rs. 10"),
                        margin: EdgeInsets.only(bottom: 50, top: 5),
                      ),
                      SizedBox(
                        width: DEVICE_SIZE.width * 0.8,
                        height: 80,
                        child: new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              Provider.of<Pay2All>(context, listen: false)
                                  .mobileProviders
                                  .length,
                          itemBuilder: (context, index) => Card(
                            child: InkWell(
                              // onTap: () => recharge(
                              //     Provider.of<Pay2All>(context, listen: false)
                              //         .mobileProviders[index]['provider_id']
                              //         .toString()),
                              onTap: () => setProvider(
                                  Provider.of<Pay2All>(context, listen: false)
                                      .mobileProviders[index]['provider_id']
                                      .toString()),
                              child: Container(
                                  width: 80,
                                  height: 80,
                                  child: Center(
                                      child: Image.network(Provider.of<Pay2All>(
                                                  context,
                                                  listen: false)
                                              .mobileProviders[index]
                                          ['provider_image']))),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: RaisedButton(
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: () => recharge(),
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
