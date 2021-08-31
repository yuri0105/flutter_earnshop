import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/video.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LikeDislikeShareFollowPanel extends StatelessWidget {
  void _showRefMessage() {
    Fluttertoast.showToast(
        msg: "App need to be on Google Play to share the link!");
  }

  @override
  Widget build(BuildContext context) {
    String authToken = Provider.of<Auth>(context, listen: false).token;
    return Consumer<Video>(
        builder: (context, video, _) => new Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //LIKE BUTTON
                  GestureDetector(
                    onTap: () => Provider.of<Video>(context, listen: false)
                        .toggleLike(authToken),
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: video.liked != null && video.liked
                                ? Theme.of(context).secondaryHeaderColor
                                : null,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            child: video.likes != null
                                ? Text(
                                    video.likes.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                : Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //DISLIKE BUTTON
                  GestureDetector(
                    onTap: () => Provider.of<Video>(context, listen: false)
                        .toggleDisliked(authToken),
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_down,
                            color: video.disLiked != null && video.disLiked
                                ? Theme.of(context).secondaryHeaderColor
                                : null,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            child: video.dislikes != null
                                ? Text(
                                    video.dislikes.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                : Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showRefMessage,
                    child: Container(
                      child: Row(
                        children: [Icon(Icons.share)],
                      ),
                    ),
                  ),
                  if (Provider.of<Video>(context).is_following == null ||
                      !Provider.of<Video>(context).is_following)
                    RaisedButton(
                      color: Theme.of(context).secondaryHeaderColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () =>
                          Provider.of<Video>(context, listen: false)
                              .follow(video.creatorId),
                      child: Text(
                        "Follow",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ],
              ),
            ));
  }
}
