
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oxdo_network/providers/add_post_notifiers.dart';
import 'package:oxdo_network/providers/post_notifires.dart';
import 'package:oxdo_network/screens/home_screen.dart';
import 'package:provider/provider.dart';

late final Dio dio;
void main() {
  dio = Dio();

  // Add base url and other details to dio
  dio.options = BaseOptions(
    baseUrl: "https://node-backend-40ct.onrender.com",
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        log("Requst interceptor ${options.path}");
        handler.next(options);
      },
      onResponse: (response, handler) {
        log("Response interceptor ${response.statusMessage}");

        handler.next(response);
      },
      onError: (error, handler) {
        log("Error interceptor ${error.message}");
        handler.next(error);
      },
    ),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PostNotifiers()),
    ChangeNotifierProvider(create: (_) => AddPostNotifiers()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
