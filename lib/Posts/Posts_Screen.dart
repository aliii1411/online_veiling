import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_veiling/UI_Screens/Mypro_Screen.dart';
import 'package:online_veiling/UI_Screens/Regist_Screen.dart';
import 'package:online_veiling/Utils/Utilities.dart';

class Post_Screen extends StatefulWidget {
  const Post_Screen({super.key});

  @override
  State<Post_Screen> createState() => _Post_ScreenState();
}

class _Post_ScreenState extends State<Post_Screen> {
  final List<String> imagelist = [
    "assets/Banner.png",
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
            width: 330,
            child: ListView(
              children: [
                InkWell(
                  onTap: () {},
                  child: UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      foregroundImage: AssetImage('assets/profile.png'),
                    ),
                    accountName: Text(
                      "Muhammad Ali",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      "ali1234@gmail.com",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30))),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        ListTile(
                          minLeadingWidth: 10,
                          title: Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: ImageIcon(
                            AssetImage('assets/Home.png'),
                            color: Colors.black,
                            size: 25,
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          minLeadingWidth: 10,
                          leading: ImageIcon(
                            AssetImage('assets/Products.png'),
                            color: Colors.black,
                            size: 25,
                          ),
                          title: Text(
                            'All Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {

                          },
                        ),
                        ListTile(
                          minLeadingWidth: 10,
                          leading: ImageIcon(
                            AssetImage('assets/mypro.png'),
                            color: Colors.black,
                            size: 25,
                          ),
                          title: Text(
                            'My Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => My_products()));
                          },
                        ),
                        ListTile(
                          minLeadingWidth: 10,
                          leading: ImageIcon(
                            AssetImage('assets/History.png'),
                            color: Colors.black,
                            size: 25,
                          ),
                          title: Text(
                            'My Bids',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          minLeadingWidth: 10,
                          leading: ImageIcon(
                            AssetImage('assets/Tnc.png'),
                            color: Colors.black,
                            size: 25,
                          ),
                          title: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          minLeadingWidth: 10,
                          leading: ImageIcon(
                            AssetImage('assets/Hns.png'),
                            color: Colors.black,
                            size: 25,
                          ),
                          title: Text(
                            'Help and Support',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              left: 120,
                              top: 150,
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                auth.signOut().then((value) {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Regist_Screen()))
                                      .onError((error, stackTrace) {
                                    Utilities().toastMessage(error.toString());
                                  });
                                });
                              },
                              icon: ImageIcon(
                                AssetImage('assets/logout.png'),
                                color: Colors.black,
                                size: 25,
                              ),
                              label: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            )),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 60,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Home'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Popular Auctions',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'view all',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    CarouselSlider(
                                        items: imagelist
                                            .map((item) => Container(
                                                  child: Center(
                                                    child: Image.asset(item),
                                                  ),
                                                ))
                                            .toList(),
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          aspectRatio: 3.0,
                                          enlargeCenterPage: true,
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Last Auction',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'view all',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: Theme.of(context).primaryColor,
                                      size: 30,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 25),
                                height: 210,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
