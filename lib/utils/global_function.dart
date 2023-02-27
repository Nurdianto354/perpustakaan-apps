import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/src/model/user_model.dart';
import 'package:perpustakaan/src/view/widget/custom_dialog.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalFunctions {
  static Future<UserModel> getPersistence() async {
    UserModel userModel;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userModel = new UserModel(
      prefs.get(GlobalVars.idKey) as String?,
      prefs.get(GlobalVars.nameKey) as String?,
      prefs.get(GlobalVars.emailKey) as String?,
      prefs.get(GlobalVars.roleKey) as String?,
      prefs.get(GlobalVars.accessTokenKey) as String?
    );

    return userModel;
  }

  static dynamic generateMapParam(List<String> key, List<dynamic> params) {
    Map<String, dynamic> param = new Map();
    
    if (params.length == key.length) {
      for (int i = 0; i < key.length; i++) {
        param[key[i]] = params[i];
      }
    } else {
      return "0";
    }

    return param;
  }

  static Future<dynamic> dioPostCall({params, required path, context, options}) async {
    Dio dio;
    Response _localResp;
    var data;
    dev.log(params is FormData ? params.fields.toString() : params.toString());
    dev.log(path.toString());

    DateTime _requestStart = DateTime.now();

    try {
      dio = new Dio();
      dio.options.connectTimeout  = GlobalVars.LIMIT_MAX_CONNECTION_TIMEOUT;
      dio.options.sendTimeout     = GlobalVars.LIMIT_MAX_CONNECTION_TIMEOUT;
      dio.options.receiveTimeout  = GlobalVars.LIMIT_MAX_CONNECTION_TIMEOUT;

      _localResp = await dio.post(path, data: params, options: options);
      data = _localResp.data;

      DateTime _requestEnd  = DateTime.now();
      Duration _diff        = _requestStart.difference(_requestEnd);

      dev.log("job done. time : ${_diff.inSeconds.abs().toString()} seconds");
    } on DioError catch (e) {
      DateTime _requestEnd  = DateTime.now();
      Duration _diff        = _requestStart.difference(_requestEnd);

      if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout || e.type == DioErrorType.sendTimeout) {
        // throw Exception("Connection  Timeout Exception");
        dev.log("timeout. time : ${_diff.inSeconds.abs().toString()} seconds");
        
       return null;
      }

      debugPrint(e.response.toString());
      CustomDialog.getDialog(
        title: Strings.DIALOG_TITLE_ERROR,
        message: Strings.DIALOG_MESSAGE_API_CALL_FAILED,
        context: context,
        popCount: 1
      );
    }

    return data;
  }
}