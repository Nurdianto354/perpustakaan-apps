import 'package:flutter/material.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';
import 'package:perpustakaan/utils/loading.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isLoadingFirst = true;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
  }

  initData() async {
    userModel =  await GlobalFunctions.getPersistence();

    isLoadingFirst = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingFirst ? Loading.circularLoading() : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profil/profile.jpg')
              )
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Hello",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userModel!.name.toString(),
                style: Theme.of(context).textTheme.displaySmall,
              )
            ],
          )
        ],
      ),
    );
  }
}