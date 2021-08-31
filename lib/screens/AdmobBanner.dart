import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';

class AdmobBannerComponent extends StatefulWidget {
  @override
  _AdmobBannerComponentState createState() => _AdmobBannerComponentState();
}

class _AdmobBannerComponentState extends State<AdmobBannerComponent> {
  final KEY = 'ca-app-pub-4553747661134607/14320714089';

  @override
  void initState() {
    Admob.initialize();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdmobBanner(
      adUnitId: KEY,
      adSize: AdmobBannerSize.FULL_BANNER,
    );
  }
}
