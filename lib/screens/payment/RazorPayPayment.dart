import 'package:EarnShow/constants.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/Profile.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RazorPayPayment extends StatefulWidget {
  static final routeName = '/razorpay-payment';

  @override
  _RazorPayPaymentState createState() => _RazorPayPaymentState();
}

class _RazorPayPaymentState extends State<RazorPayPayment> {
  final API_KEY = 'rzp_live_lXzIJTzm5PQidq';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Razorpay _razorpay;

  bool _isLoading;
  bool isAddressActive = false;
  String address;
  String state;
  String city;
  String zipCode;
  String _address;
  String _state;
  String _dist;
  String _pin;
  bool _isAddressExist;
  bool _isAddressUpdated;
  bool isEditAddress = false;
  bool _isOrderActive = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<Auth>(context, listen: false).getProfile();
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    final profileProvider = Provider.of<Auth>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await profileProvider.getProfile();
      _isAddressExist = await profileProvider.fetchAddress();
      try {
        setState(() {
          address = profileProvider.address;
          city = profileProvider.city;
          state = profileProvider.state;
          zipCode = profileProvider.zipCode;
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void openCheckout() async {
    var options = {
      // 'key': API_KEY,
      'key': RAZORPAY_API_KEY,
      'amount': Provider.of<Cart>(context, listen: false).totalAmount,
      'name': Provider.of<Auth>(context, listen: false).firstName,
      'description': 'EarnShow Product',
      'order_id': Provider.of<Cart>(context, listen: false)
          .orderId, // Generate order_id using Orders API
      'prefill': {'email': Provider.of<Auth>(context, listen: false).email},
      'external': {
        'wallets': ['paytm']
      }
    };

    print(options);

    try {
      _razorpay.open(options);
    } catch (e) {
      // debugPrint(e);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Provider.of<Cart>(context, listen: false)
        .paymentDone(response.paymentId);
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    routeTo(context, Dashboard.routeName, {});
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;

    return Scaffold(
        appBar: MyAppBar(
          title: "Welcome",
          openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
          cxt: context,
          currentScreen: "Checkout",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Order Details',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            Card(
              margin: EdgeInsets.all(10),
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          (Provider.of<Cart>(context, listen: false)
                                      .totalAmount /
                                  100)
                              .toDouble()
                              .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          (Provider.of<Cart>(context, listen: false)
                                      .totalAmount /
                                  100)
                              .toDouble()
                              .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
//            Container(
//              child: Column(
//                children: [
//                  Text("Shipping and Billing Address"),
//                  Text(address ?? ''),
//                ],
//              ),
//            ),
//            Container(
//              child: CheckboxListTile(),
//            ),
            Divider(),
            Container(
              width: DEVICE_SIZE.width,
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  FlatButton(
                    onPressed: () => openCheckout(),
                    child: Text(
                      "Pay Now",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Montserrat'),
                    ),
                    color: Theme.of(context).primaryColorDark,
                    minWidth: DEVICE_SIZE.width * 0.7,
                  ),
                ],
              ),
            )
          ],
        ));
    ;
  }
}
