import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/wallet.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/wallet/RechargeScreen.dart';
import 'package:EarnShow/screens/wallet/Redeem.dart';
import 'package:EarnShow/screens/wallet/withdrawal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:provider/provider.dart';

class Wallet extends StatefulWidget {
  static final routeName = '/wallet';

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isLoading;
  var _balance;

  recharge(context, type) {
    routeTo(context, RechargeScreen.routeName, {"type": type});
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<WalletProvider>(context, listen: false).fetchBalance();
      setState(() {
        _balance = Provider.of<WalletProvider>(context, listen: false).balance;
      });
      setState(() {
        _isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        title: "Welcome",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Wallet",
      ),
      body: _isLoading != null && _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                            height: DEVICE_SIZE.height * 0.2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        "Balance",
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
                                    Text(
                                      _balance != null
                                          ? "Rs. " + _balance.toString()
                                          : "Rs. 0",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: FlatButton(
                                          child: Text("Withdrawal"),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Withdrawal()));
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => routeTo(context, Redeem.routeName, {}),
                      child: Card(
                        elevation: 8,
                        child: Container(
                            width: DEVICE_SIZE.width * 0.8,
                            height: DEVICE_SIZE.height * 0.2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        "Redeem EarnShow cash",
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
                                    Image.asset('assets/icons/cost.png')
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Recharge",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 50, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => recharge(context, "Prepaid"),
                            child: Container(
                              margin: EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 1),
                                            blurRadius: 2)
                                      ],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                          'assets/icons/mobile.png'),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Prepaid",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => recharge(context, "Postpaid"),
                            child: Container(
                              margin: EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 1),
                                            blurRadius: 2)
                                      ],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                          'assets/icons/mobile.png'),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Postpaid",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
