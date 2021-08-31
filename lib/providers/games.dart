import 'dart:convert';
import 'package:EarnShow/constants.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Game extends ChangeNotifier {
  String title;
  String image;
  String url;

  Game({this.title, this.image, this.url});

  String get gameTitle => title;

  String get gameImage => title;

  String get gameURL => url;
}

class Games extends ChangeNotifier {
  List<Game> _games = [];
  String authToken;

  void updates(String authToken, List<Game> games) {
    this.authToken = authToken;
    this._games = games;
  }

  Future<void> fetchGames() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/game/',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        List games = jsonDecode(response.body)['results'];
        if (games != null) {
          this._games = [];
          games.forEach((game) {
            this._games.add(Game(
                url: game['url'], title: game['title'], image: game['image']));
          });
        }
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error in loading Games", timeInSecForIosWeb: 5);
    }
  }

  List<Game> get games => [..._games];
}
