import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:online_veiling/UI_Screens/All_Pro.dart';
import 'package:online_veiling/UI_Screens/Mypro_Screen.dart';
import 'package:online_veiling/UI_Screens/Regist_Screen.dart';
import 'package:online_veiling/UI_Screens/Single_Pro.dart';
import 'package:online_veiling/Utils/Utilities.dart';

class Post_Screen extends StatefulWidget {
  const Post_Screen({super.key});

  @override
  State<Post_Screen> createState() => _Post_ScreenState();
}

class _Post_ScreenState extends State<Post_Screen> {

  CollectionReference _referenceupload_products = FirebaseFirestore.instance.collection('products');
  late Stream<QuerySnapshot> _streamupload_products;
  List<Map> items = [];
  int parseIntOrZero(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0; // Return 0 if parsing fails
    }
  }

  final List<String> imagelist = [
    "assets/Banner.png",
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _streamupload_products=_referenceupload_products.snapshots();
    _fetchCurrentUser();
  }

  void _fetchCurrentUser() async {
    User? currentUser = auth.currentUser;
    await currentUser?.reload(); // Reload the user data
    currentUser = auth.currentUser; // Get the updated user data

    setState(() {
      _user = currentUser;
    });
  }

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
                    currentAccountPicture: ProfilePicture(
                      name: _user?.displayName ?? "User Name",
                      radius: 0,
                      fontsize: 26,
                      //random: true,
                    ),
                    accountName: Text(
                      _user?.displayName ?? "User Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      _user?.email ?? "user@example.com",
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
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25, right: 25),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       'Popular Auctions',
                                    //       style: TextStyle(
                                    //           fontSize: 20,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     Text(
                                    //       'view all',
                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: CarouselSlider(
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
                                  )),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Popular Auction',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (Context) => All_Pro()));
                                      },
                                      child: Text(
                                        'view all',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: TextFormField(
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
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 500,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _streamupload_products,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Some error occurred ${snapshot.error}'));
                                  }

                                  if (snapshot.connectionState == ConnectionState.active) {
                                    QuerySnapshot querySnapshot = snapshot.data;
                                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                                    // Convert the documents to Maps and update the class-level 'items' list.
                                    items = documents.map((e) => {
                                      'id': e.id,
                                      'title': e['title'],
                                      'price': e['price'],
                                      'image': e['image'],
                                      'description' : e['description'],
                                      'time in hours': e['time in hours'],
                                      'time in minutes': e['time in minutes'],
                                      'time in seconds': e['time in seconds'],
                                      'userEmail': e['userEmail'],

                                    }).toList();
                                  }
                                  return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                    itemCount: items.length> 6 ? 6 : items.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      Map thisItem = items[index];
                                      return ListTile(
                                        minVerticalPadding: 10,
                                        dense: true,
                                        title: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 175,
                                                height: 110,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.3),
                                                      blurRadius: 7,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '${thisItem['image']}',
                                                    fit: BoxFit.cover,
                                                    height: 110,
                                                    width: 175,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                '${thisItem['title']}',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                              ),
                                              SizedBox(height: 5),
                                              TimerCountdown(
                                                enableDescriptions: false,
                                                format: CountDownTimerFormat.hoursMinutesSeconds,
                                                endTime: DateTime.now().add(
                                                  Duration(
                                                    hours: parseIntOrZero( '${thisItem['time in hours']}'),
                                                    minutes: parseIntOrZero( '${thisItem['time in minutes']}'),
                                                    seconds: parseIntOrZero( '${thisItem['time in seconds']}'),
                                                  ),
                                                ),
                                                onEnd: () {
                                                  print("Bid Over");
                                                },
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Pkr ',style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),),
                                                  Text(
                                                    '${thisItem['price']}',
                                                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                                  ),
                                                  SizedBox(width: 24),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) => Single_Pro(
                                                              productId: '${thisItem['id']}',
                                                              title: '${thisItem['title']}',
                                                              description: '${thisItem['description']}',
                                                              auctionTimeHr: '${thisItem['time in hours']}',
                                                              auctionTimeMin: '${thisItem['time in minutes']}',
                                                              auctionTimeSec: '${thisItem['time in seconds']}',
                                                              price: '${thisItem['price']}',
                                                              itemEmail: '${thisItem['userEmail']}',
                                                              imageUrl: '${thisItem['image']}'
                                                          )));
                                                    },
                                                    child: Container(
                                                      height: 30,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xffFF9000),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Bid Now",
                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
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
