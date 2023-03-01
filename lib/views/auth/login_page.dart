import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/controllers/auth_controller.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/utils/core/app_theme.dart';
import 'package:perpustakaan/utils/loading.dart';
import 'package:perpustakaan/utils/strings.dart';
import 'package:perpustakaan/views/auth/register_page.dart';
import 'package:perpustakaan/widgets/custom_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isHidden = true;

  UserModel? userModel;
  late AuthController _authController;

  TextEditingController emailController     = new TextEditingController();
  TextEditingController passwordController  = new TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _authController = new AuthController();
  }

  void login() async {
    if (emailController.text != "" && passwordController.text != "") {
      _authController.login(context, setLoadingState, emailController.text, passwordController.text, reset);
    } else {
      CustomDialog.getDialog(
        title: Strings.DIALOG_TITLE_WARNING,
        message: Strings.DIALOG_MESSAGE_INSUFFICENT_CREDENTIALS,
        context: context,
        popCount: 1
      );
    }
  }

  void setLoadingState() {
    setState(() {
      isLoading = isLoading ? isLoading = false : isLoading = true;
    });
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void reset() {
    setState(() {
      emailController.text = "";
      passwordController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: LayoutBuilder(builder: (_, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: isLoading ? Loading.circularLoading() : Column(
                children: [
                  Container(
                    height: 350,
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
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Image.asset("assets/images/logo/logo.png"),
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 35,
                            color: Color.fromARGB(255, 86, 134, 123),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
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
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(left: 10),
                                hintText: "Email",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
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
                              controller: passwordController,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(isHidden ? EvaIcons.eye : EvaIcons.eyeOff, color: AppTheme.textDark),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(left: 10),
                                hintText: "Password",
                              ),
                              obscureText: isHidden,
                            ),
                          ),
                        ),
                      ],
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
                      onPressed: login,
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account ? ",
                          style: TextStyle(fontSize: 15, color: Colors.grey[850])
                        ),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(fontSize: 15, color: Colors.orangeAccent[700]),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
                                return const RegisterPage();
                              }));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      ),
    );
  }
}