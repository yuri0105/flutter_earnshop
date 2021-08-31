import 'package:EarnShow/components/NavigationBarBottom.dart';
import 'package:EarnShow/components/VideoListItem.dart';
import 'package:EarnShow/components/VideoThumbnailWithTitle.dart';
import 'package:EarnShow/layouts/MyAppBar.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/navigationProvider.dart';
import 'package:EarnShow/screens/NavigationScreen.dart';
import 'package:EarnShow/screens/videos/UploadVideoScreen.dart';
import 'package:EarnShow/screens/videos/VideoPlayerScreen.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../providers/videos.dart';
import '../../providers/video.dart';

class VideoListScreen extends StatefulWidget {
  static final routeName = '/videoList';

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  var _init = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isLoading = false;

  Future<void> getVideo(int id) async {
    setState(() {
      _isLoading = true;
    });
    final url =
        await Provider.of<Videos>(context, listen: false).fetchVideo(id);
    if (url != null) {
      routeTo(context, VideoPlayerScreen.routeName, {'id': id, 'url': url});
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshVideos() async {
    await Provider.of<Videos>(context, listen: false).fetchVideos();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<NavigationProvider>(context, listen: false).setCurrentScreen(2);
      setState(() {
        _isLoading = true;
      });
      final videoProvider = Provider.of<Videos>(context, listen: false);
      if (videoProvider.videos.length == 0) {
        await videoProvider.fetchVideos();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_init) {}
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedVideos = Provider.of<Videos>(context).videos;

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
        currentScreen: "Videos",
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshVideos,
              child: ListView.builder(
                  itemCount: loadedVideos.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: loadedVideos[index],
                      child: Column(
                        children: [
                          VideoWithTitle(
                            videoTitle: loadedVideos[index].title,
                            creator: loadedVideos[index].creatorName,
                            creatorId: loadedVideos[index].creatorId,
                            views: loadedVideos[index].viewsCount,
                            videoThumbnailURL: loadedVideos[index].thumbnailURL,
                            creatorImageURL:
                                loadedVideos[index].creatorImageURL,
                            onClick: () => getVideo(loadedVideos[index].id),
                            duration: loadedVideos[index].duration,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
    );
  }
}
