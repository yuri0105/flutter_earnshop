import 'package:EarnShow/constants.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoComment with ChangeNotifier {
  int id;
  String body;
  String user;
  String image;

  VideoComment({this.id, this.body, this.user, this.image});
}

class Comments with ChangeNotifier {
  List<VideoComment> _commentsList = [];
  int count;
  String authToken;

  void updates(String authToken, List<VideoComment> commentsList) {
    this.authToken = authToken;
    this._commentsList = commentsList;
  }

  int get totalCommentsCount => this.count;

  Future<void> fetchVideoComments(int videoID) async {
    try {
      final response = await http.get(
          DEFAULT_HOST_URL + '/videos/' + videoID.toString() + '/comment/',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        List comments = await jsonDecode(response.body)['results'];
        count = await jsonDecode(response.body)['count'];
        if (comments != null) {
          this._commentsList = [];
          comments.forEach((comment) {
            _commentsList.add(VideoComment(
              id: comment['id'],
              body: comment['body'],
              user: comment['user']['name'],
              image: comment['user']['image'],
            ));
            notifyListeners();
          });
        } else {
          handleErrorResponse(response.body);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    // {count: 1, next: null, previous: null, results: [{id: 1, body: My first comment}]}
  }

  List<VideoComment> get comments {
    return [..._commentsList];
  }

  void addComment(comment, videoID) async {
    try {
      final response = await http.post(
          DEFAULT_HOST_URL + '/videos/' + videoID.toString() + '/comment/',
          body: {"body": comment},
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode >= 205) {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    notifyListeners();
  }
}
