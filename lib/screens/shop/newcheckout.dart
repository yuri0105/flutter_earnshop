import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/screens/payment/RazorPayPayment.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CheckoutItem.dart';

class NewCheckout extends StatefulWidget {
  @override
  _NewCheckoutState createState() => _NewCheckoutState();
}

class _NewCheckoutState extends State<NewCheckout> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white10,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Checkout',
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
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Provider.of<Cart>(context).orderId != null
          ? Container(
              margin: EdgeInsets.only(top: 30),
              child: FlatButton(
                onPressed: () =>
                    routeTo(context, RazorPayPayment.routeName, {}),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "MakePayment",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Montserrat'),
                    ),
                    Text(
                      "  ₹ " +
                          (Provider.of<Cart>(context).totalAmount / 100)
                              .toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.white),
                    ),
                  ],
                ),
                color: Theme.of(context).primaryColorDark,
                minWidth: DEVICE_SIZE.width,
              ),
            )
          : Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  FlatButton(
                    onPressed: () =>
                        Provider.of<Cart>(context, listen: false).createOrder(),
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Montserrat'),
                    ),
                    color: Theme.of(context).primaryColorDark,
                    minWidth: DEVICE_SIZE.width,
                  ),
                ],
              ),
            ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 10,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckoutItem(
                            productImage: products[index].image,
                            amount: products[index].amount,
                            brand: products[index].brand,
                            title: products[index].title,
                            // rating: products[index].rating != null
                            //     ? products[index].rating.toDouble()
                            //     : 0.toDouble(),
                          ),
                        ),
                      )),
            ),
    );
  }
}
