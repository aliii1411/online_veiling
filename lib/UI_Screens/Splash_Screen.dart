import 'package:flutter/material.dart';
import 'package:online_veiling/Firebase_Services/Splash_Services.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  SplashServices Splash_Screen= SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Splash_Screen.isLogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
              ),
              Image(
                image: AssetImage('assets/logo.png'),
                height: 220,
              ),
              SizedBox(
                height: 15,
              ),

            ],
          ),
        ));
  }
}