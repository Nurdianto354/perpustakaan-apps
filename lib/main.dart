import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perpustakaan/controllers/theme_controller.dart';
import 'package:perpustakaan/views/splash_page.dart';

final ThemeController controller = Get.put(ThemeController());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Library',
      theme: controller.theme.value,
      home: const SplashPage(),
    );
  }
}
