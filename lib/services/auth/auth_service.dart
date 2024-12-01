import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  //obtener la instancia de firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //obtener el usuario
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async{ 
    //try sign user in 
    try {
      //sign user in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password,);
      return userCredential;
    }
    //obtener algun error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sing up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async{ 
    //try sign user up
    try {
      //sign user in
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password,);
      return userCredential;
    }
    //obtener algun error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  //sing out
  Future<void> signOut () async{
    return await _firebaseAuth.signOut();
  }
}