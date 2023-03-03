import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/auth_controller.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/views/auth/login_page.dart';
import 'package:perpustakaan/views/layouts/apps_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthController? _authController;
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
          return AppsPage();
        }));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const LoginPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent,
      child: Image.asset("assets/images/logo/logo.png"),
    );
  }
}