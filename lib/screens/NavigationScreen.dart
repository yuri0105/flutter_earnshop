import 'package:EarnShow/layouts/RoundedButton.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/Login.dart';
import 'package:EarnShow/screens/earn_offer/EarnOffer.dart';
import 'package:EarnShow/screens/games/Games.dart';
import 'package:EarnShow/screens/referral/Referral.dart';
import 'package:EarnShow/screens/shop/ShopListScreen.dart';
import 'package:EarnShow/screens/support.dart';
import 'package:EarnShow/screens/videos/VideoListScreen.dart';
import 'package:EarnShow/screens/wallet/Wallet.dart';
import 'package:EarnShow/stripe_payment_gateway/StripePayment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../screens/Profile.dart';

class NavigationScreen extends StatelessWidget {
  static final routeName = '/navigation';
  final navigationRoutes = [
    {
      'title': 'DASHBOARD',
      'routeName': Dashboard.routeName,
      'arguments': {'profileId': 1}
    },
    {'title': 'MY PROFILE', 'routeName': Profile.routeName, 'arguments': {}},
    {'title': 'SHOP', 'routeName': ShopListScreen.routeName, 'arguments': {}},
    {
      'title': 'VIDEOS',
      'routeName': VideoListScreen.routeName,
      'arguments': {}
    },
    {'title': 'GAMES', 'routeName': GamesListScreen.routeName, 'arguments': {}},
    {'title': 'WALLET', 'routeName': Wallet.routeName, 'arguments': {}},
    {
      'title': 'EARN MORE',
      'routeName': EarnOfferScreen.routeName,
      'arguments': {}
    },
    {'title': 'REFER', 'routeName': Referral.routeName, 'arguments': {}},
    {
      'title': 'CUSTOMER SUPPORT',
      'routeName': Support.routeName,
      'arguments': {}
    },
  ];

  void _onPress(context, navigationItem) {
    var index =
        Provider.of<NavigationProvider>(context, listen: false).currentScreen;
    Navigator.pop(context);
    if (navigationItem['routeName'] == VideoListScreen.routeName) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(0);
    } else if (navigationItem['routeName'] == GamesListScreen.routeName) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(2);
    } else if (navigationItem['routeName'] == EarnOfferScreen.routeName) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(3);
    }
    routeToReplacement(
        context, navigationItem['routeName'], navigationItem['arguments']);
  }

  void signOut(context) async {
    Provider.of<Auth>(context, listen: false).signOut().then((_) => {
          routeTo(context, Login.routeName, {}),
        });
  }

  Iterable<Padding> generateNavigationList(context) {
    return navigationRoutes.map((navigationItem) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: (FlatButton(
            child: Text(
              navigationItem['title'],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Theme.of(context).primaryColorDark),
            ),
            onPressed: () => _onPress(context, navigationItem),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white10,
        elevation: 0,
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: Theme.of(context).primaryColorDark,
              size: 30,
            ),
            shape: CircleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          child: ListView(
            children: [
              ...generateNavigationList(context),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: RoundedButton(
                    label: "Sign out",
                    onClick: () => signOut(context),
                  ))
            ],
          )),
    );
  }
}
