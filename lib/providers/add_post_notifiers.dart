//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/models/post.dart';
import 'package:oxdo_network/network_services/post_service.dart';

class AddPostNotifiers extends ChangeNotifier {
  Function()? onNavigate;

  Function(String errorMessage)? showSnackBar;

  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  Future addAPost(Post post) async {
    try {
      _showProgressBar = true;
      notifyListeners();
      await PostService.addAPost(path: "/post", post: post);

      _showProgressBar = false;
      notifyListeners();

      onNavigate?.call();
    } catch (e) {
      _showProgressBar = false;
      notifyListeners();

      showSnackBar?.call(e.toString());
    }
  }

  Future editAPost(Post post) async {
    try {
      _showProgressBar = true;
      notifyListeners();
      await PostService.editAPost(
        path: "/post",
        id: post.id,
        post: post,
      );
      _showProgressBar = false;
      notifyListeners();

      onNavigate?.call();
    } catch (e) {
      _showProgressBar = false;
      notifyListeners();
      showSnackBar?.call(e.toString());
    }

  }
}
