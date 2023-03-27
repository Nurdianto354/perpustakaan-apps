import 'package:flutter/material.dart';
import 'package:E_Library/utils/core/app_theme.dart';

class Loading {
  static circularLoading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: AppTheme.colorAccent,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
      ),
    );
  }
}