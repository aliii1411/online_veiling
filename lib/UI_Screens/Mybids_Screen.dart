import 'package:flutter/material.dart';

class Mybids_Screen extends StatefulWidget {
  const Mybids_Screen({super.key});

  @override
  State<Mybids_Screen> createState() => _Mybids_ScreenState();
}

class _Mybids_ScreenState extends State<Mybids_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My Bids'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 15),
            child: Container(

            ),
          ),
        ),
      ),
    );
  }
}
