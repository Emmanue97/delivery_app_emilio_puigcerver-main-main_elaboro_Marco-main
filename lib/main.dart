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
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

// Intento de implementacion falta agregar reglas de envio
// import 'package:onesignal_flutter/onesignal_flutter.dart'; //notificaciones
// import 'package:workmanager/workmanager.dart';

// // Función que se ejecutará en segundo plano
// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case "tareaPeriodicaOneSignal":
//         await _enviarNotificacionOneSignal('Título de la notificación',
//             'Este es el contenido de la notificación periódica', "");
//         break;
//     }
//     return Future.value(true);
//   });
// }



// // Configuración inicial de OneSignal
// Future<void> _inicializarOneSignal() async {
//   // Reemplaza "TU-APP-ID" con tu ID de OneSignal
//   OneSignal.shared.setAppId("cfff0b1f-6268-454c-8218-7db471934533");
// // Agregar esto después de setAppId
//   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

// // También puedes obtener el ID del jugador para verificar
//   final status = await OneSignal.shared.getDeviceState();
//   final String? osUserID = status?.userId;
//   print("OneSignal User ID: $osUserID");

//   // Habilitar notificaciones en el dispositivo
//   await OneSignal.shared.promptUserForPushNotificationPermission();

//   // Manejar notificaciones recibidas
//   OneSignal.shared.setNotificationWillShowInForegroundHandler(
//       (OSNotificationReceivedEvent event) {
//     // Personalizar el manejo de notificaciones en primer plano
//     event.complete(event.notification);
//   });

//   // Manejar cuando el usuario toca una notificación
//   OneSignal.shared
//       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//     // Manejar la acción cuando se toca la notificación
//     print("Notificación tocada: ${result.notification.title}");
//   });
// }

// // Función para enviar notificaciones con OneSignal
// Future<void> _enviarNotificacionOneSignal(
//     String titulo, String mensaje, String? idMiembro) async {
//   try {
//     // Enviar notificación con datos adicionales
//     await NotificationService.sendNotification(
//       title: titulo,
//       content: mensaje,
//       userId: idMiembro,
//       additionalData: {
//         'tipo': 'notificacion_periodica',
//         'timestamp': DateTime.now().toString(),
//       },
//     );
//     print("Notificación enviada exitosamente");
//   } catch (e) {
//     print("Error al enviar notificación: $e");
//   }
// }


// Future<void> Verificar_fecha_tarjeta() async {
//   try {
//     // Lógica para verificar los pagos próximos
//     var paymentsSnapshot =
//         await FirebaseFirestore.instance.collection('metodos_pago').get();

//     // Aquí recorremos todos los métodos de pago
//     for (var payment in paymentsSnapshot.docs) {
//       String userId =
//           payment['user_id']; // Obtenemos el user_id del método de pago
//       bool isCreditCard =
//           payment['is_credit_card']; // Verificamos si es tarjeta de crédito
//       DateTime? paymentDueDate =
//           payment['payment_due_date']?.toDate(); // Fecha de pago
//       DateTime? paymentLimitDate =
//           payment['payment_limit_date']?.toDate(); // Fecha límite de pago

//       // Verificamos si es tarjeta de crédito y si alguna fecha está próxima
//       if (isCreditCard) {
//         if ((paymentDueDate != null &&
//                 paymentDueDate
//                     .isBefore(DateTime.now().add(Duration(days: 3)))) ||
//             (paymentLimitDate != null &&
//                 paymentLimitDate
//                     .isBefore(DateTime.now().add(Duration(days: 3))))) {
//           // Consultar el id_miembro en la colección usuarios
//           var userSnapshot = await FirebaseFirestore.instance
//               .collection('usuarios')
//               .doc(userId)
//               .get();
//           String memberId = userSnapshot[
//               'id_miembro']; // Obtener el id_miembro para la notificación

//           // Convertir las fechas a la zona horaria local
//           DateTime localPaymentDueDate =
//               paymentDueDate?.toLocal() ?? DateTime.now();
//           DateTime localPaymentLimitDate =
//               paymentLimitDate?.toLocal() ?? DateTime.now();

//           // Formatear las fechas
//           String formattedPaymentDueDate =
//               "${localPaymentDueDate.day} de ${localPaymentDueDate.month} de ${localPaymentDueDate.year}, ${localPaymentDueDate.hour}:${localPaymentDueDate.minute}";
//           String formattedPaymentLimitDate =
//               "${localPaymentLimitDate.day} de ${localPaymentLimitDate.month} de ${localPaymentLimitDate.year}, ${localPaymentLimitDate.hour}:${localPaymentLimitDate.minute}";

//           // Determinar cuál fecha usar, si la de vencimiento o la de límite de pago
//           String notificationDate = formattedPaymentDueDate != null
//               ? formattedPaymentDueDate
//               : formattedPaymentLimitDate;

//           // Enviar notificación utilizando la función del servicio de notificación
//           _enviarNotificacionOneSignal(
//               "Pagar tarjeta de credito", "mensaje", memberId);
//         }
//       }
//     }
//     return Future.value(true); // Task completada
//   } catch (e) {
//     print('Error al verificar los pagos: $e');
//     return Future.value(false); // Task fallida
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // // Inicializar OneSignal
  // await _inicializarOneSignal();

  // // Inicializar WorkManager
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // // Registrar tarea periódica
  // await Workmanager().registerPeriodicTask(
  //   "tareaOneSignal1", //id unico
  //   "tareaPeriodicaOneSignal", //nombre de la tarea
  //   frequency: const Duration(minutes: 15),
  //   initialDelay: const Duration(seconds: 10),
  //   constraints: Constraints(
  //     networkType: NetworkType.connected,
  //   ),
  //   existingWorkPolicy: ExistingWorkPolicy.keep,
  //   // Puedes pasar datos a la tarea
  //   inputData: {
  //     'tipo': 'actualizacion_periodica',
  //   },
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                Restaurant()), // Manda la información para que se muestre en la página (separa los apartados)
        ChangeNotifierProvider(create: (context) => GroupProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // Inicializar Unity Ads después de runApp
  await UnityAds.init(
    gameId: '5742820', // Reemplaza con tu Game ID
    testMode: true, // Activar modo de prueba
  );

  UnityAds.load(
    placementId: 'Rewarded_Android',
    onComplete: (placementId) => print('Ad Loaded: $placementId'),
    onFailed: (placementId, error, message) =>
        print('Ad Failed to Load: $placementId, $error, $message'),
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
        '/login': (context) =>
            const LoginPage(onTap: null), // Define la ruta para LoginPage
        '/register': (context) =>
            const RegisterPage(onTap: null), // Define la ruta para RegisterPage
        '/home': (context) => const HomePage(), // Define la ruta para HomePage
        '/onboarding': (context) =>
            const OnboardingPage(), // Nueva ruta para el onboarding
        '/create_group': (context) => CreateGroupPage(),
      },
    );
  }
}



//modificado 7 dic 2024
// import 'package:delivery_app_emilio_puigcerver/firebase_options.dart';
// import 'package:delivery_app_emilio_puigcerver/models/restaurant.dart';
// import 'package:delivery_app_emilio_puigcerver/providers/group_provider.dart';
// import 'package:delivery_app_emilio_puigcerver/themes/theme_provider.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/login_page.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/register_page.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/home_page.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/onboarding_page.dart'; //  onboarding
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:delivery_app_emilio_puigcerver/pages/create_group_page.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart'; //notificaciones


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//   OneSignal.initialize("cfff0b1f-6268-454c-8218-7db471934533");
//   // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.Notifications.requestPermission(true);
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
//         ChangeNotifierProvider(create: (context) => Restaurant()), // Manda la información para que se muestre en la página (separa los apartados)
//         ChangeNotifierProvider(create: (context) => GroupProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
//   // Inicializar Unity Ads después de runApp
//   await UnityAds.init(
//     gameId: '5742820', // Reemplaza con tu Game ID
//     testMode: true, // Activar modo de prueba
//   );
//   UnityAds.load(
//       placementId: 'Rewarded_Android',
//       onComplete: (placementId) => print('Ad Loaded: $placementId'),
//       onFailed: (placementId, error, message) =>
//           print('Ad Failed to Load: $placementId, $error, $message'),
//     );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const OnboardingPage(), // Cambiamos el inicio al onboarding
//       theme: Provider.of<ThemeProvider>(context).themeData,
//       routes: {
//         '/login': (context) => const LoginPage(onTap: null), // Define la ruta para LoginPage
//         '/register': (context) => const RegisterPage(onTap: null), // Define la ruta para RegisterPage
//         '/home': (context) => const HomePage(), // Define la ruta para HomePage
//         '/onboarding': (context) => const OnboardingPage(), // Nueva ruta para el onboarding
//         '/create_group': (context) => CreateGroupPage(),
//       },
//     );
//   }
// }





