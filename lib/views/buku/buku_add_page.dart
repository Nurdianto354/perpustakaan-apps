import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:E_Library/controllers/buku_controller.dart';
import 'package:E_Library/controllers/kategori_controller.dart';
import 'package:E_Library/models/buku_model.dart';
import 'package:E_Library/models/kategori_model.dart';
import 'package:E_Library/models/user_model.dart';
import 'package:E_Library/utils/loading.dart';
import 'package:E_Library/utils/strings.dart';
import 'package:E_Library/widgets/custom_dialog.dart';

class BukuAddPage extends StatefulWidget {
  String? id;
  BukuAddPage({this.id});

  @override
  State<BukuAddPage> createState() => _BukuAddPageState();
}

class _BukuAddPageState extends State<BukuAddPage> {
  String? title;

  TextEditingController txtKode = new TextEditingController();
  TextEditingController txtJudul = new TextEditingController();
  TextEditingController txtSlug = new TextEditingController();
  TextEditingController txtPenerbit = new TextEditingController();
  TextEditingController txtPengarang = new TextEditingController();
  TextEditingController txtTahun = new TextEditingController();
  TextEditingController txtStok = new TextEditingController();
  TextEditingController txtFilePicker = new TextEditingController();

  DateTime date = DateTime.now();
  File? filePickerVal;

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
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        filePickerVal = File(result.files.single.path.toString());
      });
    } else {
      // User canceled the picker
    }
  }

  UserModel? userModel;
  BukuModel? bukuDetail;

  late BukuController bukuController;
  late KategoriController kategoriController;
  bool isLoading = false;

  List<KategoriModel> kategori = <KategoriModel>[];
  int? selectedKategori;

  void setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();

    title = widget.id == null ? "Tambah" : "Update";

    bukuController = new BukuController();
    kategoriController = new KategoriController();

    initData();
  }

  initData() async {
    await getKategoriBuku();

    if(widget.id != null) {
      await getBukuDetail();
    } 
  }

  getKategoriBuku() async {
    await kategoriController.kategoriListGet(
        context, setLoadingState, setDropdownKategori, null);
  }

  setDropdownKategori(data) {
    if (data is List<KategoriModel> && data.isNotEmpty) {
      if (this.mounted) {
        setState(() {
          kategori = data;
        });
      }
    }
  }

  getBukuDetail() async {
    await bukuController.detailBuku(context, setLoadingState, setData, widget.id);
  }

  setData(data) {
    if (data is BukuModel && data != null) {
      if (this.mounted) {
        setState(() {
          bukuDetail = data;
          txtKode.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.kodeBuku!)).value;
          txtJudul.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.judul!)).value;
          txtSlug.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.slug!)).value;
          txtPenerbit.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.penerbit!)).value;
          txtPengarang.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.pengarang!)).value;
          txtTahun.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.tahun!)).value;
          txtStok.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.stok!.toString())).value;

          if(bukuDetail!.path != null) {
            txtFilePicker.value = new TextEditingController.fromValue(new TextEditingValue(text: bukuDetail!.path!.toString())).value;
          }

          selectedKategori = bukuDetail!.categoryId!;
        });
      }
    }
  }

  addBuku() async {
    if (txtKode.text.isNotEmpty &&
        selectedKategori != null &&
        txtJudul.text.isNotEmpty &&
        txtPenerbit.text.isNotEmpty &&
        txtPengarang.text.isNotEmpty &&
        txtTahun.text.isNotEmpty &&
        txtStok.text.isNotEmpty) {
          if(widget.id == null) {
            bukuController.createBuku(
              context,
              setLoadingState,
              txtKode.text,
              selectedKategori,
              txtJudul.text,
              txtSlug.text,
              txtPenerbit.text,
              txtPengarang.text,
              txtTahun.text,
              txtStok.text,
              filePickerVal,
              reset);
          } else {
            bukuController.updateBuku(
              context,
              setLoadingState,
              widget.id,
              txtKode.text,
              selectedKategori,
              txtJudul.text,
              txtSlug.text,
              txtPenerbit.text,
              txtPengarang.text,
              txtTahun.text,
              txtStok.text,
              filePickerVal,
              reset);
          }
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
      txtKode.text = "";
      selectedKategori = null;
      txtJudul.text = "";
      txtSlug.text = "";
      txtPenerbit.text = "";
      txtPengarang.text = "";
      txtTahun.text = "";
      txtStok.text = "";
      txtFilePicker.text = "";
      filePickerVal = null;
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
            height: 70,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(top: 20),
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
                  child: Column(children: [
                    Text(
                      title.toString() + " Buku",
                      style: Theme.of(context).textTheme.displayMedium,
                    )
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 5, 4, 5),
                          child: TextFormField(
                            controller: txtKode,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Kode',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: showDropdownKategori(),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      controller: txtJudul,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Judul',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      controller: txtSlug,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Slug',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      controller: txtPenerbit,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Penerbit',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      controller: txtPengarang,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Pengarang',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 5, 4, 5),
                          child: TextFormField(
                            controller: txtTahun,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Tahun',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4, 5, 8, 5),
                          child: TextFormField(
                            controller: txtStok,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Stok',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildFilePicker(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.0,
        backgroundColor: Colors.tealAccent,
        onPressed: addBuku,
        icon: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
        label: Text(title.toString(), style: TextStyle(color: Colors.black, fontSize: 17.5)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget showDropdownKategori() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4, 5, 8, 5),
      child: DropdownButtonHideUnderline(
        child: Container(
          height: 53,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: DropdownButtonFormField(
            value: selectedKategori,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Pilih Kategori',
            ),
            onChanged: (int? value) async {
              setState(() {
                selectedKategori = value;
              });
            },
            items: kategori.map((KategoriModel element) {
              log(element.toString());
              return DropdownMenuItem<int>(
                child: Text(
                  element.namaKategori,
                ),
                value: element.id,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
