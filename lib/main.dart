import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perpustakaan/src/controller/theme_controller.dart';
import 'package:perpustakaan/src/view/screen/splash/splash_screen.dart';

final AppThemeController controller = Get.put(AppThemeController());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      theme: controller.theme.value,
      home: const SplashScreen(),
    );
  }
}