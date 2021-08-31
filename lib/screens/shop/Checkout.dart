import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/banners.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/payment/RazorPayPayment.dart';
import 'package:EarnShow/screens/shop/CheckoutItem.dart';
import 'package:EarnShow/screens/shop/Review.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  static final routeName = '/checkout';

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _isLoading = false;
  List<Product> products = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      final cartItems = Provider.of<Cart>(context, listen: false).products;
      cartItems.forEach((product) {
        print(product);
        // products.add(Provider.of<Shop>(context, listen: false)
        //     .findProductById(productId));
        products.add(product);
      });
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
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
        title: "Welcome",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Checkout",
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.only(top: DEVICE_SIZE.height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: DEVICE_SIZE.width * 0.9,
                    child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) => CheckoutItem(
                              productImage: products[index].image,
                              amount: products[index].amount,
                              brand: products[index].brand,
                              title: products[index].title,
                              // rating: products[index].rating != null
                              //     ? products[index].rating.toDouble()
                              //     : 0.toDouble(),
                            )),
                  ),
                  Text(
                    "Total Amount: " +
                        (Provider.of<Cart>(context).totalAmount / 100)
                            .toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  Provider.of<Cart>(context).orderId != null
                      ? Container(
                          margin: EdgeInsets.only(top: 30),
                          child: FlatButton(
                            onPressed: () =>
                                routeTo(context, RazorPayPayment.routeName, {}),
                            child: Text(
                              "MakePayment",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                            color: Theme.of(context).primaryColorDark,
                            minWidth: DEVICE_SIZE.width * 0.5,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 30),
                          child: FlatButton(
                            onPressed: () =>
                                Provider.of<Cart>(context, listen: false)
                                    .createOrder(),
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                            color: Theme.of(context).primaryColorDark,
                            minWidth: DEVICE_SIZE.width * 0.5,
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
