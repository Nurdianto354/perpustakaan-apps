import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BukuAddPage extends StatefulWidget {
  BukuAddPage({super.key});

  @override
  State<BukuAddPage> createState() => _BukuAddPageState();
}

class _BukuAddPageState extends State<BukuAddPage> {
  String? title = "Tambah";

  TextEditingController namaKategoriController = new TextEditingController();
  
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
            padding: EdgeInsets.only(top: 20, bottom: 10),
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
                        title.toString() + " Buku",
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}