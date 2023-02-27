import 'dart:convert';
import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:perpustakaan/core/app_color.dart';
import 'package:perpustakaan/core/app_data.dart';
import 'package:perpustakaan/core/app_extension.dart';
import 'package:perpustakaan/src/controller/login_controller.dart';
import 'package:perpustakaan/src/controller/theme_controller.dart';
import 'package:perpustakaan/src/model/user_model.dart';
import 'package:perpustakaan/utils/global_function.dart';

final AppThemeController controller = Get.put(AppThemeController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  late LoginController _loginController;
  UserModel? _userModel;
  Map _userLogin = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loginController = new LoginController();
    initData();
  }

  void loadingStateCallback() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  initData() async {
    _userModel = await GlobalFunctions.getPersistence();

    loadingStateCallback();

    Map _userLogin = new Map();

    _userLogin['name'] = _userModel!.name;
    _userLogin['roles'] = _userModel!.role;

    loadingStateCallback();
  }

  void logout() async {
    await _loginController.logout(context, loadingStateCallback);
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Badge(
          badgeStyle: const BadgeStyle(badgeColor: LightThemeColor.accent),
          badgeContent: const Text(
            "2",
            style: TextStyle(color: Colors.white),
          ),
          position: BadgePosition.topStart(start: -3),
          child: const Icon(Icons.notifications_none, size: 30),
        ),
      ),
      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.signOut),
          onPressed: () {
            setState(() {
              logout();
            });
          },
        ),
      ],
    );
  }

  Widget _searchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search food',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Morning, " + _userModel!.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ).fadeAnimation(0.2),
              Text(
                "What do you want to eat \ntoday",
                style: Theme.of(context).textTheme.displayLarge,
              ).fadeAnimation(0.4),
              _searchBar(),
              Text(
                "Available for you",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentBottomNavItemIndex.value,
          onTap: controller.switchBetweenBottomNavigationItems,
          selectedFontSize: 0,
          items: AppData.bottomNavigationItems.map(
            (element) {
              return BottomNavigationBarItem(
                icon: element.disableIcon,
                label: element.label,
                activeIcon: element.enableIcon,
              );
            },
          ).toList(),
        );
      }),
    );
  }
}