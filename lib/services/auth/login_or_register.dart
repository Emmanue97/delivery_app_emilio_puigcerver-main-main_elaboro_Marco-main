import 'package:delivery_app_emilio_puigcerver/pages/login_page.dart';
import 'package:delivery_app_emilio_puigcerver/pages/register_page.dart';
import 'package:flutter/material.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //este apartado siver para que  muestre inicialmente la página de ingreso a la app
  bool showLoginPage = true;

  //este apartado siver para alternar tanto en la página de inicio de sesión como en la de registro
  void togglePages () {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}