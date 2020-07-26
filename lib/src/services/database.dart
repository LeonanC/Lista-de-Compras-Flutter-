import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  Future<void> addListaData(Map listaData, String listaId) async {
    await Firestore.instance.collection("Listas").document(listaId).setData(listaData).catchError((e){
      print(e.toString());
    });
  }

  Future<void> addItensData(Map itensData, String listaId) async {
    await Firestore.instance.collection("Listas").document(listaId).collection("Itens").add(itensData).catchError((e){
      print(e);
    });
  }

  getListaData() async {
    return await Firestore.instance.collection("Listas").snapshots();
  }

  getItensData(String listaId) async {
    return await Firestore.instance.collection("Listas").document(listaId).collection("Itens").getDocuments();
  }
  
}