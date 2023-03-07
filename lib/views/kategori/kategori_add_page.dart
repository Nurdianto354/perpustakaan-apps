import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/kategori_controller.dart';
import 'package:perpustakaan/models/kategori_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/loading.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';

class KategoriAddPage extends StatefulWidget {
  String? id;
  KategoriAddPage({this.id});

  @override
  State<KategoriAddPage> createState() => _KategoriAddPageState();
}

class _KategoriAddPageState extends State<KategoriAddPage> {
  UserModel? userModel;
  KategoriModel? kategoriDetail;
  
  late KategoriController kategoriController;
  bool isLoading = false;
  String? title;
  
  TextEditingController namaKategoriController = new TextEditingController();

  void setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.id == null ? "Tambah" : "Update";

    kategoriController = new KategoriController();
    
    if(widget.id != null) {
      initData();
    }
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();

    await _getKategoriDetail();
  }

  _getKategoriDetail() async {
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

  kategoriAdd() async {
    if(widget.id == null) {
      if(namaKategoriController.text != "") {
        kategoriController.kategoriAdd(context, setLoadingState, namaKategoriController.text, reset);
      } else {
        CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: Strings.DIALOG_MESSAGE_INSUFFICENT_INPUT,
          context: context,
          popCount: 1
        );
      }
    } else {
      if(namaKategoriController.text != "") {
        kategoriController.kategoriUpdate(context, setLoadingState, widget.id, namaKategoriController.text, reset);
      } else {
        CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: Strings.DIALOG_MESSAGE_INSUFFICENT_INPUT,
          context: context,
          popCount: 1
        );
      }
    }
  }

  void reset() {
    setState(() {
      namaKategoriController.text = "";
    });
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
                        title.toString() + " Kategori Buku",
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
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
                      controller: namaKategoriController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintText: "Kategori",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.0,
        backgroundColor: Colors.tealAccent,
        onPressed: kategoriAdd,
        icon: const Icon(Icons.edit, color: Colors.black,),
        label: Text(
          title.toString(),
          style: TextStyle(color: Colors.black)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}