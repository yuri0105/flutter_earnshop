import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentScreen = 0;

  int get currentScreen => this._currentScreen;

  void setCurrentScreen(int currentScreen) {
    this._currentScreen = currentScreen;
    notifyListeners();
  }
}
