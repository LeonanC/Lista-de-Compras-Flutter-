import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lista_compras_app/src/models/User.dart';
import 'package:lista_compras_app/src/services/firestore_services.dart';

class AuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  final FirestoreService _firestoreService = FirestoreService();

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  Future signInEmailAndPass(String _email, String _password) async {
    try{
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);      
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String _nome, String _telefone, String _email, String _password) async {

    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      FirebaseUser firebaseUser = authResult.user;
      var user = User(uid: authResult.user.uid, email: _email.trim(), nome: _nome.trim(), tel: _telefone.trim());
      await _firestoreService.addUser(user);
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {

    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}