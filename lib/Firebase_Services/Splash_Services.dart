import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_veiling/Posts/Posts_Screen.dart';
import 'package:online_veiling/UI_Screens/Regist_Screen.dart';

class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user!= null){
      Timer(const Duration(seconds: 3),
              ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Post_Screen()))
      );
    }else{
      Timer(const Duration(seconds: 3),
              ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Regist_Screen()))
      );
    }

  }
}