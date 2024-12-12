import 'package:flutter/material.dart';
import 'package:delivery_app_emilio_puigcerver/componets/my_button.dart';
import 'package:delivery_app_emilio_puigcerver/componets/my_textfield.dart';
import 'package:delivery_app_emilio_puigcerver/pages/home_page.dart';
import 'package:delivery_app_emilio_puigcerver/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para los campos de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para iniciar sesión con Google
  void _signInWithGoogle() async {
    try {
      // Crear instancia de GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      // Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }

      // Obtener los tokens de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticación con Firebase usando los tokens de Google
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      // Si el usuario se autentica con éxito
      if (user != null) {
        // Obtener el Subscription ID de OneSignal
        var status = await OneSignal.shared.getDeviceState();
        String? subscriptionId = status?.userId;

        // Verificar si el usuario ya existe en la colección "usuarios"
        DocumentSnapshot userDoc =
            await _firestore.collection('usuarios').doc(user.uid).get();

        if (!userDoc.exists) {
          // Registrar el usuario en la colección "usuarios"
          await _firestore.collection('usuarios').doc(user.uid).set({
            'email': user.email,
            'id_miembro': subscriptionId,
            'nombre': user.displayName, // Nombre del usuario obtenido de Google
            'id_grupo': [], // Campo id_grupo como array vacío
            'metodos_pago': [], // Campo metodo_pago como array vacío
            'salario': 0, // Campo salario como entero, inicialmente 0
          });

          // Vincular el Subscription ID de OneSignal con el usuario
          if (subscriptionId != null) {
            OneSignal.shared.setExternalUserId(subscriptionId);
          }
        }

        // Navegar a la página principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage()), // Redirige a HomePage
        );
      }
    } catch (e) {
      // Mostrar un diálogo en caso de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  // Método para el inicio de sesión con correo y contraseña

  void login() async {
    final _authService = AuthService();

    // Validación de campos vacíos
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Campos vacíos'),
          content: Text(
              'Por favor, completa todos los campos antes de continuar.'),
        ),
      );
      return; // Detiene la ejecución si los campos están vacíos
    }

    try {
      // Intento de inicio de sesión
      await _authService.signInWithEmailPassword(
        emailController.text.trim(), // Elimina espacios innecesarios
        passwordController.text.trim(),
      );

      // Navegación a la página principal en caso de éxito
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage()), // Redirige a HomePage
      );
    } catch (e) {
      // Manejo de errores en caso de credenciales incorrectas
      String errorMessage;

      if (e.toString().contains('invalid-credential')) {
        errorMessage =
            'El email o contraseña son incorrectas.';
      } else {
        errorMessage = 'Ocurrió un error inesperado. Intenta nuevamente.';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No se pudo iniciar sesión'),
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de inicio de sesión
            Icon(
              Icons.monetization_on_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),
            // Mensaje debajo del logo
            Text(
              "App - Control de Gastos",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 25),
            // Campo de texto para el email
            MyTextfield(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // Campo de texto para la contraseña
            MyTextfield(
              controller: passwordController,
              hintText: "Contraseña",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            // Botón de inicio de sesión
            MyButton(
              text: "Ingresar",
              onTap: login,
            ),
            const SizedBox(height: 25),
            // Botón de inicio de sesión con Google
            MyButton(
              text: "Iniciar sesión con Google",
              onTap: _signInWithGoogle, // Llama al método de Google Sign-In
            ),
            const SizedBox(height: 25),
            // Registro de nuevos usuarios
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "¿Aún no eres miembro?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterPage(onTap: widget.onTap)),
                    );
                  },
                  child: Text(
                    "¡Regístrate ahora!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Modificado el 10 de dic 2024
// import 'package:flutter/material.dart';
// import 'package:delivery_app_emilio_puigcerver/componets/my_button.dart';
// import 'package:delivery_app_emilio_puigcerver/componets/my_textfield.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/home_page.dart';
// import 'package:delivery_app_emilio_puigcerver/services/auth/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'register_page.dart';

// class LoginPage extends StatefulWidget {
//   final void Function()? onTap;

//   const LoginPage({super.key, required this.onTap});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // Controladores para los campos de texto
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Método para iniciar sesión con Google
//   void _signInWithGoogle() async {
//     try {
//       // Crear instancia de GoogleSignIn con la opción para forzar la selección de cuenta
//       final GoogleSignIn googleSignIn = GoogleSignIn(
//         scopes: ['email'], // Solicitar permisos de correo electrónico
//       );

//       // Iniciar sesión con Google
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser == null) {
//         // El usuario canceló el inicio de sesión
//         return;
//       }

//       // Obtener los tokens de autenticación
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Autenticación con Firebase usando los tokens de Google
//       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       final user = userCredential.user;

//       // Si el usuario se autentica con éxito, navegar a la página principal
//       if (user != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()), // Redirige a HomePage
//         );
//       }
//     } catch (e) {
//       // Si ocurre un error, mostrar un diálogo
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }

//   // Método para el inicio de sesión con correo y contraseña
//   void login() async {
//     final _authService = AuthService();

//     try {
//       await _authService.signInWithEmailPassword(emailController.text, passwordController.text);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()), // Redirige a HomePage
//       );
//     } catch (e) {
//       // Si ocurre un error en el inicio de sesión con correo y contraseña
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icono de inicio de sesión
//             Icon(
//               Icons.monetization_on_outlined,
//               size: 100,
//               color: Theme.of(context).colorScheme.inversePrimary,
//             ),
//             const SizedBox(height: 25),
//             // Mensaje debajo del logo
//             Text(
//               "App - Control de Gastos",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Theme.of(context).colorScheme.inversePrimary,
//               ),
//             ),
//             const SizedBox(height: 25),
//             // Campo de texto para el email
//             MyTextfield(
//               controller: emailController,
//               hintText: "Email",
//               obscureText: false,
//             ),
//             const SizedBox(height: 10),
//             // Campo de texto para la contraseña
//             MyTextfield(
//               controller: passwordController,
//               hintText: "Contraseña",
//               obscureText: true,
//             ),
//             const SizedBox(height: 10),
//             // Botón de inicio de sesión
//             MyButton(
//               text: "Ingresar",
//               onTap: login,
//             ),
//             const SizedBox(height: 25),
//             // Botón de inicio de sesión con Google
//             MyButton(
//               text: "Iniciar sesión con Google",
//               onTap: _signInWithGoogle, // Llama al método de Google Sign-In
//             ),
//             const SizedBox(height: 25),
//             // Registro de nuevos usuarios
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "¿Aún no eres miembro?",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.inversePrimary,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegisterPage(onTap: widget.onTap)),
//                     );
//                   },
//                   child: Text(
//                     "¡Regístrate ahora!",
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.inversePrimary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
