import 'dart:convert';
import 'package:EarnShow/constants.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  int id;
  String image;
  String title;
  String brand;
  int amount;
  int rating;
  int noOfRating;
  List<String> images;
  String authToken;
  int orderId;

  void updates(authToken) {
    this.authToken = authToken;
  }

  Product(
      {this.id,
      this.image,
      this.images,
      this.title,
      this.brand,
      this.amount,
      this.rating,
      this.noOfRating,
      this.orderId});
}

class Shop extends ChangeNotifier {
  List<Product> _products = [];
  String authToken;
  List<Product> _orders = [];

  void updates(String authToken, List<Product> products) {
    this.authToken = authToken;
    this._products = products;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/ecommerce/products/',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        List products = jsonDecode(response.body)['results'];
        this._products = [];
        products.forEach((product) {
          List<String> images = [];
          product['productimages'].forEach((image) {
            images.add(image['image'].toString());
          });
          images.add(product['image']);
          this._products.add(Product(
                id: product['id'],
                image: product['image'],
                title: product['product_name'],
                brand: product['brand_name'],
                images: images,
                amount: product['price'],
                rating: product['overall_rating'],
                noOfRating: product['reviewers_count'],
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

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(DEFAULT_HOST_URL + '/ecommerce/order/',
          headers: {"Authorization": "Token " + authToken.toString()});
      if (response.statusCode < 205) {
        List orders = jsonDecode(response.body)['results'];
        this._orders = [];
        orders.forEach((order) {
          if (order['payment_id'] != null) {
            order['order_product'].forEach((product) {
              this._orders.add(Product(
                  id: product['id'],
                  image: product['image'],
                  title: product['product_name'],
                  brand: product['brand_name'],
                  amount: product['price'],
                  rating: product['overall_rating'],
                  noOfRating: product['reviewers_count'],
                  orderId: order['id']));
            });
            notifyListeners();
          }
        });
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get orders {
    return [..._orders];
  }

  Product findProductById(id) {
    return _products.firstWhere((offer) => offer.id == id);
  }
}
