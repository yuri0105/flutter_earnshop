import 'dart:convert';
import 'dart:math' as math;
import 'package:EarnShow/constants.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as requests;

class Pay2All extends ChangeNotifier {
  String API_TOKEN =
      'CmsXhWIRdU908OfBtqytCLGjT9bUFwmN2uvoLCmAq3WLJYHUAmJmklD3nFXK';
  List<dynamic> _mobileProviders = [];
  List<dynamic> _DTHProviders = [];
  String authToken;

  void updates(String authToken) {
    this.authToken = authToken;
  }

  Future<int> checkBalance() async {
    final response = await requests.get(
        'https://www.pay2all.in/web-api/get-balance?api_token=' +
            this.API_TOKEN);
    return jsonDecode(response.body)['balance'];
  }

  Future<void> fetchProviders() async {
    try {
      final response = await requests.get(
          'https://www.pay2all.in/web-api/get-provider?api_token=' +
              this.API_TOKEN);
      var providers = jsonDecode(response.body)['providers'];
      providers.forEach((provider) {
        if (provider['service'] == 'Mobile') {
          this._mobileProviders.add({
            "provider_id": provider['provider_id'],
            "provider_name": provider['provider_name'],
            "provider_image": provider['provider_image'],
          });
        }
        if (provider['service'] == 'DTH') {
          this._DTHProviders.add({
            "provider_id": provider['provider_id'],
            "provider_name": provider['provider_name'],
            "provider_image": provider['provider_image'],
          });
        }
        notifyListeners();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            "Recharge Services are currently down please try again in sometime.",
        timeInSecForIosWeb: 5,
      );
    }
  }

  Future<void> fetchCircles() async {
    final response = await requests.get(
        'https://www.pay2all.in/web-api/get-provider?api_token=' +
            this.API_TOKEN);
    return jsonDecode(response.body)['provides'];
  }

  List<dynamic> get mobileProviders => _mobileProviders;

  List<dynamic> get DTHProviders => _DTHProviders;

  Future<void> recharge(number, providerId, amount) async {
    try {
      final response = await requests.post(
        DEFAULT_HOST_URL + '/make_recharge/',
        body: jsonEncode({
          "recharge_type": "Mobile",
          "provider_id": providerId.toString(),
          "amount": amount.toString(),
          "mobile_number": number.toString()
        }),
        headers: {
          "Authorization": "Token " + authToken.toString(),
          "content-type": "application/json",
          "accept": "application/json"
        },
      );
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "Recharge Successful!",
            backgroundColor: Colors.greenAccent,
            timeInSecForIosWeb: 10);
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: ERROR_MESSAGE_404,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.redAccent);
    }
  }
}
