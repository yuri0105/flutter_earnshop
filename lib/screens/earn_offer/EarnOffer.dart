import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/earnOffers.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarnOfferScreen extends StatefulWidget {
  static final routeName = '/earn-offer';

  @override
  _EarnOfferScreenState createState() => _EarnOfferScreenState();
}

class _EarnOfferScreenState extends State<EarnOfferScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final offerProvider = Provider.of<EarnOffers>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async => {
          setState(() {
            _isLoading = true;
          }),
          Provider.of<NavigationProvider>(context, listen: false)
              .setCurrentScreen(3),
          if (offerProvider.offers.length == 0)
            {await offerProvider.fetchOffers()},
          setState(() {
            _isLoading = false;
          }),
        });
  }

  void open(link) {
    chromeTab(context, link);
  }

  Future<void> _refreshOffers() async {
    await Provider.of<EarnOffers>(context, listen: false).fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    final loadedOffers = Provider.of<EarnOffers>(context).offers;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "EarnMore",
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Download the apps and earn cash !",
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshOffers,
                    child: ListView.builder(
                      itemCount: loadedOffers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: DEVICE_SIZE.width * 0.8,
                          height: DEVICE_SIZE.height * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Card(
                              elevation: 5,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: DEVICE_SIZE.width * 0.25,
                                      padding:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: Image.network(
                                          loadedOffers[index].image),
                                    ),
                                    Container(
                                      width: DEVICE_SIZE.width * 0.6,
                                      padding: EdgeInsets.only(
                                          left: 20, top: 15, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              loadedOffers[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'Montserrat',
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Text(
                                              loadedOffers[index].description,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 35,
                                                child: OutlineButton(
                                                  onPressed: () => {},
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor,
                                                      style: BorderStyle.solid,
                                                      width: 1),
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .secondaryHeaderColor,
                                                  highlightElevation: 5,
                                                  highlightedBorderColor:
                                                      Colors.transparent,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.only(top: 3),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Reward",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Theme.of(
                                                                      context)
                                                                  .secondaryHeaderColor),
                                                        ),
                                                        Text(
                                                          "Rs." +
                                                              loadedOffers[
                                                                      index]
                                                                  .rewardAmount
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Theme.of(
                                                                      context)
                                                                  .secondaryHeaderColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                width: 90,
                                                height: 35,
                                                child: RaisedButton(
                                                  elevation: 5,
                                                  onPressed: () => open(
                                                      loadedOffers[index].link),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                  ),
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .secondaryHeaderColor,
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                  textColor: Theme.of(context)
                                                      .primaryColorLight,
                                                  child: Text(
                                                    "Open",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
      endDrawer: SizedBox.expand(
        child: new Drawer(child: NavigationScreen()),
      ),
      bottomNavigationBar: NavigationBarBottom(),
    );
  }
}
