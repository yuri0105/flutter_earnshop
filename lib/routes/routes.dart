import 'package:EarnShow/screens/earn_offer/EarnOffer.dart';
import 'package:EarnShow/screens/games/Games.dart';
import 'package:EarnShow/screens/payment/RazorPayPayment.dart';
import 'package:EarnShow/screens/referral/Referral.dart';
import 'package:EarnShow/screens/shop/Checkout.dart';
import 'package:EarnShow/screens/shop/ProductDetails.dart';
import 'package:EarnShow/screens/shop/ShopListScreen.dart';
import 'package:EarnShow/screens/shop/TrackPackageTileLine.dart';
import 'package:EarnShow/screens/support.dart';
import 'package:EarnShow/screens/videos/UploadVideoScreen.dart';
import 'package:EarnShow/screens/videos/VideoListScreen.dart';
import 'package:EarnShow/screens/videos/VideoPlayerScreen.dart';
import 'package:EarnShow/screens/wallet/RechargeScreen.dart';
import 'package:EarnShow/screens/wallet/Redeem.dart';
import 'package:EarnShow/screens/wallet/Wallet.dart';
import 'package:EarnShow/stripe_payment_gateway/StripePayment.dart';
import 'package:flutter/material.dart';
import '../screens/Dashboard.dart';
import '../screens/Profile.dart';
import '../screens/ForgotPassword.dart';
import '../screens/SignUp.dart';
import '../screens/Login.dart';
import '../screens/NavigationScreen.dart';
import '../components/ChangePassword.dart';

final routes = {
  Profile.routeName: (ctx) => Profile(),
  Dashboard.routeName: (ctx) => Dashboard(),
  ForgotPassword.routeName: (ctx) => ForgotPassword(),
  Login.routeName: (ctx) => Login(),
  SignUp.routeName: (ctx) => SignUp(),
  NavigationScreen.routeName: (ctx) => NavigationScreen(),
  ChangePassword.routeName: (ctx) => ChangePassword(),
  VideoListScreen.routeName: (ctx) => VideoListScreen(),
  VideoPlayerScreen.routeName: (ctx) => VideoPlayerScreen(),
  UploadVideoScreen.routeName: (ctx) => UploadVideoScreen(),
  Wallet.routeName: (ctx) => Wallet(),
  Redeem.routeName: (ctx) => Redeem(),
  RechargeScreen.routeName: (ctx) => RechargeScreen(),
  Referral.routeName: (ctx) => Referral(),
  EarnOfferScreen.routeName: (ctx) => EarnOfferScreen(),
  Support.routeName: (ctx) => Support(),
  StripePayment.routeName: (ctx) => StripePayment(),
  GamesListScreen.routeName: (ctx) => GamesListScreen(),
  ShopListScreen.routeName: (ctx) => ShopListScreen(),
  ProductDetails.routeName: (ctx) => ProductDetails(),
  Checkout.routeName: (ctx) => Checkout(),
  RazorPayPayment.routeName: (ctx) => RazorPayPayment(),
  TrackPackageTimeLine.routeName: (ctx) => TrackPackageTimeLine(),
};
