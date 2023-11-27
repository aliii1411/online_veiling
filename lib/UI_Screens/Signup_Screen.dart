import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_veiling/Posts/Posts_Screen.dart';
import 'package:online_veiling/UI_Screens/Login_Screen.dart';
import 'package:online_veiling/Utils/Utilities.dart';

import 'package:online_veiling/Widgets/Round_Button.dart';

class Signup_Screen extends StatefulWidget {
  const Signup_Screen({Key? key}) : super(key: key);

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {
  bool _obscuretext = true;

  void _toggle() {
    setState(() {
      _obscuretext = !_obscuretext;
    });
  }

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final nameController= TextEditingController();
  final emailController= TextEditingController();
  final contactController= TextEditingController();
  final passwordController= TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add user information to Firestore
  Future<void> addUserToFirestore( String name, String email) async {
    try {
      await _firestore.collection('Users').doc(email).set({
        'name': name,
        'email': email,
        // Add other fields if needed
      });
    } catch (e) {
      debugPrint('Error adding user to Firestore: $e');
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signup() async {
    setState(() {
      loading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString());

      // Update the user's display name
      await userCredential.user?.updateProfile(displayName: nameController.text);

      Utilities().toastMessage(userCredential.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => Post_Screen()));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      Utilities().toastMessage(e.message ?? 'Sign up failed');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ListView(
          physics: ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
          children: [
            SafeArea(
              child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Image(
                      image: AssetImage('assets/logo.png'),
                      height: 200,
                    ),
                    SizedBox(height: 50,),
                    Center(
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30,left: 30,right: 30),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: nameController,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Name',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10)),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10))),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10,left: 30,right: 30),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10))),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10,left: 30,right: 30),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: contactController,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Contact',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10))),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 60,),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: passwordController,
                                  obscureText: _obscuretext,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      suffixIcon: InkWell(
                                          onTap: _toggle,
                                          child: Icon(_obscuretext
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Theme.of(context).primaryColor),
                                          borderRadius: BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Theme.of(context).primaryColor),
                                          borderRadius: BorderRadius.circular(10))),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter your password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    RoundButton(title: 'Signup',
                      loading: loading,
                      onTap: (){
                      if(_formKey.currentState!.validate()){
                        signup();
                        addUserToFirestore(nameController.text, emailController.text);
                      }
                    },),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (Context) => Login_Screen()));
                            },
                            child: Text(
                              ' Login',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ]),
                  ],
                ),
                // ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}