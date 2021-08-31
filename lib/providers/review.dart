import 'package:EarnShow/constants.dart';
import 'package:EarnShow/providers/auth.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductReview with ChangeNotifier {
  int id;
  int star;
  String review;
  String creatorImage;
  String creatorName;

  ProductReview({
    this.id,
    this.star,
    this.review,
    this.creatorName,
    this.creatorImage,
  });
}

class Reviews with ChangeNotifier {
  String authToken;
  List<ProductReview> reviews = [
    // Reviews(
    //   id: 1,
    //   star: 2,
    //   review: "Testing...",
    //   creatorName: "User432432",
    //   creatorImage: "assets/icons/user.png",
    // )
  ];

  void updates(String authToken, List<ProductReview> commentsList) {
    this.authToken = authToken;
    this.reviews = commentsList;
  }

  List<ProductReview> get getReviews => [...this.reviews];

  Future<bool> fetchReviews(String authToken, int productId) async {
    try {
      final response = await http.get(
          DEFAULT_HOST_URL + '/ecommerce/' + productId.toString() + '/rate/',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        final reviews = jsonDecode(response.body)["results"];
        this.reviews = [];
        reviews.forEach((review) {
          this.reviews.add(
                ProductReview(
                    id: review['id'],
                    star: review['star'],
                    review: review['review']),
              );
          notifyListeners();
        });
        return true;
      } else {
        handleErrorResponse(response.body);
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
      return false;
    }
  }

  Future<bool> addReview(int star, String review, String productId) async {
    try {
      final response = await http.post(
          DEFAULT_HOST_URL + '/ecommerce/' + productId.toString() + '/rate/',
          body: jsonEncode({'star': star, 'review': review}),
          headers: {
            "Authorization": "Token " + authToken.toString(),
            "content-type": "application/json",
            "accept": "application/json"
          });
      if (response.statusCode < 205) {
        Fluttertoast.showToast(
            msg: "Thanks for review!", timeInSecForIosWeb: 5);
        notifyListeners();
        return true;
      } else {
        handleErrorResponse(response.body);
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
      return false;
    }
  }
}
