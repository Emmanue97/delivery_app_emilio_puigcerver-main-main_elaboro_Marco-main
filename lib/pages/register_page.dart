// import 'package:delivery_app_emilio_puigcerver/componets/my_button.dart';
// import 'package:delivery_app_emilio_puigcerver/componets/my_textfield.dart';
// import 'package:delivery_app_emilio_puigcerver/services/auth/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'login_page.dart';

// class RegisterPage extends StatefulWidget {
//   final void Function()? onTap;

//   const RegisterPage({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   //metodo de registro
//   void register() async {
//     // Obtener el servicio de autenticación
//     final _authService = AuthService();

//     // Verificar que las contraseñas coincidan
//     if (passwordController.text == confirmPasswordController.text) {
//       try {
//         // Intentar crear el usuario
//         await _authService.signUpWithEmailPassword(emailController.text, passwordController.text);
//         Navigator.pushReplacementNamed(context, '/home');
//       } catch (e) {
//         // Pantalla que muestra los errores
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text(e.toString()),
//           ),
//         );
//       }
//     } else {
//       // Si las contraseñas no coinciden, mostrar error
//       showDialog(
//         context: context,
//         builder: (context) => const AlertDialog(
//           title: Text("Las contraseñas no coinciden"),
//         ),
//       );
//     }
//   }

//   //esta es la parte de la página principal
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //logo
//             Icon(
//               Icons.lock_open_rounded,
//               size: 100,
//               color: Theme.of(context).colorScheme.inversePrimary,
//             ),
//             const SizedBox(height: 25),
//             // texto donde se ve la creación de una nueva cuenta
//             Text(
//               "Generar una cuenta para ti <3",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Theme.of(context).colorScheme.inversePrimary,
//               ),
//             ),
//             const SizedBox(height: 25,),
//             // email textfield
//             MyTextfield(
//               controller: emailController,
//               hintText: "Email",
//               obscureText: false,
//             ),
//             const SizedBox(height: 10),
//             //password textfield
//             MyTextfield(
//               controller: passwordController,
//               hintText: "contraseña",
//               obscureText: true,
//             ),
//             const SizedBox(height: 10),
//             //confirmar de nuevo la contraseña password textfield
//             MyTextfield(
//               controller: confirmPasswordController,
//               hintText: "confirmar contraseña",
//               obscureText: true,
//             ),
//             const SizedBox(height: 10),
//             //sign up button es para registrarte como nuevo usuario
//             MyButton(
//               text: "Unirte",
//               onTap: register,
//             ),
//             const SizedBox(height: 25),
//             // aparatado de donde si ya tienes una cuenta poder ingresar a la página principal
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "¿Tienes una cuenta?",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.inversePrimary,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginPage(onTap: widget.onTap)),
//                     );
//                   },
//                   child: Text(
//                     "¡Ingresa ahora!",
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
import 'package:delivery_app_emilio_puigcerver/componets/my_button.dart';
import 'package:delivery_app_emilio_puigcerver/componets/my_textfield.dart';
import 'package:delivery_app_emilio_puigcerver/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // Método de registro
  void register() async {
    // Obtener el servicio de autenticación
    final _authService = AuthService();

    // Verificar que las contraseñas coincidan
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // Intentar crear el usuario
        await _authService.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
          nameController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Mostrar el mensaje de error al usuario
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      // Si las contraseñas no coinciden, mostrar error
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Las contraseñas no coinciden"),
        ),
      );
    }
  }

  // Esta es la parte de la página principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),
            // Texto de creación de nueva cuenta
            Text(
              "Generar una cuenta para ti <3",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Email textfield
            MyTextfield(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // Nombre textfield
            MyTextfield(
              controller: nameController,
              hintText: "Nombre",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // Password textfield
            MyTextfield(
              controller: passwordController,
              hintText: "Contraseña",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            // Confirmar contraseña textfield
            MyTextfield(
              controller: confirmPasswordController,
              hintText: "Confirmar contraseña",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            // Sign up button para registrarse
            MyButton(
              text: "Unirte",
              onTap: register,
            ),
            const SizedBox(height: 25),
            // Apartado para usuarios que ya tienen una cuenta
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "¿Tienes una cuenta?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(onTap: widget.onTap)),
                    );
                  },
                  child: Text(
                    "¡Ingresa ahora!",
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
