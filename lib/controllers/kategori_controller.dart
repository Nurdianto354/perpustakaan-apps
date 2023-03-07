import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/models/kategori_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/views/auth/login_page.dart';
import 'package:perpustakaan/views/layouts/apps_page.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KategoriController {
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

  KategoriController() {
    _getPersistence();
  }

  _getPersistence() async {
    userModel = await GlobalFunctions.getPersistence();
  }

  kategoriListGet(context, loadingStateCallback, setDataCallback, page, {kategori}) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    var params = GlobalFunctions.generateMapParam(
        ['page', 'nama_kategori'], [page, kategori]);

    final data = await GlobalFunctions.dioGetCall(
        context: context,
        params: params,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlKategori + "all");

    if (data != null) {
      if (data['status'] == 200) {
        List results = data['data']['data'];
        List<KategoriModel> _listKategori = <KategoriModel>[];
        results.forEach((element) {
          _listKategori.add(KategoriModel(
              id: element['id'],
              namaKategori: element['nama_kategori'],
              createdAt: element['created_at'],
              updatedAt: element['updated_at']));
        });

        if (_listKategori.isNotEmpty) {
          setDataCallback(_listKategori);
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

  void kategoriAdd(context, loadingStateCallback, nama, reset) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    Map params = GlobalFunctions.generateMapParam(['nama_kategori'], [nama]);
    FormData formData;
    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        params: formData,
        path: GlobalVars.apiUrlKategori + "create");

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "kategori_page");
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

  kategoriDetail(context, loadingStateCallback, setDataCallback, idKategori) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    final data = await GlobalFunctions.dioGetCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlKategori + "detail/" + idKategori);

    if (data != null) {
      if (data['status'] == 200) {
        KategoriModel kategoriDetail = new KategoriModel(id: data['data']['id'], namaKategori: data['data']['nama_kategori'], createdAt: data['data']['created_at'], updatedAt: data['data']['updated_at']);
        
        setDataCallback(kategoriDetail);
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

  kategoriUpdate(context, loadingStateCallback, idKategori, nama, reset) async{
    if (userModel == null) {
      await _getPersistence();
    }
    
    loadingStateCallback();

    FormData formData;
    Map params = GlobalFunctions.generateMapParam(['nama_kategori'], [nama]);
    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
        context: context,
        options: Options(
          headers: {
            "Authorization": "Bearer " + userModel!.accessToken,
            "Content-Type": "application/x-www-form-urlencoded"
          }
        ),
        params: formData,
        path: GlobalVars.apiUrlKategori + "update/" + idKategori);
        log(data.toString());

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "kategori_page");
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

  kategoriDelete(context, loadingStateCallback, idKategori) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    final data = await GlobalFunctions.dioDeleteCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlKategori + "delete/" + idKategori);

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "kategori_page");
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
