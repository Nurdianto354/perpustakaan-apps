import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/src/model/user_model.dart';
import 'package:perpustakaan/src/view/screen/auth/login_screen.dart';
import 'package:perpustakaan/src/view/screen/home/home_screen.dart';
import 'package:perpustakaan/src/view/widget/custom_dialog.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  BuildContext? context;
  UserModel? _userModel;

  LoginController() {
    _getPersistence();
  }

  _getPersistence() async {
    _userModel = await GlobalFunctions.getPersistence();
  }

  Future<void> savePersistence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(GlobalVars.idKey, _userModel!.id!);
    prefs.setString(GlobalVars.nameKey, _userModel!.name);
    prefs.setString(GlobalVars.emailKey, _userModel!.email!);
    prefs.setString(GlobalVars.roleKey, _userModel!.role);
    prefs.setString(GlobalVars.accessTokenKey, _userModel!.accessToken);
  }

  clearPersistence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(GlobalVars.idKey);
    prefs.remove(GlobalVars.nameKey);
    prefs.remove(GlobalVars.emailKey);
    prefs.remove(GlobalVars.roleKey);
    prefs.remove(GlobalVars.accessTokenKey);
  }

  void login(context, loadingStateCallback, email, password, reset) async {
    if (_userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    FormData formData;

    Map params = GlobalFunctions.generateMapParam(
      ['email', 'password'], [email, password]
    );

    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(context: context, params: formData, path: GlobalVars.apiUrl + "login");
    log(data.toString());
    if (data != null) {
      if (data['status'] == 200) {
        _userModel = new UserModel(
            data['id'].toString(),
            data['name'],
            data['email'],
            data['roles'].toString(),
            data['access_token']
          );

        await savePersistence();

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        }));
      }
    } else {
      CustomDialog.getDialog(
        title: Strings.DIALOG_TITLE_WARNING,
        message: Strings.DIALOG_MESSAGE_API_CALL_FAILED,
        context: context,
        popCount: 1
      );
    }

    loadingStateCallback();
  }

  logout(context, loadingStateCallback) async {
    if (_userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    final data = await GlobalFunctions.dioPostCall(
      context: context,
      options: Options(headers: {
        "Authorization": "Bearer " + _userModel!.accessToken
      }),
      path: GlobalVars.apiUrl + "logout");

    if (data['status'] == 200) {
      await clearPersistence();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) {
          return const LoginScreen();
        }), (route) => false);
    } else {
      CustomDialog.getDialog(
        title: Strings.DIALOG_TITLE_WARNING,
        message: data['message'] ?? "-",
        context: context,
        popCount: 1
      );
    }

    loadingStateCallback();
  }
}
