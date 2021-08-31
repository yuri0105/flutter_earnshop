import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackPackageTimeLine extends StatefulWidget {
  static final routeName = '/track-package';

  @override
  _TrackPackageTimeLineState createState() => _TrackPackageTimeLineState();
}

class _TrackPackageTimeLineState extends State<TrackPackageTimeLine> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  var trackPackages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      final cartProvider = Provider.of<Cart>(context, listen: false);
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      final _productId = routeArgs['productId'];
      try {
        trackPackages = await cartProvider.trackPackage(_productId);
        print(trackPackages);
        print(trackPackages['stage_1']);
        print("2");
        print(trackPackages['stage_2']);
        print("3");
        print(trackPackages['stage_3']);
        print("4");
        print(trackPackages['stage_4']);
        print(trackPackages['is_delivered']);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: new MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Your package",
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(top: DEVICE_SIZE.height * 0.05),
              child: Column(
                children: [
                  TimelineTile(
                    indicatorStyle: IndicatorStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    alignment: TimelineAlign.manual,
                    lineXY: 0.2,
                    afterLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    beforeLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    endChild: Container(
                        constraints: BoxConstraints(
                          minHeight: DEVICE_SIZE.height * 0.15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stage 1",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trackPackages != null &&
                                    trackPackages['stage_1'] != null
                                ? Text(trackPackages['state_1'].toString())
                                : Text(""),
                          ],
                        )),
                  ),
                  TimelineTile(
                    indicatorStyle: IndicatorStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    alignment: TimelineAlign.manual,
                    lineXY: 0.2,
                    afterLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    beforeLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    endChild: Container(
                        constraints: BoxConstraints(
                          minHeight: DEVICE_SIZE.height * 0.15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stage 2",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trackPackages != null &&
                                    trackPackages['stage_2'] != null
                                ? Text(trackPackages['state_2'].toString())
                                : Text("")
                          ],
                        )),
                  ),
                  TimelineTile(
                    indicatorStyle: IndicatorStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    alignment: TimelineAlign.manual,
                    lineXY: 0.2,
                    afterLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    beforeLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    endChild: Container(
                        constraints: BoxConstraints(
                          minHeight: DEVICE_SIZE.height * 0.15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stage 3",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trackPackages != null &&
                                    trackPackages['stage_3'] != null
                                ? Text(trackPackages['state_3'].toString())
                                : Text(""),
                          ],
                        )),
                  ),
                  TimelineTile(
                    indicatorStyle: IndicatorStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    alignment: TimelineAlign.manual,
                    lineXY: 0.2,
                    afterLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    beforeLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    endChild: Container(
                        constraints: BoxConstraints(
                          minHeight: DEVICE_SIZE.height * 0.15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stage 4",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trackPackages != null &&
                                    trackPackages['stage_4'] != null
                                ? Text(trackPackages['state_4'].toString())
                                : Text(""),
                          ],
                        )),
                  ),
                  TimelineTile(
                    indicatorStyle: IndicatorStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    alignment: TimelineAlign.manual,
                    lineXY: 0.2,
                    afterLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    beforeLineStyle: LineStyle(
                        color: Theme.of(context).secondaryHeaderColor),
                    endChild: Container(
                        constraints: BoxConstraints(
                          minHeight: DEVICE_SIZE.height * 0.15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Status",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trackPackages != null &&
                                    trackPackages['is_delivered']
                                ? Text("Delivered")
                                : Text("On the Way"),
                          ],
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
