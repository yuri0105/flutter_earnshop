import 'dart:convert';

import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/banners.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/providers/wallet.dart';
import 'package:EarnShow/screens/AdmobBanner.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/earn_offer/EarnOffer.dart';
import 'package:EarnShow/screens/games/Games.dart';
import 'package:EarnShow/screens/shop/ShopListScreen.dart';
import 'package:EarnShow/screens/support.dart';
import 'package:EarnShow/screens/videos/VideoListScreen.dart';
import 'package:EarnShow/screens/wallet/Wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../layouts/HomeGridItem.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  static final routeName = '/dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isLoading = true;
  List _dashBoardLinks = [];

  void pop(context) {
    if (ModalRoute.of(context).settings.name != '/dashboard') {
      Navigator.pop(context);
    }
  }

  String _authToken = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(0);
      setState(() {
        _isLoading = true;
      });

      final bannerProvider = Provider.of<Banners>(context, listen: false);
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      await Provider.of<Auth>(context, listen: false).getProfile();
      if (bannerProvider.banners.length == 0) {
        await bannerProvider.fetchBanner();
      }
      if (walletProvider.balance == null) {
        await walletProvider.fetchBalance();
      }
      setState(() {
        _isLoading = false;
      });
    });
    _getdashboardlinks();
  }

  _getdashboardlinks() async {
    _authToken = Provider.of<Banners>(context, listen: false).authTokenHeader;
    print('Authentication Token' + _authToken);
    final response = await http.get(DEFAULT_HOST_URL + '/dashboardlinks/',
        headers: {"Authorization": "Token " + this._authToken.toString()});
    _dashBoardLinks = jsonDecode(response.body)['results'];
    print('Dashboard Link ' + this._dashBoardLinks.toString());
  }

  List<String> _banners = [
    'https://redirect.is/r4o3p83',
    'https://redirect.is/np6z36p',
    'https://redirect.is/vafy2ah',
    'https://redirect.is/5at5tmb',
    'https://redirect.is/b7u811x',
    'https://t.me/EarnShowOfficial',
    'https://youtube.com/c/EarnShowOfficial'
  ];

  void _showRefMessage() {
    Fluttertoast.showToast(
        msg: "App need to be on Google Play to share the link!");
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;

    final _dashboardBanner =
        Provider.of<Banners>(context, listen: false).dashboardBanner;
    print(_dashboardBanner);

    return Consumer<Auth>(
      builder: (context, authData, _) => Scaffold(
        key: _scaffoldKey,
        appBar: new MyAppBar(
          title: "Welcome",
          openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
          cxt: context,
          currentScreen: "",
        ),
        body: _isLoading == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(
//                            10,
//                          ),
//                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(
                              0xff005C97,
                            ),
                            const Color(
                              0xff4CB8C4,
                            ),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
//                      margin: EdgeInsets.only(
//                        left: 10,
//                        right: 10,
//                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 1.0,
                          bottom: 1.0,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Earnings",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: DEVICE_SIZE.width * 0.047),
                              ),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "₹ ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  DEVICE_SIZE.width * 0.045,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Consumer<WalletProvider>(
                                          builder: (context, wallet, _) => Text(
                                            wallet.balance != null
                                                ? wallet.balance.toString()
                                                : "0",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    DEVICE_SIZE.width * 0.06,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      height: 1.7,
                    ),
                    Container(
                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(
//                            10,
//                          ),
//                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(
                              0xff005C97,
                            ),
                            const Color(
                              0xff4CB8C4,
                            ),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
//                      margin: EdgeInsets.only(
//                        left: 10,
//                        right: 10,
//                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 1.0,
                          bottom: 1.0,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Team",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: DEVICE_SIZE.width * 0.047),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.accessibility_new,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: authData.totalReferrals != null
                                        ? Text(
                                            authData.totalReferrals,
                                            style: TextStyle(
                                              fontSize:
                                                  DEVICE_SIZE.width * 0.07,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "0",
                                            style: TextStyle(
                                              fontSize:
                                                  DEVICE_SIZE.width * 0.07,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      height: 1.7,
                    ),
                    Container(
//                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                right: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5,
                                  ),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color(
                                      0xff005C97,
                                    ),
                                    const Color(
                                      0xff4CB8C4,
                                    ),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Withdrawal',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                left: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5,
                                  ),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color(
                                      0xff005C97,
                                    ),
                                    const Color(
                                      0xff4CB8C4,
                                    ),
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Recharge',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.phone_android,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: DEVICE_SIZE.height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
//                      decoration: BoxDecoration(
//                        boxShadow: const [
//                          BoxShadow(
//                            color: Colors.black12,
//                            blurRadius: 2,
//                            offset: Offset(1, 1),
//                          ),
//                        ],
//                        color: Colors.white,
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(
//                            12,
//                          ),
//                        ),
//                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  HomeGridItem('assets/icons/supermarket.png',
                                      "SHOP", ShopListScreen.routeName),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  HomeGridItem('assets/icons/play.png', "VIDEO",
                                      VideoListScreen.routeName),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  HomeGridItem('assets/icons/wallet.png',
                                      "EarnMore ", EarnOfferScreen.routeName),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  HomeGridItem('assets/icons/joystick.png',
                                      "GAMES", GamesListScreen.routeName),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  HomeGridItem('assets/icons/wallet.png',
                                      "Wallet", Wallet.routeName),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  HomeGridItem(
                                      'assets/icons/customer_support.png',
                                      "Support",
                                      Support.routeName),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_dashboardBanner != null)
                      InkWell(
                        onTap: () => chromeTab(context, _dashboardBanner.url),
                        child: Container(
                          height: DEVICE_SIZE.height * 0.28,
                          width: DEVICE_SIZE.width,
                          alignment: Alignment.center,
                          child: _dashboardBanner != null &&
                                  _dashboardBanner.image.isNotEmpty
                              ? Image.network(
                                  _dashboardBanner.image,
                                  fit: BoxFit.fitWidth,
                                )
                              : Text("Loading..."),
                        ),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(
//                            10,
//                          ),
//                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(
                              0xff005C97,
                            ),
                            const Color(
                              0xff4CB8C4,
                            ),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
//                      margin: EdgeInsets.only(
//                        left: 10,
//                        right: 10,
//                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 1.0,
                          bottom: 1.0,
                          right: 8,
                          left: 8,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Refferal",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: DEVICE_SIZE.width * 0.047),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: authData.totalReferrals != null
                                        ? Text(
                                            'Ravi411',
                                            style: TextStyle(
                                              fontSize:
                                                  DEVICE_SIZE.width * 0.047,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "Ravi411",
                                            style: TextStyle(
                                              fontSize:
                                                  DEVICE_SIZE.width * 0.047,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    AdmobBannerComponent()
                  ],
                ),
              ),
        endDrawer: SizedBox.expand(
          child: new Drawer(
            child: NavigationScreen(),
          ),
        ),
        bottomNavigationBar: NavigationBarBottom(),
      ),
    );
  }
}
