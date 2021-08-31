import 'package:EarnShow/constants.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/providers/earnOffer.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EarnOffers with ChangeNotifier {
  List<EarnOffer> _offerList = [];
  String authToken;

  void updates(String authToken, List<EarnOffer> offerList) {
    this.authToken = authToken;
    this._offerList = offerList;
  }

  Future<void> fetchOffers() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/earnoffer/',
          headers: {"Authorization": "Token " + authToken.toString()});

      if (response.statusCode < 205) {
        List offers = json.decode(response.body)['results'];
        this._offerList = [];
        offers.forEach((offer) {
          this._offerList.add(EarnOffer(
                id: offer['id'],
                title: offer['title'],
                description: offer['description'],
                image: offer['image'],
                rewardAmount: offer['reward_amount'],
                link: offer['installation_link'],
              ));
          notifyListeners();
        });
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
  }

  List<EarnOffer> get offers {
    return [..._offerList];
  }

  EarnOffer findOffersById(id) {
    return _offerList.firstWhere((offer) => offer.id == id);
  }
}
