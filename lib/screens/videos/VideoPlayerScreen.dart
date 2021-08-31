import 'package:EarnShow/components/Comment.dart';
import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/components/VideoListItem.dart';
import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/banners.dart';
import 'package:EarnShow/providers/comments.dart';
import 'package:EarnShow/providers/video.dart';
import 'package:EarnShow/providers/videos.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/videos/LikeDislikeShareFollowPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  static final routeName = '/videoPlayerScreen';

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();
  String _commentFormValue;

  void _showRefMessage() {
    Fluttertoast.showToast(
        msg: "App need to be on Google Play to share the link!");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final randomBanner =
        Provider.of<Banners>(context, listen: false).getRandomBanner;
    print(randomBanner.url);
    print(randomBanner.image);
    final id = routeArgs['id'];
    Video video = Provider.of<Videos>(context, listen: false).findVideoById(id);
    Provider.of<Comments>(context, listen: false).fetchVideoComments(id);
    final videoURL = routeArgs['url'];

    void _submitCommnet() {
      _key.currentState.save();
      Provider.of<Comments>(context, listen: false)
          .addComment(_commentFormValue, video.id);
      _key.currentState.reset();
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: new SizedBox.expand(
        child: new Drawer(child: new NavigationScreen()),
      ),
      bottomNavigationBar: new NavigationBarBottom(),
      appBar: MyAppBar(
        title: "Welcome",
        openEndDrawer: () => _scaffoldKey.currentState.openEndDrawer(),
        cxt: context,
        currentScreen: "Video",
      ),
      body: ChangeNotifierProvider<Video>.value(
        value: video,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoListItem(
                videoPlayerController: VideoPlayerController.network(videoURL),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  children: [
                    if (video.creatorImageURL != null &&
                        video.creatorImageURL.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          video.creatorImageURL,
                          width: 40,
                          height: 40,
                        ),
                      )
                    else
                      Image.asset(
                        'assets/icons/user.png',
                        width: 40,
                        height: 40,
                      ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (video.title != null)
                              Text(
                                video.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (video.creatorName != null)
                                  Text(
                                    video.creatorName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                Text(
                                  video.viewsCount != null
                                      ? video.viewsCount.toString() + " views"
                                      : "0 views",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              LikeDislikeShareFollowPanel(),
              Divider(),
              if (video.description != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, top: 5, bottom: 5),
                      child: new Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              video.description,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              Divider(),
              if (randomBanner != null)
                InkWell(
                  onTap: () => chromeTab(context, randomBanner.url),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Image.network(randomBanner.image),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Row(children: [
                      Text(
                        "Comments",
                        style: TextStyle(fontSize: 22),
                      ),
                    ]),
                    // Comments
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 30),
                      child: Column(
                        children: [
                          Form(
                            key: _key,
                            child: TextFormField(
                              onSaved: (value) =>
                                  this._commentFormValue = value,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.grey),
                                labelText: "Comment",
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RaisedButton(
                                  onPressed: () => _submitCommnet(),
                                  child: Text(
                                    "Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Theme.of(context).secondaryHeaderColor,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300.0,
                            child: Consumer<Comments>(
                                builder: (context, comments, _) =>
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: comments.comments.length,
                                      itemBuilder: (context, index) => Comment(
                                          description:
                                              comments.comments[index].body,
                                          image: comments.comments[index].image,
                                          user: comments.comments[index].user),
                                    )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
