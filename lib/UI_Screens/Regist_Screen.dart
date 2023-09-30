import 'package:flutter/material.dart';
import 'package:online_veiling/UI_Screens/Login_Screen.dart';
import 'package:online_veiling/UI_Screens/Signup_Screen.dart';
import 'package:online_veiling/Widgets/Round_Button.dart';

class Regist_Screen extends StatefulWidget {
  const Regist_Screen({Key? key}) : super(key: key);

  @override
  State<Regist_Screen> createState() => _Regist_ScreenState();
}
class _Regist_ScreenState extends State<Regist_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 70,),
                Image(
                  image: AssetImage('assets/logo.png'),
                  height: 200,
                ),
                SizedBox(
                  height: 350,
                ),
                RoundButton(title: 'Login', onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (Context) => Login_Screen()));},),
                SizedBox(
                  height: 15,
                ),
                RoundButton(title: 'Signup', onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (Context) => Signup_Screen()));},),
              ],
            ),
          ),
        ));
  }
}