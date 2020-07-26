import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras_app/src/models/Model.dart';
import 'package:lista_compras_app/src/pages/preco.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';

enum ListAction { edit, delete, clone }

class PrecoList extends StatefulWidget {
  final List<Map> items;
  final PrecoListBloc listaBloc;

  PrecoList({ this.items, this.listaBloc }) : super();
  @override
  _PrecoListState createState() => _PrecoListState();
}

class _PrecoListState extends State<PrecoList> {
  ModelLista listaBo = ModelLista();
  ModelPreco itemBo = ModelPreco();
  
  @override
  Widget build(BuildContext context) {

    if(widget.items.length == 0){
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pages),
            title: Text("Nenhum preco cadastrado ainda..."),
          ),
        ],
      );
    }

    DateFormat df = DateFormat('dd/MM/yy HH:mm'); 
    
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index){

        Map item = widget.items[index];

        DateTime created = DateTime.tryParse(item['criado']);

        return ListTile(
          leading: Icon(Icons.shopping_cart, size: 42, color: Style.secondary(0.6)),
          title: Text(item['nome']),
          subtitle: Text(item['valor']+' / ' +df.format(created)+')'),
          trailing: PopupMenuButton<ListAction>(
            onSelected: (ListAction result){
              switch(result){
                case ListAction.edit:
                  showEditDialog(context, item);
                break;
                case ListAction.delete:
                  itemBo.delete(item['pk_preco']).then((deleted){
                    if(deleted){
                      widget.listaBloc.getList();
                    }
                  });
                break;
                case ListAction.clone:
                  itemBo.insert({
                    'nome': item['nome']+ '(cópia)',
                    'valor': item['valor'],
                    'criado': DateTime.now().toString()
                  });
                break;
              }
            },
            itemBuilder: (BuildContext context){
              return <PopupMenuEntry<ListAction>>[
                PopupMenuItem<ListAction>(
                  value: ListAction.edit,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.edit, color: Style.secondary()),
                      Text('Editar', style: TextStyle(color: Style.secondary())),
                    ],
                  ),
                ),
                PopupMenuItem<ListAction>(
                  value: ListAction.delete,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete, color: Style.secondary()),
                      Text('Excluir', style: TextStyle(color: Style.secondary())),
                    ],
                  ),
                ),
                PopupMenuItem<ListAction>(
                  value: ListAction.clone,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.content_copy, color: Style.secondary()),
                      Text('Duplicar', style: TextStyle(color: Style.secondary())),
                    ],
                  ),
                ),
              ];
            },
          ),
        );
      },       
    );
  }
  void showEditDialog(BuildContext context, Map item){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx){

        TextEditingController _cEdit = TextEditingController();
        MoneyMaskedTextController _vEdit =MoneyMaskedTextController(
          thousandSeparator: '.',
          decimalSeparator: ',',
          leftSymbol: 'R\$ '
        );
        _cEdit.text = item['nome'];
        _vEdit.text = item['valor'];

        return AlertDialog(
          title: Text('Editar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _cEdit,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _vEdit,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Valor',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Style.dark(0.2),
              child: Text('Cancelar', style: TextStyle(color: Style.light())),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            ),
            RaisedButton(
              color: Style.primary(),
              child: Text('Salvar', style: TextStyle(color: Style.light())),
              onPressed: (){
                ModelPreco listaBo = ModelPreco();

                listaBo.update({
                  'nome': _cEdit.text,
                  'valor': _vEdit.text,
                  'criado': DateTime.now().toString()
                }, item['pk_preco']).then((saved){
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pushReplacementNamed(PrecoPage.tag);

                });
              },
            )
          ],
        );
      }
    );
  }
}