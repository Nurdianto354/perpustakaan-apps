import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/views/auth/login_page.dart';
import 'package:perpustakaan/views/layouts/apps_page.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BukuController {
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

  BukuController() {
    _getPersistence();
  }

  _getPersistence() async {
    userModel = await GlobalFunctions.getPersistence();
  }

  getBukuList(context, loadingStateCallback, setDataCallback, page, categoryId, {buku}) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    var params;

    if(page != null) {
      params = GlobalFunctions.generateMapParam(['page', 'judul'], [page, buku]);
    } else if(categoryId != null && categoryId != 0) {
      params = GlobalFunctions.generateMapParam(['judul', 'category_id'], [buku, categoryId]);
    } else {
      params = GlobalFunctions.generateMapParam(['judul'], [buku]);
    }

    final data = await GlobalFunctions.dioGetCall(
        context: context,
        params: params,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlBook + "all");

    if (data != null) {
      if (data['status'] == 200) {
        List results;

        if(page != null) {
          results = data['data']['data'];
        } else {
          results = data['data'];
        }

        List<BukuModel> _listBuku = <BukuModel>[];
        results.forEach((element) {
          _listBuku.add(BukuModel(
              kodeBuku: element['kode_buku'],
              id: element['id'],
              categoryId: element['category_id'],
              judul: element['judul'],
              slug: element['slug'],
              penerbit: element['penerbit'],
              pengarang: element['pengarang'],
              tahun: element['tahun'],
              stok: element['stok'],
              path: element['path'],
              createdAt: element['created_at'],
              updatedAt: element['updated_at']));
        });

        if(categoryId != null && categoryId != 0) {
          setDataCallback(_listBuku);
        } else if (_listBuku.isNotEmpty) {
          setDataCallback(_listBuku);
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

  createBuku(context, loadingStateCallback, kode, kategori, judul, slug, penerbit,
      pengarang, tahun, stok, file, reset) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    Map params = GlobalFunctions.generateMapParam([
      'kode_buku',
      'category_id',
      'judul',
      'slug',
      'penerbit',
      'pengarang',
      'tahun',
      'stok',
      'path'
    ], [
      kode,
      kategori,
      judul,
      slug,
      penerbit,
      pengarang,
      tahun,
      stok,
      file == null ? null : await MultipartFile.fromFile(file.path)
    ]);

    FormData formData;
    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        params: formData,
        path: GlobalVars.apiUrlBook + "create");

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "buku_page");
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

  detailBuku(context, loadingStateCallback, setDataCallback, idBuku) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    final data = await GlobalFunctions.dioGetCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlBook + "detail/" + idBuku);

    if (data != null) {
      if (data['status'] == 200) {
        BukuModel detailBuku = new BukuModel(
          id: data['data']['id'],
          kodeBuku: data['data']['kode_buku'],
          categoryId: data['data']['category_id'],
          namaKategori: data['data']['category']['nama_kategori'],
          judul: data['data']['judul'],
          slug: data['data']['slug'],
          penerbit: data['data']['penerbit'],
          pengarang: data['data']['pengarang'],
          tahun: data['data']['tahun'],
          stok: data['data']['stok'],
          path: data['data']['path'],
          createdAt: data['data']['created_at'],
          updatedAt: data['data']['updated_at']
        );

        setDataCallback(detailBuku);
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

  updateBuku(context, loadingStateCallback, idBuku, kode, kategori, judul, slug, penerbit,
      pengarang, tahun, stok, file, reset) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    Map params = GlobalFunctions.generateMapParam([
      'id',
      'kode_buku',
      'category_id',
      'judul',
      'slug',
      'penerbit',
      'pengarang',
      'tahun',
      'stok',
      'path'
    ], [
      idBuku,
      kode,
      kategori,
      judul,
      slug,
      penerbit,
      pengarang,
      tahun,
      stok,
      file == null ? null : await MultipartFile.fromFile(file.path)
    ]);

    FormData formData;
    formData = FormData.fromMap(params as Map<String, dynamic>);

    final data = await GlobalFunctions.dioPostCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        params: formData,
        path: GlobalVars.apiUrlBook + "create");

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "buku_page");
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

  deleteBuku(context, loadingStateCallback, idBuku) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    final data = await GlobalFunctions.dioDeleteCall(
        context: context,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlBook + "delete/" + idBuku);

    if (data['status'] == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AppsPage(page: "buku_page");
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
