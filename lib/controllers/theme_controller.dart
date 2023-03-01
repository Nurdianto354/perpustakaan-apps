import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';

class ThemeController extends GetxController {
  Rx<ThemeData> theme = AppTheme.lightTheme.obs;
  bool isLightTheme = true;

  void changeTheme() {
    if (theme.value == AppTheme.darkTheme) {
      theme.value = AppTheme.lightTheme;
      isLightTheme = true;
    } else {
      theme.value = AppTheme.darkTheme;
      isLightTheme = false;
    }
  }
}
