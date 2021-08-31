import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/components/ChangePassword.dart';
import 'package:EarnShow/layouts/HorizontalTabBar.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/layouts/RoundedButton.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/Login.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/shop/CheckoutItem.dart';
import 'package:EarnShow/screens/shop/TrackPackageTileLine.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../layouts/RecTextInputRightIcon.dart';

class Profile extends StatefulWidget {
  static final routeName = '/user-profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _addressFormKey = new GlobalKey<FormState>();
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
  var products = [];
  List<Product> _orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final profileProvider = Provider.of<Auth>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await profileProvider.getProfile();
      _isAddressExist = await profileProvider.fetchAddress();
      final shopProvider = Provider.of<Shop>(context, listen: false);
      try {
        products = [];
        await shopProvider.fetchOrders();
        _orders = shopProvider.orders;
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

  void showAddress(status) {
    setState(() {
      this.isAddressActive = status;
    });
  }

  void editAddress(status) {
    setState(() {
      this.isEditAddress = status;
    });
  }

  void showMyOrders(status) {
    if (_orders.length > 0) {
      setState(() {
        this._isOrderActive = status;
      });
    } else {
      Fluttertoast.showToast(
          msg: "You don't have any product!", timeInSecForIosWeb: 5);
    }
  }

  Future<void> saveAddress() async {
    this._addressFormKey.currentState.save();
    if (_address == null || _address.isEmpty) {
      Fluttertoast.showToast(
          msg: "Address is required",
          backgroundColor: Colors.redAccent,
          timeInSecForIosWeb: 5);
      return;
    }
    if (_state == null || _address.isEmpty) {
      Fluttertoast.showToast(
          msg: "State is required",
          backgroundColor: Colors.redAccent,
          timeInSecForIosWeb: 5);
      return;
    }
    if (_dist == null || _address.isEmpty) {
      Fluttertoast.showToast(
          msg: "City is required",
          backgroundColor: Colors.redAccent,
          timeInSecForIosWeb: 5);
      return;
    }
    if (_pin == null || _address.isEmpty) {
      Fluttertoast.showToast(
          msg: "ZipCode is required",
          backgroundColor: Colors.redAccent,
          timeInSecForIosWeb: 5);
      return;
    }

    _isAddressUpdated = await Provider.of<Auth>(context, listen: false)
        .updateAddress(_address, _state, _dist, _pin);
    if (_isAddressUpdated) {
      Fluttertoast.showToast(
          msg: "Address Updated!",
          backgroundColor: Colors.greenAccent,
          timeInSecForIosWeb: 5);
      routeTo(context, Dashboard.routeName, {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;

    return Scaffold(
        endDrawer: SizedBox.expand(
          child: new Drawer(child: NavigationScreen()),
        ),
        key: _scaffoldKey,
        bottomNavigationBar: NavigationBarBottom(),
        appBar: MyAppBar(
          title: "Welcome",
          openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
          cxt: context,
          currentScreen: "Profile",
        ),
        body: _isLoading != null && _isLoading
            ? Center(child: CircularProgressIndicator())
            : Consumer<Auth>(
                builder: (context, authData, _) => SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Row(
                        children: [
                          authData.profilePhoto != null
                              ? Container(
                                  height: 60,
                                  width: 60,
                                  child: new Image.network(
                                    authData.profilePhoto,
                                    height: 60,
                                    width: 60,
                                  ),
                                )
                              : new Image.asset(
                                  'assets/icons/user.png',
                                  height: 60,
                                  width: 60,
                                ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authData.firstName != null
                                      ? authData.firstName
                                      : "First name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                Text(
                                  authData.username != null
                                      ? authData.username
                                      : "Username",
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 40),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          if (!isAddressActive)
                            HorizontalTabBar(
                              label: "My Address",
                              iconName: Icons.edit,
                              onTap: () => showAddress(true),
                            ),
                          if (isEditAddress ||
                              (isAddressActive && address.isEmpty))
                            Container(
                                width: DEVICE_SIZE.width * 0.9,
                                height: DEVICE_SIZE.width * 0.68,
                                margin: EdgeInsets.only(bottom: 25),
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      key: _addressFormKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                                labelText: "Address"),
                                            onSaved: (value) =>
                                                _address = value,
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                labelText: "State"),
                                            onSaved: (value) => _state = value,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: DEVICE_SIZE.width * 0.4,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: "City"),
                                                  onSaved: (value) =>
                                                      _dist = value,
                                                ),
                                              ),
                                              Container(
                                                width: DEVICE_SIZE.width * 0.35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: "ZipCode"),
                                                  onSaved: (value) =>
                                                      _pin = value,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            child: RaisedButton(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              onPressed: saveAddress,
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
                                ))
                          else if (isAddressActive)
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: address != null &&
                                        city != null &&
                                        zipCode != null &&
                                        state != null
                                    ? Card(
                                        elevation: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          width: DEVICE_SIZE.width * 0.9,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Address: " + address,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                "City: " + city,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                "State: " + state,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              if (zipCode != null)
                                                Text(
                                                  "ZipCode " + zipCode,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                  onPressed: () =>
                                                      editAddress(true),
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
                                      )
                                    : Container()),
                          if (!_isOrderActive)
                            HorizontalTabBar(
                              label: "My Orders",
                              onTap: () => showMyOrders(true),
                            )
                          else
                            Container(
                              child: SizedBox(
                                height: DEVICE_SIZE.height * 0.3,
                                child: ListView.builder(
                                    itemCount: _orders.length,
                                    itemBuilder: (context, index) => Row(
                                          children: [
                                            Container(
                                              height: DEVICE_SIZE.width * 0.2,
                                              width: DEVICE_SIZE.width * 0.2,
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: _orders[index].image !=
                                                      null
                                                  ? Image.network(
                                                      _orders[index].image)
                                                  : Image.asset(
                                                      'assets/icons/user.png'),
                                            ),
                                            Container(
                                              width: DEVICE_SIZE.width * 0.5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _orders[index].brand,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                  Text(
                                                    _orders[index].title,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                  FlatButton(
                                                    child: Text("Track order"),
                                                    onPressed: () => routeTo(
                                                        context,
                                                        TrackPackageTimeLine
                                                            .routeName,
                                                        {
                                                          "productId":
                                                              _orders[index]
                                                                  .orderId
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                              ),
                            ),
                          HorizontalTabBar(
                            label: "Change Password",
                            onTap: () =>
                                routeTo(context, ChangePassword.routeName, {}),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 20),
                            child: RoundedButton(
                              label: "Sign out",
                              onClick: () =>
                                  routeTo(context, Login.routeName, {}),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
              ));
  }
}
