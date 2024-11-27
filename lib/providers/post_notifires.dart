//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:oxdo_network/models/post.dart';
import 'package:oxdo_network/network_services/post_service.dart';

class PostNotifiers extends ChangeNotifier {
  Function(String)? showSnackBar;
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  bool _showProgressBar = false;
  bool get showProgressBar => _showProgressBar;

  Future getPosts() async {
    try {
      _showProgressBar = true;
      notifyListeners();
      _posts = await PostService.getPosts("/posts");
      _showProgressBar = false;
      notifyListeners();
    } catch (e) {
      _showProgressBar = false;
      notifyListeners();
      showSnackBar?.call(e.toString());
    }
  }

  Future deleteAPost(int id) async {
    try {
      _showProgressBar = true;
      notifyListeners();
      await PostService.deleteAPost(path: "/post", id: id);
      await getPosts();
    } catch (e) {
      _showProgressBar = false;
      notifyListeners();

      showSnackBar?.call(e.toString());
    }
  }

  Future searchtPosts({required String searchText}) async {
    try {
      _showProgressBar = true;
      _posts = await PostService.searchPosts("/search", searchText);
      _showProgressBar = false;
      notifyListeners();
    } catch (e) {
      _showProgressBar = false;
      notifyListeners();
      showSnackBar?.call(e.toString());
    }
  }
}
