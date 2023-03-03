import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/kategori_controller.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/core/app_screen_size_helper.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/views/kategori/kategori_add_page.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  bool isLoading = false;
  bool isLoadMore = false;
  bool isEnd = false;
  int page = 1;

  late KategoriController kategoriController;
  UserModel? userModel;

  setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    isEnd = false;
    kategoriController = new KategoriController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();
    await getKategori(); 
  }
  
  getKategori() async {
    await kategoriController.kategoriGet(context, setLoadingState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "List Kategori Buku",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.lightGrey2,
              border: Border.all(
                color: AppTheme.lightGrey2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              // controller: controllerSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (val) {},
            ),
          ),
          Expanded(
            child: Container(
              width: ScreenSizeHelper.getDisplayWidth(context),
              padding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.0,
        backgroundColor: Colors.tealAccent,
        onPressed: () async {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const KategoriAddPage();
            })
          );
        },
        icon: const Icon(EvaIcons.plus, color: Colors.black),
        label: const Text(
          "Tambah",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}