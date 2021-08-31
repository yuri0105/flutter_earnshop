import 'package:EarnShow/constants.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Videos extends ChangeNotifier {
  List<Video> _videosList = [];
  String authToken;

  void updates(String authToken, List<Video> videoList) {
    this.authToken = authToken;
    this._videosList = videoList;
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/videos/video/',
          headers: {
            "Authorization": "Token " + authToken.toString(),
            "X-Forwarded-Proto": "https"
          });
      if (response.statusCode < 205) {
        List videos = json.decode(response.body)['results'];
        this._videosList = [];
        videos.forEach((video) async {
          var isLiked = false;
          var isDisliked = false;
          if (video['reaction'] == 'L') {
            isLiked = true;
          }
          if (video['reaction'] == 'D') {
            isDisliked = true;
          }
          this._videosList.add(
                Video(
                  id: video['id'],
                  creatorName: video['user']['name'],
                  title: video['title'],
                  url: video['video'],
                  thumbnailURL: video['video_thumbnail'],
                  creatorImageURL: video['user']['image'],
                  creatorId: video['user']['id'],
                  duration: '01:09',
                  likes: video['like_reaction_count'],
                  dislikes: video['dislike_reaction_count'] ,
                  liked: (isLiked != null ? isLiked : false),
                  disLiked: (isDisliked != null ? isDisliked : false),
                  viewsCount: video['views'],
                  reaction: video['reaction'].toString(),
                  is_following: video['is_following'],
                  description: video['description'],
                ),
              );
          notifyListeners();
        });
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: ERROR_MESSAGE_404,
        timeInSecForIosWeb: 5,
      );
    }
  }

  Future<String> fetchVideo(int id) async {
    try {
      final response = await http.get(
          DEFAULT_HOST_URL + '/videos/video/' + id.toString(),
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        return json.decode(response.body)['video'];
      } else {
        handleErrorResponse(response.body);
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: ERROR_MESSAGE_404,
        timeInSecForIosWeb: 5,
      );
    }
  }

  List<Video> get videos {
    return [..._videosList];
  }

  void addVideo(video) {
    _videosList.add(video);
    notifyListeners();
  }

  Video findVideoById(id) {
    return _videosList.firstWhere((video) => video.id == id);
  }
}
