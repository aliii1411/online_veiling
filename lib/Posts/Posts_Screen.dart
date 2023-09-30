import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_veiling/UI_Screens/Regist_Screen.dart';
import 'package:online_veiling/Utils/Utilities.dart';

class Post_Screen extends StatefulWidget {
  const Post_Screen({super.key});

  @override
  State<Post_Screen> createState() => _Post_ScreenState();
}

class _Post_ScreenState extends State<Post_Screen> {

  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        //key: _scaffoldKey,
        //drawer: Drawer(),
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,top: 10),
                    child: IconButton(
                      onPressed: () {
                        auth.signOut().then((value){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Regist_Screen()))
                              .onError((error, stackTrace){
                            Utilities().toastMessage(error.toString());
                          });
                        });
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
