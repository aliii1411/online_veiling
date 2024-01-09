import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Check_out extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final String authorName;
  final String price;
  final String itemEmail;

  const Check_out({
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.authorName,
    required this.price,
    required this.itemEmail,
  });

  @override
  State<Check_out> createState() => _Check_outState();
}


class _Check_outState extends State<Check_out> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _bidAmountController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  void _submitBid(String bidAmount, String fullName, String contact, String address,) {
    FirebaseFirestore.instance.collection('Bids').add({
      'itemEmail': widget.itemEmail,
      'productId': widget.productId,
      'image' :widget.imageUrl,
      'title' : widget.title,
      'price' : widget.price,
      'bidAmount': bidAmount,
      'fullName': fullName,
      'contact': contact,
      'address': address,
    }).then((value) {
      // Handle success
      print('Bid added to Firestore with productId: ${widget.productId}');
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
                                SizedBox(height: 7),
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
                          suffixText: 'PKR',
                          suffixStyle: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600,fontSize: 16),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                          hintText: 'Amount',
                          hintStyle: TextStyle(color: Colors.grey,),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10))),

                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the item name';
                        }
                        double enteredAmount = double.tryParse(value) ?? 0;
                        double productPrice = double.tryParse(widget.price) ?? 0;
                        if (enteredAmount < productPrice) {
                          return 'Amount must be equal or greater than the product price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15,),
                    Text('Shipping Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Shipping Address',
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
                        onPrimary: Colors.white,
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Form is valid, submit the bid
                          _submitBid(
                            _bidAmountController.text,
                            _fullNameController.text,
                            _contactController.text,
                            _addressController.text,

                          );
                          _bidAmountController.clear();
                          _fullNameController.clear();
                          _contactController.clear();
                          _addressController.clear();

                          // Navigate back to the home screen
                          Navigator.pop(context);
                        }
                      },
                      child: Center(
                        child:
                        Text('Place Bid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
