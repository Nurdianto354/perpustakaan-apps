import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/buku_controller.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/loading.dart';
import 'package:perpustakaan/views/buku/buku_add_page.dart';

class BukuDetailPage extends StatefulWidget {
  String? id;
  BukuDetailPage({this.id});

  @override
  State<BukuDetailPage> createState() => _BukuDetailPageState();
}

class _BukuDetailPageState extends State<BukuDetailPage> {
  bool isLoading = false;
  
  UserModel? userModel;
  late BukuController bukuController;
  BukuModel? bukuDetail;

  setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bukuController = new BukuController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();

    await getBukuDetail();
  }

  getBukuDetail() async {
    await bukuController.detailBuku(context, setLoadingState, setData, widget.id);
  }

  setData(data) {
    if (data is BukuModel && data != null) {
      if (this.mounted) {
        setState(() {
          bukuDetail = data;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            padding: EdgeInsets.only(top: 20, bottom: 5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(45, 45),
              ),
            ),
            child: Column(
              children: [
                Container(
                 padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "Detail Buku",
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            height: 200,
            child: Image(
              image: NetworkImage(
                bukuDetail!.path != null ? GlobalVars.urlAssetBook + bukuDetail!.path! : GlobalVars.urlAssetBook + "CoverNotAvailable.jpg",
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(
                  "Judul",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bukuDetail!.judul!,
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(35, 30, 35, 10),
                  child: Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Kategori",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ": " + bukuDetail!.namaKategori!,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Penerbit",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ": " + bukuDetail!.penerbit!,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Pengarang",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ": " + bukuDetail!.pengarang!,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Tahun",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ": " + bukuDetail!.tahun!,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Slug",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ": " + bukuDetail!.slug!,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Stok",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  ": " + bukuDetail!.stok!.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
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
                          return BukuAddPage(id: widget.id);
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
                      bukuController.deleteBuku(context, setLoadingState, widget.id);
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