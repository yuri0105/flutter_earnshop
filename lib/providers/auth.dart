import 'dart:io';

import 'package:EarnShow/screens/Dashboard.dart';
import 'package:EarnShow/screens/Login.dart';
import 'package:EarnShow/utils/helpers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:EarnShow/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String _token;
  int _userId;
  DateTime _expireData;
  String _name;
  String _profilePhoto;
  String _username;
  String _email;
  Future<SharedPreferences> _authPreferences = SharedPreferences.getInstance();
  String _passwordResetEmail;
  String _passwordResetCode;

  String _address;
  String _state;
  String _city;
  String _zipCode;
  String _referralCode;
  String _totalReferrals;

  Future<void> signUp(BuildContext context, String name, String email,
      String password, String referralCode) async {
    try {
      final response = await http.post(DEFAULT_HOST_URL + '/accounts/user/',
          body: json.encode({
            'name': name,
            'email': email,
            'password': password,
            'referral_code': referralCode,
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json"
          });
      if (response.statusCode < 205) {
        routeTo(context, Login.routeName, {});
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error in connecting, please check your internet connection.",
        timeInSecForIosWeb: 5,
      );
    }
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    final SharedPreferences loginPref = await _authPreferences;
    try {
      final response = await http.post(DEFAULT_HOST_URL + '/accounts/login/',
          body: json.encode({
            'email': email,
            'password': password,
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json"
          });
      if (response.statusCode == 201) {
        this._token = json.decode(response.body)['token'];
        this._userId = json.decode(response.body)['id'];
        this._name = json.decode(response.body)['name'];
        this._email = json.decode(response.body)['email'];
        this._referralCode = json.decode(response.body)['referral_code'];
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'name': _name,
          'referral_code': _referralCode,
        });
        loginPref.setString('userData', userData);
        notifyListeners();
        routeToReplacement(context, Dashboard.routeName, {});
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
    }
  }

  Future<void> getProfile() async {
    try {
      final response = await http.get(
          DEFAULT_HOST_URL + '/accounts/user/' + this._userId.toString() + '/',
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Token " + this.token.toString()
          });
      if (response.statusCode < 205) {
        var profileData = jsonDecode(response.body);
        _profilePhoto = profileData['image'];
        _username = profileData['username'];
        _totalReferrals = profileData['total_referrals'] != null
            ? profileData['total_referrals'].toString()
            : "0";
      } else {
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
      return;
    }

    notifyListeners();
  }

  Future<bool> autoLogin() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _name = extractedUserData['name'];
      _referralCode = extractedUserData['referral_code'];
      print(_token);
    } catch (e) {
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> changePassword(oldPassword, newPassword) async {
    try {
      final response =
          await http.post(DEFAULT_HOST_URL + '/accounts/password-change/',
              body: json.encode({
                'old_password': oldPassword,
                'new_password': newPassword,
              }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Token " + this.token.toString()
          });
      notifyListeners();
      if (response.statusCode == 201)
        return true;
      else
        handleErrorResponse(response.body);
      return false;
    } catch (e) {}
  }

  Future<bool> passwordResetEmail(String email) async {
    try {
      final response =
          await http.post(DEFAULT_HOST_URL + '/accounts/password-reset-code/',
              body: json.encode({
                'email': email,
              }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
            // "Authorization": "Token " + this.token.toString()
          });
      if (response.statusCode == 201) {
        _passwordResetEmail = email;
        Fluttertoast.showToast(
            msg:
                "Password verification link sent to ${jsonDecode(response.body)['email']}!",
            timeInSecForIosWeb: 5);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: ERROR_MESSAGE_404, timeInSecForIosWeb: 5);
      return false;
    }
  }

  Future<bool> passwordResetVerify(String code) async {
    try {
      final response =
          await http.post(DEFAULT_HOST_URL + '/accounts/password-reset-verify/',
              body: json.encode({
                'email': _passwordResetEmail,
                'code': code,
              }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
            // "Authorization": "Token " + this.token.toString()
          });
      if (response.statusCode == 201) {
        _passwordResetCode = code;
        Fluttertoast.showToast(msg: "Email verified!", timeInSecForIosWeb: 5);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e, timeInSecForIosWeb: 5);
      return false;
    }
  }

  Future<bool> passwordResetChangePassword(String password) async {
    try {
      final response =
          await http.post(DEFAULT_HOST_URL + '/accounts/password-reset/',
              body: json.encode({
                'email': _passwordResetEmail,
                'password': password,
              }),
              headers: {
            "content-type": "application/json",
            "accept": "application/json",
            // "Authorization": "Token " + this.token.toString()
          });
      if (response.statusCode == 201) {
        notifyListeners();
        Fluttertoast.showToast(
            msg: "Password Changed Successfully!", timeInSecForIosWeb: 5);
        return true;
      } else {
        notifyListeners();
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e, timeInSecForIosWeb: 5);
      return false;
    }
  }

  bool get isAuth {
    if (this._token != null) {
      return true;
    }
    return false;
  }

  String get firstName {
    if (this._name != null) {
      return this._name.split(' ')[0];
    }
  }

  int get userId {
    return this._userId;
  }

  String get username => this._username;

  String get profilePhoto => this._profilePhoto;

  String get email => this._email;

  String get passwordResetEmailValue => this._passwordResetEmail;

  String get passwordResetCode => this._passwordResetCode;

  String get referralCode => this._referralCode;

  String get totalReferrals => this._totalReferrals;

  Future signOut() async {
    final SharedPreferences prefs = await _authPreferences;
    return Future.delayed(Duration.zero).then((_) => {
          prefs.remove('userData'),
          this._token = null,
          this._userId = null,
          this._name = null,
          notifyListeners(),
        });
  }

  Future<bool> updateAddress(address, state, city, zipcode) async {
    try {
      final response = await http.put(DEFAULT_HOST_URL + '/accounts/address/1/',
          body: json.encode({
            'address_line_1': address,
            'city': city,
            'state': state,
            'zipcode': zipcode,
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Token " + this.token.toString()
          });
      if (response.statusCode == 200) {
        notifyListeners();
        Fluttertoast.showToast(
            msg: "Address Updated Successfully!", timeInSecForIosWeb: 5);
        return true;
      } else {
        notifyListeners();
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e, timeInSecForIosWeb: 5);
      return false;
    }
  }

  Future<bool> fetchAddress() async {
    try {
      final response =
          await http.get(DEFAULT_HOST_URL + '/accounts/address/1/', headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Token " + this.token.toString()
      });
      _city = jsonDecode(response.body)['city'];
      _address = jsonDecode(response.body)['address_line_1'];
      _state = jsonDecode(response.body)['state'];
      _zipCode = jsonDecode(response.body)['zipcode'].toString();
      if (response.statusCode == 200) {
        notifyListeners();
        if (_city.isNotEmpty ||
            _address.isNotEmpty ||
            _zipCode != null ||
            _state.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        notifyListeners();
        handleErrorResponse(response.body);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e, timeInSecForIosWeb: 5);
      return false;
    }
  }

  String get address => _address;

  String get city => _city;

  String get zipCode => _zipCode;

  String get state => _state;

  String get token {
    return this._token;
  }
}
