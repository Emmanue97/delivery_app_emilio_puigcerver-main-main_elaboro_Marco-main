import 'package:delivery_app_emilio_puigcerver/firebase_options.dart';
import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';
import 'package:delivery_app_emilio_puigcerver/providers/group_provider.dart';
import 'package:delivery_app_emilio_puigcerver/themes/theme_provider.dart';
import 'package:delivery_app_emilio_puigcerver/pages/login_page.dart';
import 'package:delivery_app_emilio_puigcerver/pages/register_page.dart';
import 'package:delivery_app_emilio_puigcerver/pages/home_page.dart';
import 'package:delivery_app_emilio_puigcerver/pages/onboarding_page.dart'; //  onboarding
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:delivery_app_emilio_puigcerver/pages/create_group_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Restaurant()), // Manda la información para que se muestre en la página (separa los apartados)
        ChangeNotifierProvider(create: (context) => GroupProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(), // Cambiamos el inicio al onboarding
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/login': (context) => const LoginPage(onTap: null), // Define la ruta para LoginPage
        '/register': (context) => const RegisterPage(onTap: null), // Define la ruta para RegisterPage
        '/home': (context) => const HomePage(), // Define la ruta para HomePage
        '/onboarding': (context) => const OnboardingPage(), // Nueva ruta para el onboarding
        '/create_group': (context) => CreateGroupPage(),
      },
    );
  }
}





