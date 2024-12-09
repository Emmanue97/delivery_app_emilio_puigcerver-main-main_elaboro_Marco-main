import 'package:delivery_app_emilio_puigcerver/pages/expense_balance_page.dart';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class PremiumFeatureScreen extends StatefulWidget {
   final String groupId; // Parámetro recibido

  const PremiumFeatureScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  _PremiumFeatureScreenState createState() => _PremiumFeatureScreenState();
}

class _PremiumFeatureScreenState extends State<PremiumFeatureScreen> {
  bool isAdReady = false;

  void loadAd() {
    UnityAds.load(
      placementId: 'Rewarded_Android', // El ID de tu anuncio
      onComplete: (placementId) {
        print('Ad Loaded: $placementId');
        setState(() {
          isAdReady = true;
        });
      },
      onFailed: (placementId, error, message) {
        print('Ad Failed to Load: $placementId, $error, $message');
        setState(() {
          isAdReady = false;
        });
      },
    );
  }

  void showAd() {
    // UnityAds.showVideoAd(
    //   placementId: 'Rewarded_Android',
    //   onStart: (placementId) => print('Ad Started: $placementId'),
    //   onClick: (placementId) => print('Ad Clicked: $placementId'),
    //   onSkipped: (placementId) => print('Ad Skipped: $placementId'),
    //   onComplete: (placementId) {
    //     print('Ad Completed: $placementId');
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ExpenseBalancePage(groupId: widget.groupId),
    //       ),
    //     );
    //   },
    //   onFailed: (placementId, error, message) => print('Ad Failed: $placementId, $error, $message'),
    // );
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseBalancePage(groupId: widget.groupId),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              "Esta es una función premium.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Ve un anuncio para desbloquear esta función.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                loadAd();
                if (isAdReady) {
                  showAd();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El anuncio no está listo todavía. Intenta nuevamente.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo del botón
                foregroundColor: Colors.white, // Color del texto
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Estilo del texto
              ),
              child: const Text("Ver Anuncio"),
            ),
          ],
        ),
      ),
    );
  }
}



//Modificado el 8 de diciembre 2024 emiieuan
// import 'package:delivery_app_emilio_puigcerver/pages/expense_balance_page.dart';
// import 'package:flutter/material.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

// class PremiumFeatureScreen extends StatefulWidget {
//    final String groupId; // Parámetro recibido

//   const PremiumFeatureScreen(ExpenseBalancePage expenseBalancePage, {Key? key, required this.groupId}) : super(key: key);

//   @override
//   _PremiumFeatureScreenState createState() => _PremiumFeatureScreenState();
// }

// class _PremiumFeatureScreenState extends State<PremiumFeatureScreen> {
//   bool isAdReady = false;

//   @override
//   void initState() {
//     super.initState();
//     // Cargar el anuncio al iniciar la pantalla
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.lock,
//               size: 100,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Esta es una función premium.",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Ve un anuncio para desbloquear esta función.",
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: (){
//                 UnityAds.showVideoAd(
//                   placementId: 'Rewarded_Android',
//                   onStart: (placementId) => print('Ad Started: $placementId'),
//                   onClick: (placementId) => print('Ad Clicked: $placementId'),
//                   onSkipped: (placementId) => print('Ad Skipped: $placementId'),
//                   onComplete: (placementId) {
//                     Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ExpenseBalancePage(groupId: widget.groupId),
//                           ),
//                         );
//                   },
//                   onFailed: (placementId, error, message) =>
//                       print('Ad Failed: $placementId, $error, $message'),
//                 );
//               }, // Siempre intenta mostrar el anuncio
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue, // Color de fondo del botón
//                 foregroundColor: Colors.white, // Color del texto
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10), // Bordes redondeados
//                 ),
//                 textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Estilo del texto
//               ),
//               child: const Text("Ver Anuncio"),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }
