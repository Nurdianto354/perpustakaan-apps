import 'package:flutter/material.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20.0),
      color: Colors.tealAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profil/profile.jpg')
              )
            ),
          ),
          Text(
            "Rapid Tech",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Text(
            "info@rapidtech.dev",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
