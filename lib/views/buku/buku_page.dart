import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:perpustakaan/controllers/buku_controller.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/core/app_screen_size_helper.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/global_vars.dart';
import 'package:perpustakaan/utils/loading.dart';
import 'package:perpustakaan/views/buku/buku_add_page.dart';
import 'package:perpustakaan/views/buku/buku_detail.dart';

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

  UserModel? userModel;
  late BukuController bukuController;
  List<BukuModel> buku = <BukuModel>[];
  List<BukuModel> _listBuku = <BukuModel>[];

  TextEditingController searchController = new TextEditingController();

  setLoadingState() {
    setState(() {
      isLoading = !isLoading;
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
    await bukuController.getBukuList(context, setLoadingState, setData, page, null,
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
                        onPressed: () {},
                        child: Text(
                          "Import",
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Export",
                        ),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
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
                                        return BukuDetailPage(id: _listBuku[index].id.toString());
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
                                                  Text(
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
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
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
                                      trailing: Icon(
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
          ))
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
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
