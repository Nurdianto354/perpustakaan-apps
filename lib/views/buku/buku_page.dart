import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:perpustakaan/controllers/buku_controller.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/core/app_screen_size_helper.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/loading.dart';
import 'package:perpustakaan/views/buku/buku_add_page.dart';

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
    await bukuController.getBukuList(context, setLoadingState, setData, page, buku: searchController.text);
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
              "List Buku",
              style: Theme.of(context).textTheme.displayMedium,
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
                child: isLoading ? Loading.circularLoading() : LazyLoadScrollView(
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
                            
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: ListTile(
                                title: Text(
                                  _listBuku[index].judul ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.colorPrimaryDark
                                  ),
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                              ),
                            ),
                          ),
                        );
                      }
                    )
                   )
                ),
              ),
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.0,
        backgroundColor: Colors.tealAccent,
        onPressed: () async {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return BukuAddPage();
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
