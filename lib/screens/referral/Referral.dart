import 'dart:math';

import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Referral extends StatelessWidget {
  static final routeName = '/referral';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showRefMessage(String refCode) {
    String share =
        "How to Earn money online upto Earn Rs 40,000 join  now Earnshow App Referral Earn unlimited\nUsed my Refer code : " +
            refCode +
            "\nhttps://play.google.com/store/apps/details?id=com.kelous.EarnShow";

    Share.text(share, share, 'text/plain');
//    Fluttertoast.showToast(
//        msg: "App need to be on Google Play to share the link!");
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
        currentScreen: "Refferal",
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          height: DEVICE_SIZE.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  "Your referral code",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  Provider.of<Auth>(context, listen: false).referralCode,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.blue, // button color
                  child: InkWell(
                    onTap: () => {
                      _showRefMessage(Provider.of<Auth>(context, listen: false)
                          .referralCode)
                    },
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
    );
  }
}
