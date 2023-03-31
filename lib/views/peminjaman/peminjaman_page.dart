import 'package:E_Library/controllers/peminjaman_controller.dart';
import 'package:E_Library/models/peminjaman_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/core/app_screen_size_helper.dart';
import 'package:E_Library/utils/core/app_theme.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/views/dashboard/item_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  bool isLoading = false;
  bool isLoadMore = false;
  bool isEnd = false;
  int page = 1;

  UserModel? userModel;
  late PeminjamanController peminjamanController;
  List<PeminjamanModel> peminjaman = <PeminjamanModel> [];
  List<PeminjamanModel> listPeminjaman = <PeminjamanModel> [];
  TextEditingController searchController = new TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnd = false;
    peminjamanController = new PeminjamanController();

    initData();
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();
    listPeminjaman.clear();
    
    await getListPeminjaman();
  }

  setLoadingState() {
    setState(() {
      if (page == 1) {
        isLoading = !isLoading;
      } else {
        isLoadMore = !isLoadMore;
      }
    });
  }

  getListPeminjaman() async {
    await peminjamanController.peminjaamanListGetMember(context, setLoadingState, setPeminjaman, page);
  }

  refreshData() async {
    listPeminjaman.clear();
    page = 1;
    await getListPeminjaman();
  }

  _loadMoreData() async {
    await getListPeminjaman();
  }

  setPeminjaman(data) {
    if(data is List<PeminjamanModel> && data.isNotEmpty) {
      if(this.mounted) {
        setState(() {
          peminjaman = data;
          listPeminjaman.addAll(peminjaman);
        });
      }
    }
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
              "List Peminjaman",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: ScreenSizeHelper.getDisplayWidth(context),
              child: RefreshIndicator(
                child: isLoading ? Loading.circularLoading() : LazyLoadScrollView(
                  scrollOffset: 2,
                  isLoading: isLoadMore,
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listPeminjaman.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ItemDetailPage(
                                  id: listPeminjaman[index].id, idBuku: listPeminjaman[index].idBuku, status: 'pengembalian');
                                }
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: ListTile(
                                title: Text(
                                  listPeminjaman[index].judulBuku ?? '-',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.colorPrimaryDark
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                  size: 30.0
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  onEndOfPage: () async {
                  if (!isLoadMore && !isEnd) {
                    setState(() {
                      page++;
                    });

                    await _loadMoreData();
                  }
                },
                ),
                onRefresh: () async {
                  refreshData();
                },
              ),
            ),
          ),
          isLoadMore ? Loading.circularLoading() : Container(),
        ],
      ),
    );
  }
}