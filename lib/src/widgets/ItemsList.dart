import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lista_compras_app/application.dart';
import 'package:lista_compras_app/src/models/Model.dart';
import 'package:lista_compras_app/src/utils/widgets.dart';
import 'package:lista_compras_app/src/pages/items.dart';

class ItemsList extends StatefulWidget {
  final List<Map> items;
  final String filter;
  final ItemsListBloc itemsListBloc;

  const ItemsList({Key key, this.items, this.filter, this.itemsListBloc}) : super(key: key);
  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  GlobalKey<ScaffoldState> explosePageScaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    if(widget.items.isEmpty){
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text('Nenhum item para exibir ainda'),
          ),
        ],
      );
    }

    List<Map> filteredList = List<Map>();

    if(widget.filter.isNotEmpty){
      for(dynamic item in widget.items){
        String name = item['nome'].toString().toLowerCase();
        if(name.contains(widget.filter.toLowerCase())){
          filteredList.add(item);
        }
      }
    }else{
      filteredList.addAll(widget.items);
    }

    if(filteredList.isEmpty){
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text('Nenhum item encontrado...'),
          ),
        ],
      );
    }

    ModelItem itemBo = ModelItem();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredList.length,
      itemBuilder: (BuildContext context, int i){

        Map item = filteredList[i];

        String itemUnit = unity.keys.first;
        unity.forEach((nome, precision){
          if(precision == item['precisao']){
            itemUnit = nome;
          }
        });

        double realVal = currencyToDouble(item['valor']);
        String valTotal = doubleToCurrency(realVal * item['quantidade']);

        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          closeOnScroll: true,
          child: ListTile(
            leading: GestureDetector(
              child: Icon(
                ((item['checked'] == 1) ? Icons.check_box : Icons.check_box_outline_blank),
                color: ((item['checked'] == 0) ? Colors.grey : Colors.red),
                size: 42,
              ),
              onTap: (){
                itemBo.update({'checked': !(item['checked'] == 1)}, item['pk_item']).then((bool updated){
                  if(updated){
                    widget.itemsListBloc.getList();
                  }
                });
              },
            ),
            title: Text(item['nome']),
            subtitle: Text('${item['quantidade']} $itemUnit X ${item['valor']} = $valTotal'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              itemBo.getItem(item['pk_item']).then((Map i){
                ItemEdit.item = i;

                Navigator.of(context).pushNamed('/edititem');
              });
            },
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Deletar',
              icon: Icons.delete,
              color: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: Text('Tem certeza?'),
                      content: Text('Esta ação irá remover o item selecionado e não poderá ser desfeita'),
                      actions: <Widget>[
                        RaisedButton(
                          color: Style.secondary(),
                          child: Text('Cancelar', style: TextStyle(color: Style.light())),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        RaisedButton(
                          color: Style.danger(),
                          child: Text('Remover', style: TextStyle(color: Style.light())),
                          onPressed: () {
                            itemBo.delete(item['pk_item']);
                            

                            Navigator.of(ctx).pop();
                            widget.itemsListBloc.getList();
                            
                          }
                        )
                      ],
                    );
                  }
                );
              },
            )
          ],
        );
      },
    );
  }
}