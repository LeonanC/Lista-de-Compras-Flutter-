import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_compras_app/src/pages/signup.dart';

class Login extends StatefulWidget{
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  String email, password;
  bool isLoading = false;
  bool _isHidden = true;

  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Stack(
          children: <Widget>[
            Container(
              //     margin: EdgeInsets.only(top:h/15),
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
                    "Lista de ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'ChivelMind',
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Compras ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'ChivelMind',
                        fontWeight: FontWeight.w600,
                          ),
                  ),
                 
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:h/2),
              padding: EdgeInsets.all(5),
            
              alignment: Alignment.center,
              child: ListView(
              
                children: <Widget>[
                  TextField(
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: "Email",
                      labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(color: Colors.grey[450], fontWeight: FontWeight.w600),
                      prefixIcon: Icon(Icons.email),
                    ),
                    onChanged: (val){
                      email = val;
                    },
                  ),
                  SizedBox(height: 30),
                  TextField(
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      hintStyle: TextStyle(color: Colors.grey[450], fontWeight: FontWeight.w600),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    onChanged: (val){
                      password = val;
                    },
                  ),
                  
                        
              Container(
                margin: EdgeInsets.only(top:h/25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text("Sign in",style: TextStyle(color: Color(0xff854bb0),fontSize: 24,fontWeight: FontWeight.w500),),      
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
                          FirebaseAuth.instance
                          .signInWithEmailAndPassword(email: email, password: password)
                          .then((signedInUser){
                            Navigator.of(context).pushReplacementNamed('/vendor');
                          }).catchError((e){
                            print(e);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:h/20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: ()
                      {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return Signup();
                            },
                          ),
                        );
                      },
                      child: Text("Sign up",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,))),
                        Text("Forgot password",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,)),
                    
                  ],
                ),
              ),
                ],
              

                  
              )),
          ],
        ),
    ); 
  }  
}