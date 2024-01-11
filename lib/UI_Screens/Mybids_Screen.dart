import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mybids_Screen extends StatefulWidget {
  const Mybids_Screen({super.key});

  @override
  State<Mybids_Screen> createState() => _Mybids_ScreenState();
}

class _Mybids_ScreenState extends State<Mybids_Screen> {
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Bids')
              .where('Email', isEqualTo: currentUserEmail)  // Filter by current user's email
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var bids = snapshot.data!.docs;


            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bids.length,
                  itemBuilder: (context, index) {
                    var bid = bids[index];
                    var title = bid['title'];
                    var bidAmount = bid['bidAmount'];
                    var image = bid['image'];
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: ListTile(
                            visualDensity: VisualDensity(vertical: 4),
                            contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            title: Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24, fontWeight: FontWeight.bold),),
                            subtitle: Text('Bid Amount: $bidAmount',style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                            leading: Container(
                              width: 100,
                              height: 100,
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
                                child: image != null
                                    ? Image.network(image, fit: BoxFit.cover)
                                    : Placeholder(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
