import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/utils/core/app_screen_size_helper.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "List Buku",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.lightGrey2,
              border: Border.all(
                color: AppTheme.lightGrey2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              // controller: controllerSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSubmitted: (val) {},
            ),
          ),
          Expanded(
            child: Container(
              width: ScreenSizeHelper.getDisplayWidth(context),
              padding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: AppTheme.colorAccent,
        child: Icon(EvaIcons.plus, color: AppTheme.white, size: 28),
        onPressed: () {},
      ),
    );
  }
}