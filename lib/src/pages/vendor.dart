import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';
import 'package:lista_compras_app/src/pages/gasto.dart';
import 'package:lista_compras_app/src/pages/home.dart';
import 'package:lista_compras_app/src/pages/preco.dart';
import 'package:lista_compras_app/src/pages/profile.dart';

class Vendor extends StatefulWidget {
 

  @override
  _VendorState createState() => _VendorState();

}

class _VendorState extends State<Vendor> {

  int currentTab = 0;

  List<Widget> pages;
  Widget currentPage;

  HomePage homePage;
  PrecoPage precoPage;
  GastoPage gastoPage;
  ProfilePage profilePage;

  StreamSubscription _userSubscription;

  @override
  void initState() {
    homePage = HomePage();
    precoPage = PrecoPage();
    gastoPage = GastoPage();
    profilePage = ProfilePage();
    pages = [homePage, precoPage, gastoPage, profilePage];

    currentPage = homePage;
    
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, [bool showbottom = true]) {
    Internationalization.of(context);
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,            
            title: Text( 
              currentTab ==  0 
              ? 'Lista de Compras'
              : currentTab == 1
              ? 'Lista de Precos'
              : currentTab == 2
              ? 'Gastos Realizados' : 'Profile',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,       
          ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index){
            setState(() {
              currentTab = index;
              currentPage = pages[index];
            });
          },
          currentIndex: currentTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ThemeData().accentColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
              BottomNavigationBarItem(icon: Icon(Icons.attach_money), title: Text("Precos")),            
              BottomNavigationBarItem(icon: Icon(Icons.money_off), title: Text("Gastos")),
              BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("Profile")),
            ],
          ),
          body: currentPage,
        ),
      );
  }
  
}