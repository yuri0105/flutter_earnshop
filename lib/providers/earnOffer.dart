import 'package:flutter/material.dart';

class EarnOffer with ChangeNotifier {
  int id;
  String title;
  String description;
  String image;
  int rewardAmount;
  String link;

  EarnOffer({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.rewardAmount,
    @required this.link,
  });
}
