import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/kategori_controller.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';

class KategoriAddPage extends StatefulWidget {
  const KategoriAddPage({super.key});

  @override
  State<KategoriAddPage> createState() => _KategoriAddPageState();
}

class _KategoriAddPageState extends State<KategoriAddPage> {
  late KategoriController kategoriController;
  bool isLoading = true;
  
  TextEditingController namaKategoriController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    kategoriController = new KategoriController();
  }

  void setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  void kategoriAdd() async {
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
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
                        "Tambah Kategori Buku",
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
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
        label: const Text("Simpan", style: TextStyle(color: Colors.black),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}