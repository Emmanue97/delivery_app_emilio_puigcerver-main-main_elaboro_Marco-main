import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthService {
  // Obtener la instancia de firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener el usuario
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    // Try to sign user in
    try {
      // Sign user in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    // Obtener algun error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up
  Future<void> signUpWithEmailPassword(
      String email, password, String nombre) async {
    try {
      // Verificar si el usuario ya está en Firestore
      QuerySnapshot result = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        throw Exception("El correo electrónico escrito ya existe.");
      } else {
        // Crear el usuario en Firebase Auth
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;

        if (user != null) {
          // Obtener el Subscription ID de OneSignal
          var status = await OneSignal.shared.getDeviceState();
          String? subscriptionId = status?.userId;

          // Registrar el usuario en la colección "usuarios"
          await _firestore.collection('usuarios').doc(user.uid).set({
            'email': email,
            'id_miembro': subscriptionId,
            'nombre': nombre,
            'id_grupo': [], // Campo id_grupo como array vacío
            'metodos_pago': [], // Campo metodo_pago como array vacío
            'salario': 0, // Campo salario como entero, inicialmente 0
          });

          // Vincular el Subscription ID de OneSignal con el usuario
          if (subscriptionId != null) {
            OneSignal.shared.setExternalUserId(subscriptionId);
          }
        }
      }
    }
    // Obtener algún error
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("El correo electrónico escrito ya existe.");
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception("La cuenta ingresada ya existe");
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}




//modificado el 7 dic 2024 emiieuan
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {

//   //obtener la instancia de firebase auth
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   //obtener el usuario
//   User? getCurrentUser() {
//     return _firebaseAuth.currentUser;
//   }

//   //sign in
//   Future<UserCredential> signInWithEmailPassword(String email, password) async{
//     //try sign user in
//     try {
//       //sign user in
//       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password,);
//       return userCredential;
//     }
//     //obtener algun error
//     on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }

//   //sing up
//   Future<UserCredential> signUpWithEmailPassword(String email, password) async{
//     //try sign user up
//     try {
//       //sign user in
//       UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password,);
//       return userCredential;
//     }
//     //obtener algun error
//     on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }

//   //sing out
//   Future<void> signOut () async{
//     return await _firebaseAuth.signOut();
//   }
// }
