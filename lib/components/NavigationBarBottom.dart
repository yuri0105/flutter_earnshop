import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/earn_offer/EarnOffer.dart';
import 'package:EarnShow/screens/games/Games.dart';
import 'package:EarnShow/screens/referral/Referral.dart';
import 'package:EarnShow/screens/shop/ShopListScreen.dart';
import 'package:EarnShow/screens/videos/VideoListScreen.dart';
import 'package:EarnShow/screens/wallet/Wallet.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationBarBottom extends StatefulWidget {
  @override
  _NavigationBarBottomState createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  var selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(0);
      routeToReplacement(context, Dashboard.routeName, {});
    } else if (index == 1) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(1);
      routeToReplacement(context, ShopListScreen.routeName, {});
    } else if (index == 2) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(2);
      routeToReplacement(context, VideoListScreen.routeName, {});
    } else if (index == 3) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(3);
      routeToReplacement(context, EarnOfferScreen.routeName, {});
    } else if (index == 4) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(4);
      routeToReplacement(context, Wallet.routeName, {});
    }
  }

  @override
  Widget build(BuildContext context) {
      selectedIndex = Provider.of<NavigationProvider>(context).currentScreen;
    return BottomNavigationBar(
      fixedColor: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColorDark,
      currentIndex: this.selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "Shop",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_filled),
          label: "Video",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: "EarnMore",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: "Wallet",
        ),
      ],
    );
  }
}
