import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/models/post.dart';
import 'package:oxdo_network/network_services/post_service.dart';

class PostNotifiers extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;
  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  String? _error;
  String? get error => _error;

  Future getPosts() async {
    try {
      _showProgressBar = true;
      _posts = await PostService.getPosts("/posts");
      _showProgressBar = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _showProgressBar = false;
      notifyListeners();
    }
  }

  Future deleteAPost(int id) async {
    try {
      _showProgressBar = true;
      notifyListeners();
      await PostService.deleteAPost(path: "/post", id: id);
      log("deleted", name: "delete");
      await getPosts();
    } catch (e) {
      _showProgressBar = false;
      log(e.toString());
      _error = e.toString();
      notifyListeners();
    }

    //_reset();
  }
}
