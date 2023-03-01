import 'package:flutter/material.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  State<BukuPage> createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Buku"
      ),
    );
  }
}