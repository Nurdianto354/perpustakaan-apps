import 'package:flutter/material.dart';
import 'package:perpustakaan/src/view/screen/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.elliptical(80, 80),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset("assets/logo/logo.png"),
                ),
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromARGB(255, 86, 134, 123),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          inputStyle("test@gmail.com"),
          inputStyle("abcD123"),
          inputStyle("abcD123"),
          inputStyle("Canada"),
          inputStyle("C-12333"),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
                  return const LoginScreen();
                }));
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputStyle(String hinTxt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 5, 20, 10),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10),
                  hintText: hinTxt,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}