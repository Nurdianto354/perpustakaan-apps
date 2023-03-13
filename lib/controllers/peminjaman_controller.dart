import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/views/layouts/apps_page.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeminjamanController {
  BuildContext? context;
  UserModel? userModel;

  clearPersistence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(GlobalVars.idKey);
    prefs.remove(GlobalVars.nameKey);
    prefs.remove(GlobalVars.emailKey);
    prefs.remove(GlobalVars.roleKey);
    prefs.remove(GlobalVars.accessTokenKey);
  }

  PeminjamanController() {
    _getPersistence();
  }

  _getPersistence() async {
    userModel = await GlobalFunctions.getPersistence();
  }

  addPeminjaman(context, loadingStateCallback, book_id, member_id, tgl_peminjaman, tgl_pengembalian, status, reset) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    Map params = GlobalFunctions.generateMapParam([
      'id_buku',
      'id_member',
      'tanggal_peminjaman',
      'tanggal_pengembalian',
      'status',
    ], [
      book_id,
      member_id,
      tgl_peminjaman,
      tgl_pengembalian,
      status,
    ]);

    FormData formData;
    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        params: formData,
        path: GlobalVars.apiUrlPeminjaman + "create");

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "dashboard_page");
      }));

      CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_SUCCESS,
          message: data['message'] ?? "-",
          context: context,
          popCount: 1);
    } else {
      CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: data['message'] ?? "-",
          context: context,
          popCount: 1);
    }
    
    loadingStateCallback();
  }
}