import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:online_veiling/UI_Screens/Checkout_Screen.dart';
import 'package:online_veiling/Widgets/Round_Button.dart';

class Single_Pro extends StatefulWidget {
  final String productId;
  final String title;
  final String description;
  final String auctionTimeHr;
  final String auctionTimeMin;
  final String auctionTimeSec;
  final String price;
  final String imageUrl;
  final String itemEmail;

  const Single_Pro({
    required this.productId,
    required this.title,
    required this.description,
    required this.auctionTimeHr,
    required this.auctionTimeMin,
    required this.auctionTimeSec,
    required this.price,
    required this.imageUrl,
    required this.itemEmail,
  });

  @override
  State<Single_Pro> createState() => _Single_ProState();
}

class _Single_ProState extends State<Single_Pro> {

  var _userName;

  Future<String?> getUserName(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['name'];
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }


  int parseIntOrZero(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    print("Item Email: ${widget.itemEmail}");
    _fetchUserName();
  }


  void _fetchUserName() async {
    String? userName = await getUserName(widget.itemEmail);
    print("User Name: $userName");

    if (mounted) {
      setState(() {
        _userName = userName;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Single Products'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
            child: Column(
              children: [
                Container(
                  height: 500,
                  width: 361,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10,right: 10,left: 10),
                        child: Container(
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
                              widget.imageUrl,
                              width: 360,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              height: 70,
                              child: Text(
                                widget.description,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              "Product Information",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7,),
                            SizedBox(
                              height: 124,
                              width: 415,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Author',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${_userName}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          'Auction Ends in:',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        TimerCountdown(
                                          timeTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          enableDescriptions: false,
                                          format: CountDownTimerFormat.hoursMinutesSeconds,
                                          endTime: DateTime.now().add(
                                            Duration(
                                              hours: parseIntOrZero(widget.auctionTimeHr),
                                              minutes: parseIntOrZero(widget.auctionTimeMin),
                                              seconds: parseIntOrZero(widget.auctionTimeSec),
                                            ),
                                          ),
                                          onEnd: () {
                                            print("Bid Over");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No of Bids',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '20',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        widget.price,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Users bid where top bids will appear
                SizedBox(
                  height: 100,
                ),
                RoundButton(title: 'Checkout',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Check_out(
                          imageUrl: widget.imageUrl,
                          title: widget.title,
                          authorName: _userName ?? '', // Ensure _userName is not null
                          price: widget.price,
                          itemEmail: widget.itemEmail,
                          productId: widget.productId,
                          auctionTimeHr: widget.auctionTimeHr,
                          auctionTimeMin: widget.auctionTimeMin,
                          auctionTimeSec: widget.auctionTimeSec,
                        ),
                      ),
                    );
                  },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
