//import 'dart:developer';

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:oxdo_network/main.dart';
import 'package:oxdo_network/models/post.dart';

class PostService {
  // Get request
  static Future<List<Post>> getPosts(String path) async {
    try {
      // get request by dio
      final Response<dynamic> response = await dio.get(
        path,
        options: Options(
          headers: {"key": "oxdo"},
        ),
      );
      // Check for status code
      if (response.statusCode == 200) {
        final List listOfData = response.data as List;

        // Get the list of post
        final List<Post> list =
            listOfData.map((element) => Post.fromMap(element)).toList();

        // reversing list and return
        return list.reversed.toList();
      } else {
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception

      throw Exception(e.toString());
    }
  }

  // Post request
  static Future<void> addAPost({
    required String path,
    required Post post,
  }) async {
    try {
      // post request by dio
      final Response<dynamic> response = await dio.post(
        // url path
        path,

        // data to post
        data: post.toJson(),
        // options
        options: Options(
          headers: {Headers.contentTypeHeader: 'application/json',"key": "oxdo"},
        ),
      );

      // Check for status code
      if (response.statusCode! < 300 && response.statusCode! >= 200) {
        final post = Post.fromMap(response.data);
      } else {
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception

      throw Exception(e.toString());
    }
  }

  // Put request
  static Future<void> editAPost({
    required String path,
    required int id,
    required Post post,
  }) async {
    try {
      // put request by dio
      final Response response = await dio.put(
        // url path with pathrameters as id
        "$path/$id",

        // data
        data: post.toJson(),

        // options
        options: Options(
          headers: {Headers.contentTypeHeader: 'application/json',"key": "oxdo"},
        ),
      );

      // Check for status code
      if (response.statusCode! < 300 && response.statusCode! >= 200) {
        final List listOfData = response.data as List;

        // Get the list of post
        final List<Post> list =
            listOfData.map((element) => Post.fromMap(element)).toList();
      } else {
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception

      throw Exception(e.toString());
    }
  }

  // delete request
  static Future<void> deleteAPost({
    required String path,
    required int id,
  }) async {
    try {
      // delete request by dio
      final Response response = await dio.delete(
        // url path with pathrameters as id
        "$path/$id",

        // options
        options: Options(
          headers: {Headers.contentTypeHeader: 'application/json',"key": "oxdo"},
        ),
      );

      // Check for status code
      if (response.statusCode! < 300 && response.statusCode! >= 200) {
        final List listOfData = response.data as List;

        // Get the list of post
        final List<Post> list =
            listOfData.map((element) => Post.fromMap(element)).toList();
      } else {
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception

      throw Exception(e.toString());
    }
  }

  // query parameters
  // search posts
  static Future<List<Post>> searchPosts(String path, String searchText) async {
    try {
      log("inside of search function", name: "search");
      // get request by dio
      final Response<dynamic> response = await dio.get(
        path,

        // Adding query parameters with the request
        queryParameters: {"searchText": searchText},
        options: Options(
          headers: {"key": "oxdo"},
        ),
      );

      log("Response code:- ${response.statusCode}", name: "status_code");
      // Check for status code
      if (response.statusCode == 200) {
        final List listOfData = response.data as List;

        // Get the list of post
        final List<Post> list =
            listOfData.map((element) => Post.fromMap(element)).toList();

        for (var element in list) {
          log(element.title);
        }

        // reversing list and return
        return list.reversed.toList();
      } else {
        log("other exception");
        throw Exception("Unknown response");
      }
    } on DioException catch (e) {
      // Catch dio exception
      log(e.toString(), name: "dio error");
      throw Exception(e.toString());
    } catch (e) {
      // Catching other exception
      log(e.toString(), name: "other error");

      throw Exception(e.toString());
    }
  }
}
