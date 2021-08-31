import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/banners.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/providers/review.dart';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/shop/ProductDetails.dart';
import 'package:EarnShow/screens/shop/ShopGridItem.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopListScreen extends StatefulWidget {
  static final routeName = '/shop-list';

  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(1);
      setState(() {
        _isLoading = true;
      });
      final bannerProvider = Provider.of<Banners>(context, listen: false);
      final shopProvider = Provider.of<Shop>(context, listen: false);
      final userId = Provider.of<Auth>(context, listen: false).userId;
      await Provider.of<Cart>(context, listen: false).fetchItemsInCart(userId);
      if (bannerProvider.banners.length == 0) {
        await bannerProvider.fetchBanner();
      }
      if (shopProvider.products.length == 0) {
        await shopProvider.fetchProducts();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshShop() async {
    await Provider.of<Banners>(context, listen: false).fetchBanner();
    await Provider.of<Shop>(context, listen: false).fetchProducts();
  }

  Future<void> _gotToProductDetails(productId) async {
    final authToken = Provider.of<Shop>(context, listen: false).authToken;
    await Provider.of<Reviews>(context, listen: false)
        .fetchReviews(authToken, productId);
    routeTo(context, ProductDetails.routeName, {"productId": productId});
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;

    final _randomBanner =
        Provider.of<Banners>(context, listen: false).getRandomBanner;
    final _products = Provider.of<Shop>(context, listen: false).products;
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
        currentScreen: "Shop",
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshShop,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        if (_randomBanner != null)
                          Container(
                            height: DEVICE_SIZE.height * 0.28,
                            child: InkWell(
                              onTap: () =>
                                  chromeTab(context, _randomBanner.url),
                              child: Container(
                                height: DEVICE_SIZE.height * 0.28,
                                width: DEVICE_SIZE.width,
                                margin: EdgeInsets.only(
                                    bottom: DEVICE_SIZE.height * 0.005),
                                alignment: Alignment.center,
                                child: _randomBanner != null &&
                                        _randomBanner.image.isNotEmpty
                                    ? Image.network(
                                        _randomBanner.image,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Center(
                                        child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
//                  Container(
//                    child: SingleChildScrollView(
//                      scrollDirection: Axis.horizontal,
//
//                    ),
//                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          child: InkWell(
                            onTap: () =>
                                _gotToProductDetails(_products[index].id),
                            child: new ShopGridItem(
                              id: _products[index].id,
                              image: _products[index].image,
                              title: _products[index].title,
                              brand: _products[index].brand,
                              amount: _products[index].amount,
                              rating: _products[index].rating,
                              noOfRating: _products[index].noOfRating,
                            ),
                          ),
                        );
                      },
                      childCount: _products.length,
                    ),
                  ),
                ],
              ),
            ),
//      SingleChildScrollView(
//              child: Column(
//                children: <Widget>[
//                  if (_randomBanner != null)
//                    SizedBox(
//                      height: DEVICE_SIZE.height * 0.28,
//                      child: InkWell(
//                        onTap: () => chromeTab(context, _randomBanner.url),
//                        child: Container(
//                          height: DEVICE_SIZE.height * 0.28,
//                          width: DEVICE_SIZE.width,
//                          margin: EdgeInsets.only(
//                              bottom: DEVICE_SIZE.height * 0.005),
//                          alignment: Alignment.center,
//                          child: _randomBanner != null &&
//                                  _randomBanner.image.isNotEmpty
//                              ? Image.network(
//                                  _randomBanner.image,
//                                  fit: BoxFit.fitWidth,
//                                )
//                              : Center(child: CircularProgressIndicator()),
//                        ),
//                      ),
//                    ),
//                  SizedBox(
//                    height: DEVICE_SIZE.height * 0.72,
//                    child: RefreshIndicator(
//                      onRefresh: _refreshShop,
//                      child: GridView.builder(
//                          itemCount: _products.length,
//                          gridDelegate:
//                              SliverGridDelegateWithFixedCrossAxisCount(
//                                  crossAxisCount: 2),
//                          itemBuilder: (context, index) {
//                            return Column(
//                              children: [
//                                Flexible(
//                                  fit: FlexFit.tight,
//                                  child: InkWell(
//                                    onTap: () => _gotToProductDetails(
//                                        _products[index].id),
//                                    child: new ShopGridItem(
//                                      id: _products[index].id,
//                                      image: _products[index].image,
//                                      title: _products[index].title,
//                                      brand: _products[index].brand,
//                                      amount: _products[index].amount,
//                                      rating: _products[index].rating,
//                                      noOfRating: _products[index].noOfRating,
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            );
//                          }),
//                    ),
//                  )
//                ],
//              ),
//            ),
    );
  }
}
