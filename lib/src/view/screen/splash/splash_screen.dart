import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:perpustakaan/src/controller/login_controller.dart';
import 'package:perpustakaan/src/view/screen/auth/login_screen.dart';
import 'package:perpustakaan/src/view/screen/home/home_screen.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LoginController? _loginController;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.get(GlobalVars.accessTokenKey) as String?;

    _startTimer();
  }

  _startTimer() async {
    var duration = const Duration(seconds: 2);

    return Timer(duration, () async {
      if(accessToken != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        }));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const LoginScreen();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: Image.asset("assets/logo/logo.png"),
    );
  }
}
