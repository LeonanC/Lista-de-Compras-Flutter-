import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_compras_app/src/models/User.dart';

class FirestoreService {
  Firestore _db = Firestore.instance;

  Future<void> addUser(User user){
    return _db.collection('usuarios').document(user.uid).setData(user.toMap());
  }

  Future<User> fetchUser(String userId){
    return _db.collection('usuarios').document(userId).get().then((snapshot) => User.fromFirestore(snapshot.data));
  }

  Future<void> storeNewUser(user, context) {
    return _db.collection('usuarios').document(user.uid).setData(user.toMap()).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/vendor');
    }).catchError((e) {
      print(e);
    });
  }
}