import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:E_Library/controllers/buku_controller.dart';
import 'package:E_Library/controllers/kategori_controller.dart';
import 'package:E_Library/models/buku_model.dart';
import 'package:E_Library/models/kategori_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/global_vars.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/views/dashboard/item_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLoading = false;
  bool isLoadingFirst = true;

  UserModel? userModel;
  late BukuController bukuController;
  late KategoriController kategoriController;
  List<BukuModel> buku = <BukuModel>[];
  List<BukuModel> _listBuku = <BukuModel>[];
  List<KategoriModel> kategori = <KategoriModel>[];
  List<KategoriModel> _listKategori = <KategoriModel>[];
  KategoriModel? kategoriSelect;
  int? selectedKategori = 0;
  
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bukuController = new BukuController();
    kategoriController = new KategoriController();

    initData();
  }
  
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  initData() async {
    userModel =  await GlobalFunctions.getPersistence();

    await getListBuku();
    await getListKategori();
  }

  getListBuku() async {
    await bukuController.getBukuList(context, setLoadingState, setDataBuku, null, null, buku: searchController.text);
  }

  setDataBuku(data) {
    _listBuku.clear();
    if (data is List<BukuModel> && data.isNotEmpty) {
      if (this.mounted) {
        setState(() {
          buku = data;
          _listBuku.addAll(buku);
        });
      }
    }
  }

  setDataBukuFilter(data) {
    if (this.mounted) {
      _listBuku.clear();
      buku = data;
      _listBuku.addAll(buku);
    }
  }

  getListKategori() async {
    await kategoriController.kategoriListGet(context, setLoadingState, setDataKategori, null);
    isLoadingFirst = false;
  }

  setDataKategori(data) {
    if (data is List<KategoriModel> && data.isNotEmpty) {
      if (this.mounted) {
        setState(() {
          data.add(KategoriModel(id: 0, namaKategori: "Semua", createdAt: "", updatedAt: ""));
          kategori = data.reversed.toList();
          _listKategori.addAll(kategori);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: isLoadingFirst ? Loading.circularLoading() : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                capitalize(userModel!.role!.toString()) + ", " + userModel!.name.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Apa yang ingin kamu baca \nhari ini",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              _searchBar(selectedKategori),
              Text(
                "Kategori",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.tealAccent,
                      offset: const Offset(
                        2.0,
                        2.0,
                      ),
                      blurRadius: 2.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _listKategori.length,
                    itemBuilder: (context, index) {
                      int? selectItemKategori = _listKategori[index].id;
                      return GestureDetector(
                        onTap: () async {
                          await bukuController.getBukuList(context, setLoadingState, setDataBukuFilter, null, selectItemKategori, buku: searchController.text);
                          selectedKategori = selectItemKategori;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _listKategori[index].id == selectedKategori
                                ? Colors.tealAccent[700]
                                : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            _listKategori[index].namaKategori.toUpperCase(),
                            style: TextStyle(
                              color: _listKategori[index].id == selectedKategori
                                ? Colors.white
                                : Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                      );
                    },
                  ),
                ),
              ),
              isLoading ? Loading.circularLoading() :  SizedBox(
                height: _listBuku.isEmpty ? 50 : MediaQuery.of(context).size.height,
                child: _listBuku.isEmpty ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent,
                        offset: const Offset(
                          2.0,
                          2.0,
                        ),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Text(
                    "Data tidak ada"
                  ),
                ) : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20
                  ),
                  itemCount: _listBuku.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return ItemDetailPage(id: null, idBuku: _listBuku[index].id, status: "peminjaman",);
                        }));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.tealAccent,
                              offset: const Offset(
                                2.0,
                                2.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                height: 50,
                                image: NetworkImage(
                                  _listBuku[index].path != null ? GlobalVars.urlAssetBook + _listBuku[index].path! : GlobalVars.urlAssetBook + "CoverNotAvailable.jpg",
                                  scale: 6
                                ),
                              ),
                              Text(
                                _listBuku[index].judul.toString(),
                                style: Theme.of(context) .textTheme .headlineMedium ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _listBuku[index].penerbit.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(selectItemKategori) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Cari buku ...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        ),
        onChanged: (val) async {
          await bukuController.getBukuList(context, setLoadingState, setDataBukuFilter, null, selectItemKategori, buku: searchController.text);
        },
      ),
    );
  }
}