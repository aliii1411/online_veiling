import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Check_out extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String authorName;
  final String price;

  const Check_out({
    required this.imageUrl,
    required this.title,
    required this.authorName,
    required this.price,
  });

  @override
  State<Check_out> createState() => _Check_outState();
}


class _Check_outState extends State<Check_out> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _bidAmountController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  void _submitBid(String bidAmount, String fullName, String contact) {
    FirebaseFirestore.instance.collection('Bids').add({
      'bidAmount': bidAmount,
      'fullName': fullName,
      'contact': contact,
    }).then((value) {
      // Handle success
      print('Bid added to Firestore');
    }).catchError((error) {
      // Handle error
      print('Error adding bid to Firestore: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Checkout'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 110,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  widget.imageUrl,
                                  width: 120,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 7),
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      'by',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      widget.authorName,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 13),
                                Row(
                                  children: [
                                    Text(
                                      'Orignal Price:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text(
                                      'Pkr',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      widget.price,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('Bid Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _bidAmountController,
                      decoration: InputDecoration(
                          suffixText: 'Pkr',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                          hintText: 'Amount',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10))),

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the item name';
                        }

                        // Convert the entered value to a double
                        double enteredAmount = double.tryParse(value) ?? 0;

                        // Convert widget.price to a double
                        double productPrice = double.tryParse(widget.price) ?? 0;

                        // Check if enteredAmount is greater than or equal to productPrice
                        if (enteredAmount < productPrice) {
                          return 'Bid amount must be equal or greater than the product price';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 15,),
                    Text('User Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _fullNameController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Full Name',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10))),

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the item name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _contactController,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Contact',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10))),

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the item name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 100,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        maximumSize: Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onSurface: Colors.transparent,
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Form is valid, submit the bid
                          _submitBid(
                            _bidAmountController.text,
                            _fullNameController.text,
                            _contactController.text,
                          );
                        }
                      },
                      child: Center(
                        child:
                        // loading
                        //     ? CircularProgressIndicator()
                        //     :
                        Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
