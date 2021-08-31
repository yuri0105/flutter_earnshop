import 'dart:convert';
import 'package:EarnShow/providers/shop.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:EarnShow/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Cart extends ChangeNotifier {
  List<Product> _products = [];
  String authToken;
  String _paymentId;
  String _orderId;
  int _totalAmount = 0;

  void updates(String authToken, List<Product> products) {
    this.authToken = authToken;
    this._products = products;
  }

  Future<void> fetchItemsInCart(int userId) async {
    try {
      final response = await http.get(
          DEFAULT_HOST_URL + '/ecommerce/cart/' + userId.toString() + '/',
          headers: {"Authorization": "Token " + authToken.toString()});
      List products = jsonDecode(response.body)['cart_products'];
      this._products = [];
      print(products);
      products.forEach((product) {
        this._products.add(Product(
              id: product['id'],
              image: product['image'],
              title: product['product_name'],
              brand: product['brand_name'],
              amount: product['price'],
              rating: product['overall_rating'],
              noOfRating: product['reviewers_count'],
            ));
        notifyListeners();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
  }

  Future<void> createOrder() async {
    print("Create Order Called");
    try {
      var ids = [];
      this._products.forEach((product) {
        ids.add(product.id);
      });
      final response = await http.post(
        DEFAULT_HOST_URL + '/ecommerce/order/',
        body: jsonEncode({"product": ids.join(",").toString()}),
        headers: {
          "Authorization": "Token " + authToken.toString(),
          "content-type": "application/json",
          "accept": "application/json"
        },
      );
      print(response.body);
      if (response.statusCode < 205) {
        var jsonResponse = jsonDecode(response.body);
        _orderId = jsonResponse['order_id'];
        var totalAmount = 0;
        jsonResponse['order_product'].forEach((product) {
          totalAmount += product['price'];
        });
        _totalAmount = totalAmount * 100;
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    notifyListeners();
  }

  Future<Map<String, Object>> trackPackage(productId) async {
    Map<String, Object> trackData;
    try {
      final response = await http.get(
          DEFAULT_HOST_URL +
              '/ecommerce/order_track/' +
              productId.toString() +
              '/',
          headers: {"Authorization": "Token " + authToken.toString()});
      trackData = jsonDecode(response.body);
      notifyListeners();
//      order_GCXMW7wx5w6U0v
//      order_GCXMW7wx5w6U0v
//      order_GCXMW7wx5w6U0v
      return trackData;
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    return trackData;
  }

  List<Product> get products {
    return [..._products];
  }

  int get itemCount {
    return _products.length;
  }

  String get orderId => _orderId;

  int get totalAmount => _totalAmount;

  Future<void> addToCart(int userId, id) async {
    print(this.isItemInCart(id));
    if (!this.isItemInCart(id)) {
      this._products.add(id);
      var ids = [];
      this._products.forEach((product) {
        ids.add(product.id);
      });
      try {
        final response = await http.patch(
          DEFAULT_HOST_URL + '/ecommerce/cart/' + userId.toString() + '/',
          body: jsonEncode({"product": ids.join(",").toString()}),
          headers: {
            "Authorization": "Token " + authToken.toString(),
            "content-type": "application/json",
            "accept": "application/json"
          },
        );
        if (response.statusCode < 205) {
        } else {
          handleErrorResponse(response.body);
        }
      } catch (e) {
        _products.removeWhere((productId) => productId.id == id);
        Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Product is already added to cart.", timeInSecForIosWeb: 5);
    }

    notifyListeners();
  }

  Future<void> deleteItemById(userId, id) async {
    _products.removeWhere((productId) => productId.id == id);
    var ids = [];
    this._products.forEach((product) {
      ids.add(product.id);
    });
    try {
      final response = await http.patch(
        DEFAULT_HOST_URL + '/ecommerce/cart/' + userId.toString() + '/',
        body: jsonEncode({"product": ids.join(",").toString()}),
        headers: {
          "Authorization": "Token " + authToken.toString(),
          "content-type": "application/json",
          "accept": "application/json"
        },
      );
      if (response.statusCode < 205) {
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
    notifyListeners();
  }

  bool isItemInCart(id) {
    var itemInList = _products.where((productId) => productId.id == id);
    print(itemInList);
    return itemInList.isNotEmpty;
  }

  Future<void> paymentDone(String paymentId) async {
    _paymentId = paymentId;
    try {
      final response = await http.post(
        DEFAULT_HOST_URL + '/ecommerce/capture_payment/',
        body: jsonEncode({"payment_id": _paymentId, "amount": _totalAmount}),
        headers: {
          "Authorization": "Token " + authToken.toString(),
          "content-type": "application/json",
          "accept": "application/json"
        },
      );
      if (response.statusCode < 205) {
        _totalAmount = 0;
        _orderId = null;
        _products = [];
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
  }
}
