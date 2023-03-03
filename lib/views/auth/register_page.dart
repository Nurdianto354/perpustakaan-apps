import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/auth_controller.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/views/auth/login_page.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool isHidden = true;

  late AuthController _authController;

  TextEditingController namaController = new TextEditingController(); 
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    _authController = new AuthController();
  }

  void setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  void register() async {
    if (namaController.text != "" && emailController.text != "" && passwordController.text != "" && passwordConfirmController.text != "") {
      _authController.register(context, setLoadingState, namaController.text, emailController.text, passwordController.text, passwordConfirmController.text, reset);
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
      namaController.text = "";
      emailController.text = "";
      passwordController.text = "";
      passwordConfirmController.text = "";
    });
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

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
                  child: Image.asset("assets/images/logo/logo.png"),
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
          inputStyle("Nama", namaController, false),
          inputStyle("Email", emailController, false),
          inputStyle("Password", passwordController, true),
          inputStyle("Password Confirm", passwordConfirmController, true),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 60,
            width: 270,
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: register,
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
            width: 270,
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
                  return const LoginPage();
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

  Widget inputStyle(String hinTxt, controllerName, bool status) {
    if (status == false) {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
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
                  controller: controllerName,
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
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
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
                  controller: controllerName,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(isHidden ? EvaIcons.eye : EvaIcons.eyeOff, color: AppTheme.textDark),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintText: hinTxt,
                  ),
                  obscureText: isHidden,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}