import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Edit_Mypro extends StatefulWidget {
  final String productId;
  final String title;
  final String description;
  final String auctionTimeHr;
  final String auctionTimeMin;
  final String auctionTimeSec;
  final String price;
  final String imageUrl;

  const Edit_Mypro({
    required this.productId,
    required this.title,
    required this.description,
    required this.auctionTimeHr,
    required this.auctionTimeMin,
    required this.auctionTimeSec,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<Edit_Mypro> createState() => _Edit_MyproState();
}

class _Edit_MyproState extends State<Edit_Mypro> {
  final CollectionReference _productReference =
  FirebaseFirestore.instance.collection('products');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _auctionTimeHrController;
  late TextEditingController _auctionTimeMinController;
  late TextEditingController _auctionTimeSecController;
  late TextEditingController _priceController;


  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _auctionTimeHrController = TextEditingController(text: widget.auctionTimeHr);
    _auctionTimeMinController = TextEditingController(text: widget.auctionTimeMin);
    _auctionTimeSecController = TextEditingController(text: widget.auctionTimeSec);
    _priceController = TextEditingController(text: widget.price);
  }

  Future<String> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
      FirebaseStorage.instance.ref().child('product_images/$fileName');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _updateProduct() async {
    try {
      if (_formKey.currentState!.validate()) {
        String imageUrl = widget.imageUrl;
          if(selectedImage!=null){
            imageUrl = await uploadImage(selectedImage!);
          }


        await _productReference.doc(widget.productId).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'time in hours': _auctionTimeHrController.text,
          'time in minutes': _auctionTimeMinController.text,
          'time in seconds': _auctionTimeSecController.text,
          'price': _priceController.text,
          'image': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product Updated succssfully!"),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> _deleteProduct() async {
    try {
      await _productReference.doc(widget.productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error deleting product: $e');
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: Icon(Icons.arrow_back_ios_new_rounded),
        title: Text('Edit Products'),
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
                  Center(
                    child: InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                        print('${file?.path}');

                        if (file == null) return;

                        selectedImage = File(file.path);
                        // Update the image immediately after it's picked
                        setState(() {});
                      },
                      child: Container(
                        width: 160,
                        height: 140,
                        decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: selectedImage != null
                              ? Image.file(
                            selectedImage!,
                            width: 160,
                            height: 140,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            widget.imageUrl,
                            width: 160,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 25,),
                  Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _titleController,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Enter the name of the product',
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
                  SizedBox(height: 15,),
                  Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Enter the product description',
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
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Product description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 195,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text('Auction time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    controller: _auctionTimeHrController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'hrs',
                                        fillColor: Colors.white,
                                        filled: true,
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

                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                      LengthLimitingTextInputFormatter(2), // Limit input to 2 characters
                                    ],

                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Select Hours';
                                      }
                                      if (value.length != 2) {
                                        return 'Please enter a 2-digit number';
                                      }
                                      int firstDigit = int.tryParse(value[0]) ?? 0;
                                      int secondDigit = int.tryParse(value[1]) ?? 0;
                                      if (firstDigit > 5 || secondDigit < 0 || secondDigit > 9) {
                                        return 'Please enter a valid hours value (1st digit <= 5, 2nd digit 0-9)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                SizedBox(
                                  width: 51,
                                  child: TextFormField(
                                    controller: _auctionTimeMinController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'min',
                                        fillColor: Colors.white,
                                        filled: true,
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

                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                      LengthLimitingTextInputFormatter(2), // Limit input to 2 characters
                                    ],

                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Minutes ';
                                      }
                                      if (value.length != 2) {
                                        return 'Please enter a 2-digit number';
                                      }
                                      int firstDigit = int.tryParse(value[0]) ?? 0;
                                      int secondDigit = int.tryParse(value[1]) ?? 0;
                                      if (firstDigit > 5 || secondDigit < 0 || secondDigit > 9) {
                                        return 'Please enter a valid Minutes value (1st digit <= 5, 2nd digit 0-9)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10,),
                                SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    controller: _auctionTimeSecController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'sec',
                                        fillColor: Colors.white,
                                        filled: true,
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

                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                      LengthLimitingTextInputFormatter(2), // Limit input to 2 characters
                                    ],
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Seconds';
                                      }
                                      if (value.length != 2) {
                                        return 'Please enter a 2-digit number';
                                      }
                                      int firstDigit = int.tryParse(value[0]) ?? 0;
                                      int secondDigit = int.tryParse(value[1]) ?? 0;
                                      if (firstDigit > 5 || secondDigit < 0 || secondDigit > 9) {
                                        return 'Please enter a valid Seconds value (1st digit <= 5, 2nd digit 0-9)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 155,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Orignal Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            SizedBox(height: 5,),
                            TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Price",
                                  fillColor: Colors.white,
                                  filled: true,
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

                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the item price';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(170, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onSurface: Colors.transparent,
                            primary: Theme.of(context).primaryColor,
                          ),
                          onPressed: _updateProduct,
                          icon: Icon(
                            Icons.save,
                            size: 24,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(170, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onSurface: Colors.transparent,
                            primary: Theme.of(context).primaryColor,
                          ),
                          onPressed: _deleteProduct,
                          icon: Icon(
                            Icons.delete,
                            size: 24,
                          ),
                          label: Text(
                            'Delete',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
