import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_veiling/UI_Screens/Splash_Screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xffFF9000),
          textTheme: const TextTheme(
          )
      ),
      debugShowCheckedModeBanner: false,
      home: Splash_Screen(),
    );
  }
}