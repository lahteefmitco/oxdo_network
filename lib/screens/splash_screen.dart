import 'package:flutter/material.dart';
import 'package:oxdo_network/providers/splash_notifiers.dart';
import 'package:oxdo_network/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final splashNotifiers = context.read<SplashNotifiers>();
    splashNotifiers.showSnackBar = (value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value)));
    };

    splashNotifiers.onNavigate = () {
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashNotifiers>(builder: (context, value, child) {
      final welocmeMessage = value.welcomeMessage;
      final showProgressBar = value.showProgressBar;
      return Scaffold(
        floatingActionButton: showProgressBar
            ? const CircularProgressIndicator()
            : const SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: Text(
            welocmeMessage,
            style: const TextStyle(color: Colors.green),
          ),
        ),
      );
    });
  }
}
