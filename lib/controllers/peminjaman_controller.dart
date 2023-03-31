import 'dart:convert';
import 'dart:developer';

import 'package:E_Library/models/peminjaman_model.dart';
import 'package:E_Library/views/auth/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/global_vars.dart';
import 'package:E_Library/utils/strings.dart';
import 'package:E_Library/views/layouts/apps_page.dart';
import 'package:E_Library/widgets/custom_dialog.dart';
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

  addPeminjaman(context, loadingStateCallback, peminjaman_id, book_id, member_id, tgl_peminjaman, tgl_pengembalian, reset) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    Map params = GlobalFunctions.generateMapParam([
      'id',
      'id_buku',
      'id_member',
      'tanggal_peminjaman',
      'tanggal_pengembalian',
    ], [
      peminjaman_id,
      book_id,
      member_id,
      tgl_peminjaman,
      tgl_pengembalian,
    ]);

    log(jsonEncode(params.toString()));
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

  peminjaamanListGetMember(context, loadingStateCallback, setDataCallback, page) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    var params = GlobalFunctions.generateMapParam(
        ['page'], [page]);

    final data = await GlobalFunctions.dioGetCall(
        context: context,
        params: params,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlPeminjaman + "all/" + userModel!.id!);
        
    if (data != null) {
      if (data['status'] == 200) {
        List results = data['data']['data'];
        List<PeminjamanModel> _listPeminjaman = <PeminjamanModel>[];

        results.forEach((element) {
          _listPeminjaman.add(PeminjamanModel(
              id: element['id'],
              idBuku: element['id_buku'],
              judulBuku: element['book']['judul'],
              kategoriBuku: element['book']['category']['nama_kategori'],
              tanggalPeminjaman: element['tanggal_peminjaman'],
              tanggalPengembalian: element['tanggal_pengembalian'],
              createdAt: element['created_at'],
              updatedAt: element['updated_at'])
            );
        });

        if (_listPeminjaman.isNotEmpty) {
          setDataCallback(_listPeminjaman);
        }
      } else {
        CustomDialog.getDialog(
            title: Strings.DIALOG_TITLE_WARNING,
            message: data['message'].toString(),
            context: context,
            popCount: 1);
      }
    } else {
      await clearPersistence();

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return const LoginPage();
      }), (route) => false);

      CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: Strings.DIALOG_MESSAGE_API_TOKEN,
          context: context,
          popCount: 1);
    }
    
    loadingStateCallback();
  }
}