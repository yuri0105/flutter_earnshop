import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/earnOffers.dart';
import 'package:EarnShow/providers/games.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamesListScreen extends StatefulWidget {
  static final routeName = '/games';

  @override
  _GamesListScreenState createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      Provider.of<NavigationProvider>(context, listen: false)
          .setCurrentScreen(2);
      setState(() {
        _isLoading = true;
      });
      final gameProvider = Provider.of<Games>(context, listen: false);
      await gameProvider.fetchGames();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshGames() async {
    await Provider.of<Games>(context, listen: false).fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    final loadedOffers = Provider.of<Games>(context).games;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new MyAppBar(
        title: "Welcome Nitish",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Games",
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
                    "Download the gamess and earn cash!",
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshGames,
                    child: ListView.builder(
                      itemCount: loadedOffers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: DEVICE_SIZE.width * 0.8,
                          height: DEVICE_SIZE.height * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            child: Card(
                              elevation: 5,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: DEVICE_SIZE.width * 0.25,
                                      padding:
                                          EdgeInsets.only(left: 20,),
                                      child: Image.network(
                                          loadedOffers[index].image),
                                    ),
                                    Container(
                                      width: DEVICE_SIZE.width * 0.6,
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  loadedOffers[index].title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      fontFamily: 'Montserrat',
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                width: 90,
                                                height: 35,
                                                child: RaisedButton(
                                                  elevation: 5,
                                                  onPressed: () => chromeTab(
                                                      context,
                                                      loadedOffers[index].url),
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
                                                    "Play now",
                                                    style: TextStyle(fontSize: 10),
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
