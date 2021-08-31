import 'package:EarnShow/providers/banners.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:EarnShow/providers/comments.dart';
import 'package:EarnShow/providers/earnOffers.dart';
import 'package:EarnShow/providers/games.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/providers/recharge.dart';
import 'package:EarnShow/providers/review.dart';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/providers/video.dart';
import 'package:EarnShow/providers/videos.dart';
import 'package:EarnShow/providers/wallet.dart';
import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/payment/RazorPayPayment.dart';
import 'package:EarnShow/screens/videos/UploadVideoScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/SignUp.dart';
import 'screens/Login.dart';
import 'screens/ForgotPassword.dart';
import 'routes/routes.dart';
import 'package:EarnShow/providers/auth.dart';

void main() {
  runApp(App());
  // SharedPreferences.setMockInitialValues({});
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: RazorPayPayment(),);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationProvider>.value(
          value: NavigationProvider(),
        ),
        ChangeNotifierProvider<Auth>.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Video>(
          create: (context) => Video(),
          update: (context, authData, previousVideo) =>
              previousVideo..updates(authData.token),
        ),
        ChangeNotifierProxyProvider<Auth, Videos>(
          create: (context) => Videos(),
          update: (context, auth, previousVideos) => previousVideos
            ..updates(auth.token,
                previousVideos == null ? [] : previousVideos.videos),
        ),
        ChangeNotifierProvider<EarnShowBanner>(
          create: (context) => EarnShowBanner(),
        ),
        ChangeNotifierProxyProvider<Auth, Banners>(
          create: (context) => Banners(),
          update: (context, auth, previousBanners) => previousBanners
            ..updates(auth.token,
                previousBanners == null ? [] : previousBanners.banners),
        ),
        ChangeNotifierProxyProvider<Auth, Games>(
          create: (context) => Games(),
          update: (context, auth, previousGames) => previousGames
            ..updates(
                auth.token, previousGames == null ? [] : previousGames.games),
        ),
        ChangeNotifierProxyProvider<Auth, EarnOffers>(
          create: (context) => EarnOffers(),
          update: (context, auth, previousEarnOffers) => previousEarnOffers
            ..updates(auth.token,
                previousEarnOffers == null ? [] : previousEarnOffers.offers),
        ),
        ChangeNotifierProxyProvider<Auth, Comments>(
          create: (context) => Comments(),
          update: (context, auth, previousComments) => previousComments
            ..updates(auth.token,
                previousComments == null ? [] : previousComments.comments),
        ),
        ChangeNotifierProxyProvider<Auth, WalletProvider>(
          create: (context) => WalletProvider(),
          update: (context, auth, previousWallet) =>
              previousWallet..updates(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Shop>(
          create: (context) => Shop(),
          update: (context, auth, previousProducts) =>
              previousProducts..updates(auth.token, previousProducts.products),
        ),
        ChangeNotifierProxyProvider<Auth, Product>(
          create: (context) => Product(),
          update: (context, auth, previousProducts) =>
              previousProducts..updates(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (context) => Cart(),
          update: (context, auth, previousCartItems) => previousCartItems
            ..updates(auth.token, previousCartItems.products),
        ),
        ChangeNotifierProxyProvider<Auth, Pay2All>(
          create: (context) => Pay2All(),
          update: (context, auth, previousPay2All) =>
              previousPay2All..updates(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Reviews>(
          create: (context) => Reviews(),
          update: (context, auth, previousReviews) =>
              previousReviews..updates(auth.token, previousReviews.getReviews),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'Earn Show',
          theme: new ThemeData(
            secondaryHeaderColor: Color(0xffF9AA33),
            primaryColorDark: Color(0xff024059),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: authData.isAuth
              ? new Dashboard()
              : new FutureBuilder(
                  future: authData.autoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : new Login(),
                ),
          routes: routes,
        ),
      ),
    );
  }
}
