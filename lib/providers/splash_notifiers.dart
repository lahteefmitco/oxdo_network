import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/network_services/post_service.dart';

class SplashNotifiers extends ChangeNotifier {
  Function(String error)? showSnackBar;
  Function()? onNavigate;

  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  String _welcomeMessage = "";
  String get welcomeMessage => _welcomeMessage;

  void getWelcomeMessage() async {
    try {
      _showProgressBar = true;
      notifyListeners();

      _welcomeMessage = await PostService.getWelcomeMessage();
      _showProgressBar = false;
      notifyListeners();
      // navigation delay
      await Future.delayed(const Duration(seconds: 5));

      // navigate
      onNavigate?.call();
    } catch (e) {
      _showProgressBar = false;
      log(e.toString(), name: "welcome error");
      notifyListeners();
      showSnackBar?.call(e.toString());
    }
  }
}
