import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLoading = false;
  UserModel? userModel;
  Map userLogin = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
  }

  void loadingStateCallback() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  initData() async {
    userModel = await GlobalFunctions.getPersistence();
    
    loadingStateCallback();

    setState(() {
      userLogin['name'] = userModel!.name;
      userLogin['roles'] = userModel!.role;
    });

    loadingStateCallback();
  }
  
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                isLoading ? "-" : capitalize(userLogin['roles'].toString()) + ", " + userLogin['name'].toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Apa yang ingin kamu baca \nhari ini",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
              ),
            ],
          ),
        ),
      ),
    );
  }
}