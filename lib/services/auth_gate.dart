import 'package:delivery_app_emilio_puigcerver/pages/home_page.dart';
import 'package:delivery_app_emilio_puigcerver/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
       builder: (context, snapshot) {
        //usuario registrado
        if (snapshot.hasData) {
          return const HomePage();
        }
        //usuario no registrado
        else {
          return const LoginOrRegister();
        }
       },
       ),
    );
  }
}