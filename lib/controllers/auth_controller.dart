import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/global_vars.dart';
import 'package:E_Library/utils/strings.dart';
import 'package:E_Library/views/auth/login_page.dart';
import 'package:E_Library/views/layouts/apps_page.dart';
import 'package:E_Library/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  BuildContext? context;
  UserModel? userModel;

  AuthController() {
    _getPersistence();
  }

  _getPersistence() async {
    userModel = await GlobalFunctions.getPersistence();
  }

  Future<void> savePersistence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(GlobalVars.idKey, userModel!.id!);
    prefs.setString(GlobalVars.nameKey, userModel!.name);
    prefs.setString(GlobalVars.emailKey, userModel!.email!);
    prefs.setString(GlobalVars.roleKey, userModel!.role);
    prefs.setString(GlobalVars.accessTokenKey, userModel!.accessToken);
  }

  clearPersistence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(GlobalVars.idKey);
    prefs.remove(GlobalVars.nameKey);
    prefs.remove(GlobalVars.emailKey);
    prefs.remove(GlobalVars.roleKey);
    prefs.remove(GlobalVars.accessTokenKey);
  }

  void register(context, loadingStateCallback, nama, email, password, passwordConfirm, reset) async {
    loadingStateCallback();
    FormData formData;

    Map params = GlobalFunctions.generateMapParam(
      ['name', 'email', 'password', 'password_confirmation'], [nama, email, password, passwordConfirm]
    );

    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
      context: context,
      params: formData,
      path: GlobalVars.apiUrl + "register"
    );

    if (data != null) {
      if (data['status'] == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return const LoginPage();
        }));

        CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_SUCCESS,
          message: data['message'],
          context: context,
          popCount: 1
        );
      } else {
        CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: data['message'],
          context: context,
          popCount: 1
        );
      }
    } else {
      CustomDialog.getDialog(
        title: Strings.DIALOG_TITLE_WARNING,
        message: Strings.DIALOG_MESSAGE_API_CALL_FAILED,
        context: context,
        popCount: 1
      );
    }
  }

  void login(context, loadingStateCallback, email, password, reset) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    FormData formData;

    Map params = GlobalFunctions.generateMapParam(
      ['email', 'password'], [email, password]
    );

    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
      context: context,
      params: formData,
      path: GlobalVars.apiUrl + "login"
    );
    
    if (data != null) {
      if (data['status'] == 200) {
        userModel = new UserModel(
            data['id'].toString(),
            data['name'],
            data['email'],
            data['roles'].toString(),
            data['access_token']
          );

        await savePersistence();

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return AppsPage();
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
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    final data = await GlobalFunctions.dioPostCall(
      context: context,
      options: Options(headers: {
        "Authorization": "Bearer " + userModel!.accessToken
      }),
      path: GlobalVars.apiUrl + "logout"
    );

    if(data.toString() == "") {
      if (data['status'] == 200) {
        await clearPersistence();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) {
            return const LoginPage();
          }), (route) => false);
      } else {
        CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: data['message'] ?? "-",
          context: context,
          popCount: 1
        );
      }
    } else {
      await clearPersistence();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) {
          return const LoginPage();
        }), (route) => false);
    }

    loadingStateCallback();
  }
}