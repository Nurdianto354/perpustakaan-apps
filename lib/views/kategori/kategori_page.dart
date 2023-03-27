import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:E_Library/controllers/kategori_controller.dart';
import 'package:E_Library/models/kategori_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/core/app_screen_size_helper.dart';
import 'package:E_Library/utils/core/app_theme.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/views/kategori/kategori_add_page.dart';
import 'package:E_Library/views/kategori/kategori_detail.dart';

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

  UserModel? userModel;
  late KategoriController kategoriController;
  List<KategoriModel> kategori = <KategoriModel>[];
  List<KategoriModel> _listKategori = <KategoriModel>[];
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
    kategoriController = new KategoriController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();
    _listKategori.clear();

    await get_listKategori();
  }

  get_listKategori() async {
    await kategoriController.kategoriListGet(
        context, setLoadingState, setKategori, page,
        kategori: searchController.text);
  }

  setKategori(data) {
    if (data is List<KategoriModel> && data.isNotEmpty) {
      if (this.mounted) {
        setState(() {
          kategori = data;
          _listKategori.addAll(kategori);
        });
      }
    }
  }

  refreshData() async {
    _listKategori.clear();
    page = 1;

    await get_listKategori();
  }

  _loadMoreData() async {
    await get_listKategori();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
                hintText: 'Cari...',
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
            child: Text(
              "List Kategori",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(15),
                width: ScreenSizeHelper.getDisplayWidth(context),
                child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: () async {
                      return Future<void>.delayed(const Duration(seconds: 3));
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

                                await _loadMoreData();
                              }
                            },
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _listKategori.length,
                                itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return KategoriDetailPage(
                                              id: _listKategori[index]
                                                  .id
                                                  .toString());
                                        }));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: ListTile(
                                            title: Text(
                                              _listKategori[index].namaKategori ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppTheme.colorPrimaryDark),
                                            ),
                                            trailing: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Colors.black,
                                                size: 30.0),
                                          ),
                                        ),
                                      ),
                                    );
                                },
                              ),
                            ),
                          ))),
          ),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.tealAccent[700],
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
            child: Icon(Icons.refresh),
            backgroundColor: Colors.tealAccent,
            onTap: () async {
              refreshData();
            },
            label: 'Refresh',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16.0),
            labelBackgroundColor: Colors.tealAccent),
        SpeedDialChild(
            child: Icon(EvaIcons.plus, color: Colors.black),
            backgroundColor: Colors.tealAccent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return KategoriAddPage(
                  id: null,
                );
              }));
            },
            label: 'Tambah',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16.0),
            labelBackgroundColor: Colors.tealAccent)
      ],
    );
  }
}
