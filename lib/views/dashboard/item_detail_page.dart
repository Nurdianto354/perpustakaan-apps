import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:E_Library/controllers/buku_controller.dart';
import 'package:E_Library/controllers/peminjaman_controller.dart';
import 'package:E_Library/models/buku_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/core/app_extension.dart';
import 'package:E_Library/utils/global_function.dart';
import 'package:E_Library/utils/global_vars.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/utils/strings.dart';
import 'package:E_Library/widgets/custom_dialog.dart';
import 'package:E_Library/widgets/scale_animation.dart';

class ItemDetailPage extends StatefulWidget {
  int? id, idBuku;
  String? status;
  ItemDetailPage({super.key, this.id, this.idBuku, this.status});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  bool isLoading = false;
  
  UserModel? userModel;
  late BukuController bukuController;
  late PeminjamanController peminjamanController;
  BukuModel? bukuDetail;

  TextEditingController datePeminjaman = TextEditingController(); 
  TextEditingController datePengembalian = TextEditingController(); 

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
    peminjamanController = new PeminjamanController();

    initData();
    datePeminjaman.text = "";
    datePengembalian.text = "";
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();

    await getBukuDetail();
  }

  getBukuDetail() async {
    await bukuController.detailBuku(context, setLoadingState, setData, widget.idBuku.toString());
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

  addPeminjaman(idBuku) async {
    if(datePeminjaman.text.isNotEmpty || datePengembalian.text.isNotEmpty) {
      peminjamanController.addPeminjaman(context, setLoadingState, widget.id.toString(), idBuku.toString(), userModel!.id.toString(), datePeminjaman.text, datePengembalian.text, reset);
    } else {
      CustomDialog.getDialog(
          title: Strings.DIALOG_TITLE_WARNING,
          message: Strings.DIALOG_MESSAGE_INSUFFICENT_INPUT,
          context: context,
          popCount: 1);
    }
  }

  reset() {
    setState(() {
      datePeminjaman.text = "";
      datePengembalian.text = "";
    });
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Buku Detail",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        Image(
          image: AssetImage("assets/images/logo/logo.png"),
        ),
      ],
    );
  }

  getDatePicker(params) async {
    DateTime? pickedDate = await showDatePicker(
      context: context, initialDate: DateTime.now(),
      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101)
    );
    
    if(pickedDate != null ){
      print(pickedDate);
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      print(formattedDate);

      setState(() {
        params.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _appBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: isLoading ? Loading.circularLoading() : BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Judul Buku",
                      style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                    ).fadeAnimation(0.4),
                    Text(
                      bukuDetail!.judul!,
                      style: Theme.of(context).textTheme.displayLarge ?.copyWith(color: Colors.black54),
                    ).fadeAnimation(0.6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          "Keterangan",
                          style: Theme.of(context).textTheme.displayMedium,
                        ).fadeAnimation(0.8),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pengarang",
                                    style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bukuDetail!.penerbit!,
                                    style: Theme.of(context).textTheme.displaySmall ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Katgori",
                                    style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bukuDetail!.namaKategori!,
                                    style: Theme.of(context).textTheme.displaySmall ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pengarang",
                                    style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bukuDetail!.pengarang!,
                                    style: Theme.of(context).textTheme.displaySmall ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tahun Terbit",
                                    style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bukuDetail!.tahun!,
                                    style: Theme.of(context).textTheme.displaySmall ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stok",
                                    style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bukuDetail!.stok!.toString(),
                                    style: Theme.of(context).textTheme.displaySmall ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Slug",
                                    style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    bukuDetail!.slug!,
                                    style: Theme.of(context).textTheme.displaySmall ?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).fadeAnimation(0.8),
                    const SizedBox(height: 40),
                    widget.status == 'peminjaman' && userModel!.role != 'admin' ? SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: ElevatedButton(
                          onPressed: () {
                            _modalPeminjaman(context);
                          },
                          child: const Text("Peminjamann Buku"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.tealAccent[700],
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ).fadeAnimation(1) : Container(),
                    widget.status == 'pengembalian' && userModel!.role != 'admin' ? SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: ElevatedButton(
                          onPressed: () {
                            _modalPengembalian(context);
                          },
                          child: const Text("Pengembalian Buku"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.tealAccent[700],
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ).fadeAnimation(1) : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading ? Loading.circularLoading() : ScaleAnimation(
        child: Center(
          child: Image(
            image: NetworkImage(
              bukuDetail!.path != null ? GlobalVars.urlAssetBook + bukuDetail!.path! : GlobalVars.urlAssetBook + "CoverNotAvailable.jpg",
              scale: 2
            ),
          ),
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
                        "Peminjaman Buku",
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
                      Text(
                        "Judul Buku",
                        style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                      ).fadeAnimation(0.4),
                      Text(
                        bukuDetail!.judul!,
                        style: Theme.of(context).textTheme.displayLarge ?.copyWith(color: Colors.black54),
                      ).fadeAnimation(0.6),
                      const SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        width: 200,
                        child: TextField(
                          controller: datePeminjaman,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Tanggal Peminjaman",
                          ),
                          readOnly: true,
                          onTap: () async {
                            await getDatePicker(datePeminjaman);
                          },
                        )
                      ).fadeAnimation(0.8),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            await addPeminjaman(bukuDetail!.id);
                          },
                          child: Text("Pinjam Buku"),
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

  _modalPengembalian(context) {
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
                      margin: const EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        "Pengembalian Buku",
                        style: Theme.of(context).textTheme.displayLarge ?.copyWith(color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, right: 5),
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                        color: const Color(0xfff8f8f8),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Judul Buku",
                        style: Theme.of(context).textTheme.titleMedium ?.copyWith(color: Colors.tealAccent[600]),
                      ).fadeAnimation(0.4),
                      Text(
                        bukuDetail!.judul!,
                        style: Theme.of(context).textTheme.displayLarge ?.copyWith(color: Colors.black54),
                      ).fadeAnimation(0.6),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        width: 200,
                        child: TextField(
                          controller: datePengembalian,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                            labelText: "Tanggal Pengembalian",
                          ),
                          readOnly: true,
                          onTap: () async {
                            await getDatePicker(datePengembalian);
                          },
                        ),
                      ).fadeAnimation(0.8),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            await addPeminjaman(bukuDetail!.id);
                          },
                          child: const Text("Kembalikan Buku"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.tealAccent[700],
                            textStyle: TextStyle(
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
}