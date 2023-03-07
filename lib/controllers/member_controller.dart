import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/models/kategori_model.dart';
import 'package:perpustakaan/models/member_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/views/auth/login_page.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberController {
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

  MemberController() {
    _getPersistence();
  }

  _getPersistence() async {
    userModel = await GlobalFunctions.getPersistence();
  }

  memberListGet(context, loadingStateCallback, setDataCallback, page, {member}) async {
    if (userModel == null) {
      await _getPersistence();
    }

    loadingStateCallback();

    var params = GlobalFunctions.generateMapParam(
        ['page', 'name'], [page, member]);

    final data = await GlobalFunctions.dioGetCall(
        context: context,
        params: params,
        options: Options(
            headers: {"Authorization": "Bearer " + userModel!.accessToken}),
        path: GlobalVars.apiUrlMember + "all");
        
    if (data != null) {
      if (data['status'] == 200) {
        List results = data['data']['data'];
        List<MemberModel> _listKategori = <MemberModel>[];
        results.forEach((element) {
          _listKategori.add(MemberModel(
              id: element['id'],
              name: element['name'],
              email: element['email'],
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
}