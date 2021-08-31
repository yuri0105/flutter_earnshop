import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/banners.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/providers/review.dart';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/shop/Checkout.dart';
import 'package:EarnShow/screens/shop/Review.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static final routeName = '/product-details';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _isLoading = false;
  double _rating;
  String _description;

  @override
  void initState() {
    super.initState();
  }

  void addToCartAndCheckout(userId, _productId) {
    Provider.of<Cart>(context, listen: false).addToCart(userId, _productId);
    routeTo(context, Checkout.routeName, {});
  }

  Future<void> _submitReview(productId) async {
    _formKey.currentState.save();
    final isReviewd = await Provider.of<Reviews>(context, listen: false)
        .addReview(_rating.toInt(), _description, productId.toString());
    if (isReviewd) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final _productId = routeArgs['productId'];
    final _products =
        Provider.of<Shop>(context, listen: false).findProductById(_productId);
    final _isItemInCart = Provider.of<Cart>(context).isItemInCart(_productId);
    final userId = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
      appBar: MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Shop",
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ChangeNotifierProvider.value(
              value: _products,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: DEVICE_SIZE.width * 0.09,
                    right: DEVICE_SIZE.width * 0.09,
                    top: DEVICE_SIZE.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _products.brand,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(_products.title,
                        style: TextStyle(fontFamily: 'Montserrat')),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Row(children: [
                            RatingBar(
                              initialRating: _products.rating != null
                                  ? _products.rating.ceilToDouble()
                                  : 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
                              itemSize: 20,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            _products.noOfRating != null
                                ? Text(
                                    "(" + _products.noOfRating.toString() + ")",
                                    style: TextStyle(fontFamily: 'Montserrat'))
                                : Text("(0)",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                          ]),
                        ],
                      ),
                    ),
                    Card(
                      child: CarouselSlider(
                        options: CarouselOptions(),
                        items: _products.images.map((image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: DEVICE_SIZE.width * 0.9,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: Image.network(image),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "₹ " + _products.amount.toString(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: 'Montserrat'),
                        )
                      ],
                    ),
                    Container(
                      width: DEVICE_SIZE.width * 0.9,
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          !_isItemInCart
                              ? ButtonTheme(
                                  minWidth: DEVICE_SIZE.width - 5,
                                  child: OutlineButton(
                                    splashColor: Theme.of(context).primaryColor,
                                    onPressed: () => Provider.of<Cart>(context,
                                            listen: false)
                                        .addToCart(userId, _products),
                                    child: Text("Add to cart"),
                                    color: Theme.of(context).primaryColorDark,
                                    highlightedBorderColor:
                                        Theme.of(context).primaryColorDark,
                                  ),
                                )
                              : ButtonTheme(
                                  minWidth: DEVICE_SIZE.width - 5,
                                  child: OutlineButton(
                                    splashColor: Theme.of(context).primaryColor,
                                    onPressed: () => Provider.of<Cart>(context,
                                            listen: false)
                                        .deleteItemById(userId, _productId),
                                    child: Text(
                                      "Remove from cart",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    color: Theme.of(context).primaryColorDark,
                                    highlightedBorderColor:
                                        Theme.of(context).primaryColorDark,
                                  ),
                                ),
                          FlatButton(
                            onPressed:
                                Provider.of<Cart>(context).products.length > 0
                                    ? () =>
                                        routeTo(context, Checkout.routeName, {})
                                    : () =>
                                        addToCartAndCheckout(userId, _products),
                            child: Text(
                              "Buy now",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                            color: Theme.of(context).primaryColorDark,
                            minWidth: DEVICE_SIZE.width - 5,
                          )
                        ],
                      ),
                    ),
                    Consumer<Reviews>(
                        builder: (context, product, _) => Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text(
                                      "Reviews",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ]),
                                  Center(
                                    child: RaisedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Stack(
                                                  overflow: Overflow.visible,
                                                  children: <Widget>[
                                                    Positioned(
                                                      right: -40.0,
                                                      top: -40.0,
                                                      child: InkResponse(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: CircleAvatar(
                                                          child:
                                                              Icon(Icons.close),
                                                        ),
                                                      ),
                                                    ),
                                                    Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          RatingBar(
                                                            initialRating: 3,
                                                            minRating: 1,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              _rating = rating;
                                                            },
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child:
                                                                TextFormField(
                                                              onSaved: (value) =>
                                                                  _description =
                                                                      value,
                                                              decoration:
                                                                  InputDecoration(
                                                                      enabledBorder:
                                                                          const OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              0.0,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              0.0,
                                                                        ),
                                                                      ),
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              20.0,
                                                                          color: Colors
                                                                              .grey),
                                                                      labelText:
                                                                          "Write your Review..."),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: RaisedButton(
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                child: Text(
                                                                  "Submit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                onPressed: () =>
                                                                    _submitReview(
                                                                        _productId)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      child: Text(
                                        "Add Review",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // Comments
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 30),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 300.0,
                                          child: new ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: product.reviews.length,
                                            itemBuilder: (context, index) =>
                                                Review(
                                              description:
                                                  product.reviews[index].review,
                                              creatorName: product
                                                  .reviews[index].creatorName,
                                              creatorImageURL: product
                                                  .reviews[index].creatorImage,
                                              star: product.reviews[index].star,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                  ],
                ),
              ),
            ),
    );
  }
}
