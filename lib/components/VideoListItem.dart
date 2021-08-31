import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:EarnShow/providers/banners.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;

  VideoListItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;
  bool isAddPopUp = true;
  var subscription;
  Duration _lastDuration = Duration(seconds: 0, minutes: 0, hours: 0);

  @override
  void initState() {
    super.initState();
    if (Provider.of<Banners>(context, listen: false).banners.length == 0) {
      setState(() {
        isAddPopUp = false;
      });
    }
    _videoPlayerController = widget.videoPlayerController;
    _videoPlayerController.addListener(checkVideo);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void toggleAds(bool status) {
    setState(() {
      this.isAddPopUp = status;
    });
  }

  void showAdsPopup(x) {
    setState(() {
      this.isAddPopUp = true;
    });
  }

  void timeout() {
    var future = new Future.delayed(const Duration(milliseconds: 600));
    subscription = future.asStream().listen(showAdsPopup);
  }

  void checkVideo() {
    if (_videoPlayerController.value.position >
        _lastDuration + Duration(seconds: 0, minutes: 1, hours: 0)) {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
        setState(() {
          _lastDuration += Duration(seconds: 0, minutes: 1, hours: 0);
          this.isAddPopUp = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    final randomBanner =
        Provider.of<Banners>(context, listen: false).getRandomBanner;
    if (isAddPopUp) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (randomBanner != null)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: () => chromeTab(context, randomBanner.url),
                    child: Container(
                      height: DEVICE_SIZE.height * 0.28,
                      width: DEVICE_SIZE.width * 0.9,
                      color: Colors.black,
                      child: Image.network(randomBanner.image),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: DEVICE_SIZE.width * 0.02),
                    child: RaisedButton(
                      onPressed: () => toggleAds(false),
                      child: Text("Skip"),
                    ),
                  )
                ],
              )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Chewie(
              controller: _chewieController,
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
