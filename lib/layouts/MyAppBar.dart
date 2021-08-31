import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/shop/Checkout.dart';
import 'package:EarnShow/screens/shop/ProductDetails.dart';
import 'package:EarnShow/screens/shop/ShopListScreen.dart';
import 'package:EarnShow/screens/shop/newcheckout.dart';
import 'package:EarnShow/screens/videos/UploadVideoScreen.dart';
import 'package:EarnShow/screens/videos/VideoListScreen.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar = AppBar();
  final String title;
  final Function openEndDrawer;
  final String currentScreen;
  final BuildContext cxt;

  MyAppBar({this.title, this.currentScreen, this.openEndDrawer, this.cxt});

  void pop(context) {
    if (ModalRoute.of(context).settings.name != '/dashboard' &&
        ModalRoute.of(context).settings.name != '/') {
      routeToReplacement(context, Dashboard.routeName, {});
    }
  }

  void goToCheckout(BuildContext context) {
    if (Provider.of<Cart>(context, listen: false).products.length > 0) {
//      routeTo(context, Checkout.routeName, {});
      print("Working Navigation To New Check OUT");
      print("Working Navigation To New Check OUT");
      print("Working Navigation To New Check OUT");

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewCheckout()));
    } else {
      Fluttertoast.showToast(msg: "Please add items to cart first!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<Auth>(context, listen: false).firstName;
    final _cartItemCount = Provider.of<Cart>(context).itemCount;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white10,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Earn Show",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Theme.of(context).secondaryHeaderColor),
      ),
      leading: new ClipOval(
        child: SizedBox(
          height: 50,
          width: 50,
          child: Material(
            child: InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColorDark,
              ),
              onTap: () => pop(cxt),
            ),
          ),
        ),
      ),
      actions: [
        new FlatButton(
          textColor: Colors.white,
          onPressed: openEndDrawer,
          child: Image.asset('assets/icons/drawer.png'),
          shape: CircleBorder(
            side: BorderSide(color: Colors.transparent),
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.currentScreen,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).secondaryHeaderColor),
              ),
              if (ModalRoute.of(context).settings.name ==
                  VideoListScreen.routeName)
                Container(
                  padding: EdgeInsets.only(right: 30),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        onTap: () =>
                            routeTo(context, UploadVideoScreen.routeName, {}),
                      ),
                    ),
                  ),
                )
              else
                Container(),
              if (ModalRoute.of(context).settings.name ==
                      ShopListScreen.routeName ||
                  ModalRoute.of(context).settings.name ==
                      ProductDetails.routeName)
                Container(
                  padding: EdgeInsets.only(right: 30),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Material(
                          child: InkWell(
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Theme.of(context)
                                      .secondaryHeaderColor, // button color
                                )),
                            onTap: () => goToCheckout(context),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Text(
                            _cartItemCount.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(
        appBar.preferredSize.height + 25,
      );
}
