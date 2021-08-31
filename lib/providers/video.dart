import 'package:EarnShow/constants.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Video with ChangeNotifier {
  int id;
  String title;
  String url;
  String thumbnailURL;
  String creatorName;
  String creatorImageURL;
  int viewsCount;
  int creatorId;
  String duration;
  int likes = 0;
  int dislikes = 0;
  bool liked = false;
  bool disLiked = false;
  String reaction;
  bool is_following;
  String description;
  String authToken;

  void updates(authToken) {
    this.authToken = authToken;
  }

  Video(
      {this.id,
      this.title,
      this.url,
      this.thumbnailURL,
      this.creatorName,
      this.creatorImageURL,
      this.viewsCount,
      this.creatorId,
      this.duration,
      this.likes,
      this.liked,
      this.dislikes,
      this.disLiked,
      this.reaction,
      this.is_following,
      this.description});

  Future<void> toggleLike(String authToken) async {
    if (liked != true) {
      liked = true;
      if (disLiked == true) {
        disLiked = false;
        dislikes--;
        await http.delete(
            DEFAULT_HOST_URL + '/videos/' + id.toString() + '/reaction/1/',
            headers: {"Authorization": "Token " + authToken.toString()});
      }
      likes++;
      final response = await http.post(
          DEFAULT_HOST_URL + '/videos/' + id.toString() + '/reaction/',
          body: {'reaction_type': 'L'},
          headers: {"Authorization": "Token " + authToken.toString()});
      print(response.body);
      print(response.statusCode);
      if (response.statusCode < 205) {
      } else {
        likes--;
        // handleErrorResponse(response.body);
      }
    } else {
      liked = false;
      likes--;
      final response = await http.delete(
          DEFAULT_HOST_URL + '/videos/' + id.toString() + '/reaction/1/',
          headers: {"Authorization": "Token " + authToken.toString()});
      print("REMOVE");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode < 205) {
      } else {
        likes++;
        // handleErrorResponse(response.body);
      }
    }

    notifyListeners();
  }

  Future<void> toggleDisliked(String authToken) async {
    try {
      if (disLiked != true) {
        disLiked = true;
        if (liked) {
          liked = false;
          likes--;
          await http.delete(
              DEFAULT_HOST_URL + '/videos/' + id.toString() + '/reaction/1/',
              headers: {"Authorization": "Token " + authToken.toString()});
        }
        dislikes++;
        final response = await http.post(
            DEFAULT_HOST_URL + '/videos/' + id.toString() + '/reaction/',
            body: {'reaction_type': 'D'},
            headers: {"Authorization": "Token " + authToken.toString()});
        print(response.body);
        print(response.statusCode);
        if (response.statusCode < 205) {
        } else {
          likes++;
          // handleErrorResponse(response.body);
        }
      } else {
        disLiked = false;
        dislikes--;
        final response = await http.delete(
            DEFAULT_HOST_URL + '/videos/' + id.toString() + '/reaction/1/',
            headers: {"Authorization": "Token " + authToken.toString()});
        print("REMOVE");
        print(response.body);
        print(response.statusCode);
        if (response.statusCode < 205) {
        } else {
          dislikes++;
          // handleErrorResponse(response.body);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    notifyListeners();
  }

  Future<void> follow(int creatorId) async {
    try {
      if (is_following == null || !is_following) {
        is_following = true;
        final response = await http.post(DEFAULT_HOST_URL + '/accounts/follow/',
            body: {'user': creatorId.toString()},
            headers: {"Authorization": "Token " + authToken.toString()});
        if (response.statusCode == 201) {
          is_following = true;
        } else {
          is_following = false;
        }
      } else {
        is_following = false;
        final response = await http.delete(
            DEFAULT_HOST_URL + '/accounts/follow/' + creatorId.toString(),
            headers: {"Authorization": "Token " + authToken.toString()});
        if (response.statusCode == 201) {
          is_following = false;
        } else {
          is_following = true;
          handleErrorResponse(response.body);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    notifyListeners();
  }
}
