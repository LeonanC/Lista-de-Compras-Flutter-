import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lista_compras_app/application.dart';
import 'package:lista_compras_app/src/models/Model.dart';
import 'package:lista_compras_app/src/utils/QuantityFormatter.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';
import 'package:lista_compras_app/src/widgets/ItemsList.dart';

class ItemsPage extends StatefulWidget {
  static String tag = 'item-page';

  static int pkList;
  static String nameList;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

int total = 0;

class _ItemsPageState extends State<ItemsPage> {

  String filterText = "";
  
  final ItemsListBloc itemsListBloc = ItemsListBloc();

  @override
  void dispose() {
    itemsListBloc.dispose();
    super.dispose();
  }

  

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Lista: '+ItemsPage.nameList, style: TextStyle(
          fontSize: 20,
        )),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Pesquisar',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onChanged: (text){
                      filterText = text;
                    },
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Style.secondary(),
                    onPressed: (){

                      Navigator.of(context).pushNamed('/addItem');
                    },
                    child: Icon(Icons.add),
                  ),   
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map>>(
              stream: itemsListBloc.lists,
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
                      return ItemsList(
                        items: snapshot.data,
                        filter: filterText,
                        itemsListBloc: this.itemsListBloc,
                      );
                    }
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Style.secondary(0.2),
                  Style.dark(0.4),
                ]
              ),
            ),
          height: 80,
          child: StreamBuilder<List<Map>>(
            stream: itemsListBloc.lists,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: Loading());
                  break;
                default:
                  if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  }else{
                    List<Map> items = snapshot.data;
                    int qtdTotal = items.length;
                    int qtdChecked = 0;
                    double subTotal = 0.0;
                    double vlrTotal = 0.0;

                    for(Map item in items){
                      double vlr = currencyToFloat(item['valor']) * item['quantidade'];
                      subTotal += vlr;

                      if(item['checked'] == 1){
                        qtdChecked++;
                        vlrTotal += vlr;
                      }
                    }

                    bool isClosed = (subTotal == vlrTotal);
                    
                    return Row(
                      children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/2,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  Text('Items'),
                                  Text(qtdTotal.toString(), textScaleFactor: 1.2),
                                ]),
                                Column(children: <Widget>[
                                  Text('Carrinho'),
                                  Text(qtdChecked.toString(), textScaleFactor: 1.2)
                                ]),
                                Column(children: <Widget>[
                                  Text('Faltando'),
                                  Text((qtdTotal - qtdChecked).toString(), textScaleFactor: 1.2)
                                ]),
                              ],
                            ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Sub: ' + doubleToCurrency(subTotal), style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                              SizedBox(height: 5),  
                              Text('Total: ' + doubleToCurrency(vlrTotal), style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isClosed ? Colors.red : Colors.blueAccent,
                              ))
                          ],
                        ),
                      )
                    ]);
                  }
                // End switch default option
              }
            },
          )
          )
        ],
      ),
    );
  }
}

class AddItem extends StatefulWidget {
  
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  
  final  formKey = GlobalKey<FormState>();
  TextEditingController cNome = TextEditingController();
  TextEditingController cQtd = TextEditingController(text: '1');
  MoneyMaskedTextController cValor = MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
  );

  String selectedUnit = unity.keys.first;
  bool isSelected = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Adicionar Item', style: TextStyles.subtitle),
      ),
      body: pageBody(context),
    );
  }

  Widget pageBody(BuildContext context){
    return _isLoading ? Container(
      child: Center(
        child: Loading()
      ),
    ) : Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: <Widget>[
            SizedBox(height: 10),
            Text('Nome do item'),
            TextFormField(
              controller: cNome,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nome do item',
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
            SizedBox(height: 10),
            Text('Quantidade'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: TextFormField(
                    controller: cQtd,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Quantidade',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                    inputFormatters: [ new QuantityFormatter(precision: unity[this.selectedUnit]) ],
                    validator: (value) {

                      double valueAsDouble = (double.tryParse(value) ?? 0.0);

                      if (valueAsDouble <= 0) {
                        return 'Informe um número positivo';
                      }
                      return null;
                    },
                  ),
                ),
                Container(width: 100, child: DropdownButton<String>(
                  value: this.selectedUnit,
                  onChanged: (String newValue) {
                    setState(() {

                      double valueAsDouble = (double.tryParse(cQtd.text) ?? 0.0);
                      cQtd.text = valueAsDouble.toStringAsFixed(unity[newValue]);

                      this.selectedUnit = newValue;
                    });
                  },
                  items: unity.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value)
                    );
                  }).toList()
                )),
              ]
            ),
            SizedBox(height: 10),
            Text('Valor'),
            TextFormField(
              controller: cValor,
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  activeColor: Style.primary(),
                  onChanged: (bool value) {
                    setState(() {
                      this.isSelected = value;
                    });
                  },
                  value: this.isSelected,
                ),
                GestureDetector(
                  child: Text('Já está no carrinho?', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    setState(() {
                      this.isSelected = !this.isSelected;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text('Cancelar'),
                  padding: EdgeInsets.only(left: 50, right: 50),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: Style.primary(),
                  child: Text("Inserir Item", style: TextStyle(color: Style.light())),
                  padding: EdgeInsets.only(left: 50, right: 50),
                  onPressed: () {
                      if(formKey.currentState.validate()){

                        setState(() {
                          _isLoading = true;
                        });

                        ModelItem itemBo = ModelItem();
                        itemBo.insert({
                          'fk_lista': ItemsPage.pkList,
                          'nome': cNome.text,
                          'quantidade': cQtd.text,
                          'precisao': unity[this.selectedUnit],
                          'valor': cValor.text,
                          'checked': this.isSelected,
                          'criado': DateTime.now().toString()
                        }).then((saved){
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/items');
                        });
                      }
                    },
                  ),
              ]),
          ],
        ),
    );
  }
}
            
class ItemEdit extends StatefulWidget {
  static String tag = 'item-edit';
  static Map item;
  @override
  _ItemEditState createState() => _ItemEditState();
}

class _ItemEditState extends State<ItemEdit> {
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cQtd = TextEditingController();
  final MoneyMaskedTextController _cValor =MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
  );

  String selectedUnit;
  bool isSelected;

  @override
  void initState() {
    
    _cName.text = ItemEdit.item['nome'];
    _cQtd.text = ItemEdit.item['quantidade'].toString();
    _cValor.text = ItemEdit.item['valor'];
    this.isSelected = (ItemEdit.item['checked'] == 1);

    unity.forEach((name, precision) {
      if (precision == ItemEdit.item['precisao']) {
        this.selectedUnit = name;
      }
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    // Instancia model
    ModelItem itemBo = ModelItem();

    final inputName = TextFormField(
      controller: _cName,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Nome do item',
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
    );

    final inputQuantidade = TextFormField(
      controller: _cQtd,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Quantidade',
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5)
        )
      ),
      inputFormatters: [ new QuantityFormatter(precision: unity[this.selectedUnit]) ],
      validator: (value) {

        double valueAsDouble = (double.tryParse(value) ?? 0.0);

        if (valueAsDouble <= 0) {
          return 'Informe um número positivo';
        }
        return null;
      },
    );

    final inputUnit = DropdownButton<String>(
      value: this.selectedUnit,
      onChanged: (String newValue) {
        setState(() {

          double valueAsDouble = (double.tryParse(_cQtd.text) ?? 0.0);
          _cQtd.text = valueAsDouble.toStringAsFixed(unity[newValue]);

          this.selectedUnit = newValue;
        });
      },
      items: unity.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value)
        );
      }).toList()
    );

    final inputValor = TextFormField(
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
    );

    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Editar: '"+ItemEdit.item['nome'].toString()+"'", style: TextStyle(fontSize: 30)),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              SizedBox(height: 10),
              Text('Nome do item'),
              inputName,
              SizedBox(height: 10),
              Text('Quantidade'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 150,
                    child: inputQuantidade,
                  ),
                  Container(width: 100, child: inputUnit)
                ]
              ),
              SizedBox(height: 10),
              Text('Valor'),
              inputValor,
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    activeColor: Style.primary(),
                    onChanged: (bool value) {
                      setState(() {
                        this.isSelected = value;
                      });
                    },
                    value: this.isSelected,
                  ),
                  GestureDetector(
                    child: Text('Já está no carrinho?', style: TextStyle(fontSize: 18)),
                    onTap: () {
                      setState(() {
                        this.isSelected = !this.isSelected;
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text('Cancelar', style:TextStyle(color: Style.light())),
                  padding: EdgeInsets.only(left: 50, right: 50),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  color: Style.primary(),
                  child: Text('Salvar', style:TextStyle(color: Style.light())),
                  padding: EdgeInsets.only(left: 50, right: 50),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {

                      // Adiciona no banco de dados
                      itemBo.update(
                        {
                          'fk_lista': ItemsPage.pkList,
                          'nome': _cName.text,
                          'quantidade': _cQtd.text,
                          'precisao': unity[this.selectedUnit],
                          'valor': _cValor.text,
                          'checked': this.isSelected,
                          'criado': DateTime.now().toString()
                        },
                        ItemEdit.item['pk_item']
                      ).then((saved) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/items');
                      });
                    }
                  },
                )
              ])
            ]
          ),
        )
      ),
    );
  }
} 
    
  


class ItemsListBloc {

  ItemsListBloc() {
    getList();
  }

  ModelItem itemBo = ModelItem();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await itemBo.itemsByList(ItemsPage.pkList));
  }
}