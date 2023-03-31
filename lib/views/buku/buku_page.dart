import 'dart:io';

import 'package:E_Library/utils/core/app_extension.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:E_Library/controllers/buku_controller.dart';
import 'package:E_Library/models/buku_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/core/app_screen_size_helper.dart';
import 'package:E_Library/utils/core/app_theme.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/global_vars.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/views/buku/buku_add_page.dart';
import 'package:E_Library/views/buku/buku_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  bool isLoading = false;
  bool isLoadMore = false;
  bool isEnd = false;
  int page = 1;
  
  TextEditingController txtFilePicker = new TextEditingController();
  File? filePickerVal;

  UserModel? userModel;
  late BukuController bukuController;
  List<BukuModel> buku = <BukuModel>[];
  List<BukuModel> _listBuku = <BukuModel>[];

  TextEditingController searchController = new TextEditingController();

  setLoadingState() {
    setState(() {
      if (page == 1) {
        isLoading = !isLoading;
      } else {
        isLoadMore = !isLoadMore;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isEnd = false;
    bukuController = new BukuController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();
    _listBuku.clear();

    await getListBuku();
  }

  getListBuku() async {
    await bukuController.getBukuList(
        context, setLoadingState, setData, page, null,
        buku: searchController.text);
  }

  setData(data) {
    if (data is List<BukuModel> && data.isNotEmpty) {
      if (this.mounted) {
        setState(() {
          buku = data;
          _listBuku.addAll(buku);
        });
      }
    }
  }

  refreshData() async {
    _listBuku.clear();
    page = 1;
    await getListBuku();
  }

  loadMoreData() async {
    await getListBuku();
  }

  importDataBuku() async {
    await bukuController.importData(context, setLoadingState, filePickerVal, reset);
  }

  reset() {
    setState(() {
      filePickerVal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(right: 15),
            child: Image(
              height: 50,
              image: AssetImage("assets/images/logo/logo.png"),
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.lightGrey2,
              border: Border.all(
                color: AppTheme.lightGrey2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Judul Buku ...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (val) async {
                initData();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "List Buku",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {
                          _modalPeminjaman(context);
                        },
                        child: const Text(
                          "Import",
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () async {
                          String url = GlobalVars.apiUrlBook + "export/template";
                          await launch(url);
                        },
                        child: const Text(
                          "Template",
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () async {
                          String url = GlobalVars.apiUrlBook + "export/excel";
                          await launch(url);
                        },
                        child: const Text(
                          "Excel",
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () async {
                          String url = GlobalVars.apiUrlBook + "export/pdf";
                          await launch(url);
                        },
                        child: const Text(
                          "Pdf",
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: ScreenSizeHelper.getDisplayWidth(context),
              child: RefreshIndicator(
              onRefresh: () async {
                refreshData();
              },
              child: isLoading
                  ? Loading.circularLoading()
                  : LazyLoadScrollView(
                      scrollOffset: 2,
                      isLoading: isLoadMore,
                      onEndOfPage: () async {
                        if (!isLoadMore && !isEnd) {
                          setState(() {
                            page++;
                          });
                          await loadMoreData();
                        }
                      },
                      child: Scrollbar(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _listBuku.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return BukuDetailPage(
                                          id: _listBuku[index].id.toString());
                                    }));
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: Image(
                                        image: NetworkImage(
                                          _listBuku[index].path != null
                                              ? GlobalVars.urlAssetBook +
                                                  (_listBuku[index].path)
                                                      .toString()
                                              : GlobalVars.urlAssetBook +
                                                  "CoverNotAvailable.jpg",
                                        ),
                                      ),
                                      title: Text(
                                        _listBuku[index].judul ?? '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.colorPrimaryDark),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Penerbit :",
                                                  ),
                                                  Text(
                                                    _listBuku[index].penerbit ??
                                                        '',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppTheme
                                                            .colorPrimaryDark),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Tahun Terbit :",
                                                  ),
                                                  Text(
                                                    _listBuku[index].tahun ??
                                                        '',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppTheme
                                                            .colorPrimaryDark),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _listBuku[index].slug ?? '',
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.black,
                                        size: 30.0,
                                      ),
                                      isThreeLine: true,
                                    ),
                                  ),
                                );
                              }))),
            ),
          )),
          isLoadMore ? Loading.circularLoading() : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.0,
        backgroundColor: Colors.tealAccent,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BukuAddPage();
          }));
        },
        icon: const Icon(EvaIcons.plus, color: Colors.black),
        label: const Text(
          "Tambah",
          style: TextStyle(color: Colors.black, fontSize: 17.5),
        ),
      ),
    );
  }

  _modalPeminjaman(context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return Container(
          height: 330,
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                )
              ],
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        "Import Data Buku",
                        style: Theme.of(context).textTheme.displayLarge ?.copyWith(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, right: 5),
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xfff8f8f8),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      buildFilePicker().fadeAnimation(0.8),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            await importDataBuku();
                          },
                          child: Text("Import"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.tealAccent[700],
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ).fadeAnimation(1.0),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
  
  Widget buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'File harus diupload';
                } else {
                  return null;
                }
              },
              controller: txtFilePicker,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Upload Gambar Cover',
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              selectFile();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.tealAccent[700],
              minimumSize: const Size(122, 48),
              maximumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['xls', 'xlsx']);

    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        filePickerVal = File(result.files.single.path.toString());
      });
    } else {
      // User canceled the picker
    }
  }
}
