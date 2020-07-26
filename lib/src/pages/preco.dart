import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lista_compras_app/application.dart';
import 'package:lista_compras_app/src/models/Model.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';
import 'package:lista_compras_app/src/widgets/PrecoList.dart';

class PrecoPage extends StatefulWidget {
  static String tag = 'preco-page';
  @override
  _PrecoPageState createState() => _PrecoPageState();
}

class _PrecoPageState extends State<PrecoPage> {
  final PrecoListBloc listaBloc = PrecoListBloc();

  @override
  void dispose() {
    listaBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.red,
        onPressed: () => Navigator.of(context).pushNamed('/addpreco'),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map>>(
        stream: listaBloc.lists,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: Text('Carregando...'));
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                return PrecoList(
                  items: snapshot.data,
                  listaBloc: this.listaBloc
                );
              }
          }
        }      
      ),
    );
  }
}

class AddPreco extends StatefulWidget {
  @override
  _AddPrecoState createState() => _AddPrecoState();
}

class _AddPrecoState extends State<AddPreco> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _cName = TextEditingController();
  MoneyMaskedTextController _cValor = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
  );
  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Adicionar Preco', style: TextStyles.subtitle),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: BaseStyles.listPadding,
            child: Divider(color: AppColors.darkblue),
          ),
          Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: <Widget>[
                SizedBox(height: 10),
                Text('Nome do item'),
                TextField(
                  controller: _cName,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Valor'),
                TextFormField(
                  controller: _cValor,
                  autofocus: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Valor R\$',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  validator: (value) {
                    if (currencyToDouble(value) < 0.0) {
                      return 'Obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
              ],
            ),
          ), 
          AppButton(
            buttonText: 'Salvar Preço',
            onPressed: (){
              if (_formKey.currentState.validate()) {

                // Instancia model
                ModelPreco precoBo = ModelPreco();

                // Adiciona no banco de dados
                precoBo.insert({
                  'nome': _cName.text,
                  'valor': _cValor.text,
                  'criado': DateTime.now().toString()
                }).then((saved) {
                  EasyLoading.showSuccess('Preço Inserido com Sucesso!');
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/vendor');
                });
              }
            },
          ),
            
        ],
      ),
    );
  }

}

class PrecoListBloc {

  PrecoListBloc() {
    getList();
  }

  ModelPreco listaBo = ModelPreco();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await listaBo.list());
  }
}