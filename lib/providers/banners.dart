import 'dart:convert';
import 'package:EarnShow/constants.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import "dart:math";

class EarnShowBanner with ChangeNotifier {
  String url;
  String image;
  bool isDashboardBanner;

  EarnShowBanner({this.url, this.image, this.isDashboardBanner});

  String get bannerUrl => url;
}

class Banners extends ChangeNotifier {
  List<EarnShowBanner> _banners = [];
  String authToken;

  void updates(String authToken, List<EarnShowBanner> banners) {
    this.authToken = authToken;
    this._banners = banners;
  }

  Future<void> fetchBanner() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/banner/',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        List banners = jsonDecode(response.body)['results'];
        print(banners);
        if (banners != null) {
          this._banners = [];
          banners.forEach((banner) {
            this._banners.add(EarnShowBanner(
                url: banner['url'],
                image: banner['banner'],
                isDashboardBanner: banner['is_dashboard_banner']));
          });
        }
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: " Error in loading Banner!",
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.BOTTOM_LEFT);
    }
  }

  String get authTokenHeader => this.authToken;

  EarnShowBanner get dashboardBanner {
    if (_banners.length > 0) {
      try {
        final dashboardBanner = _banners.firstWhere((banner) =>
            banner.isDashboardBanner != null &&
            banner.isDashboardBanner == true);
        return dashboardBanner;
      } catch (e) {
        return null;
      }
    }
  }

  EarnShowBanner get getRandomBanner {
    if (_banners.length > 0) {
      final _random = new Random();
      var banner = _banners[_random.nextInt(_banners.length)];
      return banner;
    }
  }

  List<EarnShowBanner> get banners => [..._banners];
}
