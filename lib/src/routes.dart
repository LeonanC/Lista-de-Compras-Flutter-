import 'package:flutter/material.dart';
import 'package:lista_compras_app/src/pages/gasto.dart';
import 'package:lista_compras_app/src/pages/home.dart';
import 'package:lista_compras_app/src/pages/items.dart';
import 'package:lista_compras_app/src/pages/login.dart';
import 'package:lista_compras_app/src/pages/preco.dart';
import 'package:lista_compras_app/src/pages/signup.dart';
import 'package:lista_compras_app/src/pages/vendor.dart';

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/addlista":
        return MaterialPageRoute(builder: (context) => AddLista());
      case "/addItem":
        return MaterialPageRoute(builder: (context) => AddItem());
      case "/addpreco":
        return MaterialPageRoute(builder: (context) => AddPreco());
      case "/addgasto":
        return MaterialPageRoute(builder: (context) => AddGasto());
      case "/items":
        return MaterialPageRoute(builder: (context) => ItemsPage());
      case "/edititem":
        return MaterialPageRoute(builder: (context) => ItemEdit());
      case "/gastos":
        return MaterialPageRoute(builder: (context) => GastoPage());
      case "/precos":
        return MaterialPageRoute(builder: (context) => PrecoPage());
      case "/signup":
        return MaterialPageRoute(builder: (context) => Signup());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/vendor":
        return MaterialPageRoute(builder: (context) => Vendor());
      
      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }
}