import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras_app/src/models/Model.dart';
import 'package:lista_compras_app/src/pages/home.dart';
import 'package:lista_compras_app/src/pages/items.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';

enum ListAction { edit, delete, clone }

class HomeList extends StatefulWidget {
  
  final List<Map> items;
  final HomeListBloc listaBloc;

  const HomeList({Key key, this.items, this.listaBloc}) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  ModelLista listaBo = ModelLista();
  ModelItem itemBo = ModelItem();
  GlobalKey<ScaffoldState> _explosePageScaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {

    if(widget.items.length == 0){
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pages),
            title: Text("Nenhuma lista cadastrada ainda..."),
          ),
        ],
      );
    }

    DateFormat df = DateFormat('dd/MM/yy HH:mm'); 
    
    return Scaffold(
      key: _explosePageScaffoldKey,
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index){
          Map item = widget.items[index];

          DateTime created = DateTime.tryParse(item['criado']);

          return ListTile(
            leading: Icon(Icons.shopping_cart, size: 42, color: Style.secondary(0.6)),
            title: Text(item['nome']),
            subtitle: Text('('+item['qtdItems'].toString()+' itens) - '+df.format(created)),
            trailing: PopupMenuButton<ListAction>(
              onSelected: (ListAction result){
                switch(result){
                  case ListAction.edit:
                    showEditDialog(context, item);
                  break;
                  case ListAction.delete:
                     // First of all we delete all items from this list
                    itemBo.deleteAllFromList(item['pk_lista']).then((int rowsDeleted) {
                      
                      // Then delete the list itself
                      listaBo.delete(item['pk_lista']).then((deleted) {
                        if (deleted) {
                          widget.listaBloc.getList();
                        }
                      });
                    });
                  break;
                  case ListAction.clone:
                    listaBo.insert({
                      'nome': item['nome']+' (cópia)',
                      'criado': DateTime.now().toString()
                    }).then((int newId) {

                      itemBo.itemsByList(item['pk_lista']).then((List<Map> listItems) async {

                        for (Map listItem in listItems) {
                          await itemBo.insert({
                            'fk_lista': newId,
                            'nome': listItem['nome'],
                            'quantidade': listItem['quantidade'],
                            'valor': listItem['valor'],
                            'checked': 0,
                            'criado': DateTime.now().toString()
                          });
                        }

                        widget.listaBloc.getList();
                      });
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
            onTap: () {  
              ItemsPage.pkList = item['pk_lista'];
              ItemsPage.nameList = item['nome'];

              Navigator.of(context).pushNamed('/items');
            },
          ); 
        },
      ),
    );
  }

  void showEditDialog(BuildContext context, Map item) {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {

        TextEditingController _cEdit = TextEditingController();
        _cEdit.text = item['nome'];

        final input = TextFormField(
          controller: _cEdit,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nome',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
        );

        return AlertDialog(
          title: Text('Editar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                input
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Style.dark(0.2),
              child: Text('Cancelar', style: TextStyle(color: Style.light())),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            RaisedButton(
              color: Style.primary(),
              child: Text('Salvar', style: TextStyle(color: Style.light())),
              onPressed: () {
                ModelLista listaBo = ModelLista();

                listaBo.update({
                  'nome': _cEdit.text,
                  'criado': DateTime.now().toString()
                }, item['pk_lista']).then((saved) {

                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pushReplacementNamed('/vendor');

                });
              },
            )
          ],
        );

      }
    );
  }
}