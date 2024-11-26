import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/models/post.dart';
import 'package:oxdo_network/network_services/post_service.dart';

class AddPostNotifiers extends ChangeNotifier {
  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  bool _addedCompleted = false;
  bool get addedCompleted => _addedCompleted;

  String? _error;
  String? get error => _error;

  Future addAPost(Post post) async {
    try {
      _showProgressBar = true;
      notifyListeners();
      await PostService.addAPost(path: "/post", post: post);
      _addedCompleted = true;
      _showProgressBar = false;
      notifyListeners();
      log("Completed");
    } catch (e) {
      _addedCompleted = false;
      _showProgressBar = false;
      log(e.toString());
      _error = e.toString();
      notifyListeners();
    }

    //_reset();
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
      _addedCompleted = true;
      _showProgressBar = false;
      notifyListeners();
      log("update Completed");
    } catch (e) {
      _addedCompleted = false;
      _showProgressBar = false;
      log(e.toString());
      _error = e.toString();
      notifyListeners();
    }

    //_reset();
  }

 

  void reset() {
    _addedCompleted = false;
    _showProgressBar = false;
    _error = null;
    notifyListeners();
  }
}
