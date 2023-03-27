import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:E_Library/controllers/kategori_controller.dart';
import 'package:E_Library/models/kategori_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/views/kategori/kategori_add_page.dart';

class KategoriDetailPage extends StatefulWidget {
  String? id;
  KategoriDetailPage({this.id});

  @override
  State<KategoriDetailPage> createState() => _KategoriDetailPageState();
}

class _KategoriDetailPageState extends State<KategoriDetailPage> {
  bool isLoading = false;

  UserModel? userModel;
  late KategoriController kategoriController;
  KategoriModel? kategoriDetail;
  TextEditingController namaKategoriController = new TextEditingController();

  setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    kategoriController = new KategoriController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();

    await getKategoriDetail();
  }
  
  getKategoriDetail() async {
    await kategoriController.kategoriDetail(context, setLoadingState, setData, widget.id);
  }

  setData(data) {
    if (data is KategoriModel && data != null) {
      if (this.mounted) {
        setState(() {
          kategoriDetail = data;
          namaKategoriController.value = new TextEditingController.fromValue(new TextEditingValue(text: kategoriDetail!.namaKategori)).value;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        actions: [
          Image(
            image: AssetImage("assets/images/logo/logo.png"),
          ),
        ],
      ),
      body: isLoading ? Loading.circularLoading() : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(top: 20, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(45, 45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                 padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "Detail Kategori Buku",
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 50),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              readOnly: true,
              controller: namaKategoriController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: 'Kategori',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(45, 5, 45, 5),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return KategoriAddPage(id: widget.id);
                        })
                      );
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(45, 5, 45, 5),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      kategoriController.kategoriDelete(context, setLoadingState, widget.id);
                    },
                    child: Text(
                      "Hapus",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}