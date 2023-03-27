import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:E_Library/utils/core/app_theme.dart';

class ThemeController extends GetxController {
  RxInt currentBottomNavItemIndex = 0.obs;
  Rx<ThemeData> theme = AppTheme.lightTheme.obs;
  bool isLightTheme = true;

  void switchBetweenBottomNavigationItems(int currentIndex) {
    currentBottomNavItemIndex.value = currentIndex;
  }

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
