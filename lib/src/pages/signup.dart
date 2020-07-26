import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_compras_app/src/pages/login.dart';
import 'package:lista_compras_app/src/services/firestore_services.dart';

class Signup extends StatefulWidget{
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String nome;
  String telefone;
  String email;
  String password;
  
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Stack(
          children: <Widget>[
            Container(
              height: h/1.2,
              width: w,
              child: RotatedBox(
                quarterTurns: 0,
                child: FlareActor(
                  'assets/images/curve.flr',
                  animation: 'Flow',
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.fill,
                  // isPaused: x,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: w / 4, left: w / 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Registro de ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Usuarios ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                          ),
                  ),
                 
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Spacer(),
                  TextFormField(
                    validator: (val){ return val.isEmpty ? "Enter Nome " : null; },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: "Nome",
                      labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(color: Colors.grey[450], fontWeight: FontWeight.w600),
                    ),
                    onChanged: (val){
                      nome = val;
                    },
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val){ return val.isEmpty ? "Enter Telefone " : null; },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: "Telefone",
                      labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(color: Colors.grey[450], fontWeight: FontWeight.w600),
                    ),
                    onChanged: (val){
                      telefone = val;
                    },
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val){ return val.isEmpty ? "Enter Email " : null; },
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: "Email",
                      labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(color: Colors.grey[450], fontWeight: FontWeight.w600),
                    ),
                    onChanged: (val){
                      email = val;
                    },
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val){ return val.isEmpty ? "Enter Password " : null; },
                    obscureText: true,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: "Password",
                      labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(color: Colors.grey[450], fontWeight: FontWeight.w600),
                    ),
                    onChanged: (val){
                      password = val;
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(top:h/25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Registrar",style: TextStyle(color: Color(0xff854bb0),fontSize: 24,fontWeight: FontWeight.w500),),      
                        Container(                
                          height: h / 12,
                          width: h / 12,
                          
                          child: RaisedButton(
                            color: Color(0xff854bb0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                            ),
                            elevation: 3,
                            child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
                            onPressed: () {
                              FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email, password: password
                              ).then((signedInUser) {
                                Navigator.of(context).pushReplacementNamed('/vendor');
                                FirestoreService().storeNewUser(signedInUser, context);
                              }).catchError((e){
                                print(e);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Já Possui uma Conta? ", style: TextStyle(fontSize: 15.5)),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text("Login ", style: TextStyle(fontSize: 15.5, decoration: TextDecoration.underline))),
                    ],
                  ),
                  SizedBox(height: 80),

                ],
              ),
            ),
          ],      
        ),
    );
  }
}
