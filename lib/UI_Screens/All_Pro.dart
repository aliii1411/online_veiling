import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:online_veiling/UI_Screens/Single_Pro.dart';

class All_Pro extends StatefulWidget {
  const All_Pro({super.key});

  @override
  State<All_Pro> createState() => _All_ProState();
}

class _All_ProState extends State<All_Pro> {

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
  void initState() {
    super.initState();
    _streamupload_products=_referenceupload_products.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('All Products'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              'userEmail':e['userEmail'],

            }).toList();
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: items.length,
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
                          Text('Pkr',style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),),
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
                                      imageUrl: '${thisItem['image']}',
                                      itemEmail:'${thisItem['userEmail']}',

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
    );
  }
}
