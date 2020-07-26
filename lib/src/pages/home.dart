import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_compras_app/src/models/Model.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';
import 'package:lista_compras_app/src/widgets/HomeList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeListBloc listaBloc = HomeListBloc();

  @override
  void dispose() {
    listaBloc.dispose();
    super.dispose();
  }
  Widget lista(){
    return Container(
      child: StreamBuilder<List<Map>>(
        stream: listaBloc.lists,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: Loading());
              break;
            default:
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }else{
                return HomeList(
                  items: snapshot.data,
                  listaBloc: this.listaBloc,
                );
              }
          }          
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lista(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.straw,
        onPressed: (){
          Navigator.of(context).pushNamed('/addlista');
        },
        child: Icon(Icons.add),
      ),
    );
  }

}

class AddLista extends StatefulWidget {
  final String listaId;

  AddLista({this.listaId});

  @override
  _AddListaState createState() => _AddListaState();
}

class _AddListaState extends State<AddLista> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController cNome = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Adicionar Lista', style: TextStyles.subtitle),
      ),
      body: _isLoading ? Container(
        child: Center(
          child: Loading(),
        ),
      ) : Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              Padding(
                padding: BaseStyles.listPadding,
                child: Divider(color: AppColors.darkblue),
              ),
              SizedBox(height: 10),
              Text('Nome do lista'),
              SizedBox(height: 10),
                TextFormField(
                  controller: cNome,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nome da lista',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                AppButton(
                  buttonType: ButtonType.DarkBlue,
                  buttonText: 'Salvar Lista',
                  onPressed: (){
                    if (_formKey.currentState.validate()) {

                      setState(() {
                        _isLoading = true;
                      });

                      ModelLista listaBo = ModelLista();
                      
                      listaBo.insert({
                        'nome': cNome.text,
                        'criado': DateTime.now().toString()
                      }).then((saved) {
                        
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/vendor');
                      });
                    }
                  },
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
    );
  }

}


class HomeListBloc {

  HomeListBloc() {
    getList();
  }

  ModelLista listaBo = ModelLista();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await listaBo.list());
  }
}