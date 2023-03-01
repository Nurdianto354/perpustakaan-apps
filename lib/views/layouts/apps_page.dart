import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:perpustakaan/controllers/auth_controller.dart';
import 'package:perpustakaan/controllers/theme_controller.dart';
import 'package:perpustakaan/utils/core/app_color.dart';
import 'package:perpustakaan/views/buku/buku_page.dart';
import 'package:perpustakaan/views/dashboard/dashboard_page.dart';
import 'package:perpustakaan/views/kategori/kategori_page.dart';
import 'package:perpustakaan/views/member/member_page.dart';
import 'package:perpustakaan/views/notifikasi/notifikasi_page.dart';
import 'package:perpustakaan/views/profil/header_drawer.dart';


final ThemeController controller = Get.put(ThemeController());

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  bool isLoading = false;
  late AuthController _authController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authController = new AuthController();
  }

  void loadingStateCallback() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  void logout() async {
    await _authController.logout(context, loadingStateCallback);
  }

  var currentPage = DrawerSections.dashboard_page;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget _appBar(BuildContext context) {
      return AppBar(
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Badge(
        //     badgeStyle: const BadgeStyle(badgeColor: LightThemeColor.accent),
        //     badgeContent: const Text(
        //       "2",
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     position: BadgePosition.topStart(start: -3),
        //     child: const Icon(Icons.notifications_none, size: 30),
        //   ),
        // ),
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

    var container;

    if (currentPage == DrawerSections.dashboard_page) {
      container = const DashboardPage();
    } else if (currentPage == DrawerSections.notifikasi_page) {
      container = const NotifikasiPage();
    } else if (currentPage == DrawerSections.kategori_page) {
      container = const KategoriPage();
    } else if (currentPage == DrawerSections.buku_page) {
      container = const BukuPage();
    } else if (currentPage == DrawerSections.member_page) {
      container = const MemberPage();
    }

    return Scaffold(
      appBar: _appBar(context),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const HeaderDrawer(),
                listDrawer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listDrawer() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined, currentPage == DrawerSections.dashboard_page ? true : false),
          menuItem(2, "Notifikasi", Icons.notifications_none_rounded, currentPage == DrawerSections.notifikasi_page ? true : false),
          menuItem(3, "Kategori", Icons.bookmark_border_outlined, currentPage == DrawerSections.kategori_page ? true : false),
          menuItem(4, "Buku", Icons.library_books, currentPage == DrawerSections.buku_page ? true : false),
          menuItem(5, "Member", Icons.people_alt_rounded, currentPage == DrawerSections.member_page ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard_page;
            } else if (id == 2) {
              currentPage = DrawerSections.notifikasi_page;
            } else if (id == 3) {
              currentPage = DrawerSections.kategori_page;
            } else if (id == 4) {
              currentPage = DrawerSections.buku_page;
            } else if (id == 5) {
              currentPage = DrawerSections.member_page;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard_page,
  notifikasi_page,
  kategori_page,
  buku_page,
  member_page,
}