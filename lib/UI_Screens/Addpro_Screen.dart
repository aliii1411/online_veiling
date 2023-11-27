import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_veiling/UI_Screens/Mypro_Screen.dart';

class addproduct extends StatefulWidget {
  const addproduct({Key? key}) : super(key: key);

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  TextEditingController _controllertitle = TextEditingController();
  TextEditingController _controllerdescription = TextEditingController();
  TextEditingController _controllerauctiontimehr = TextEditingController();
  TextEditingController _controllerauctiontimemin = TextEditingController();
  TextEditingController _controllerauctiontimesec = TextEditingController();
  TextEditingController _controllerprice = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('products');

  bool loading = false;
  bool isUploaded = false;
  bool isButtonEnabled = true;

  String userEmail = '';
  String imageUrl = '';
  File? selectedImage;

  final auth = FirebaseAuth.instance;
  User? _user;

  void resetFormFields() {
    _controllertitle.clear();
    _controllerdescription.clear();
    _controllerauctiontimehr.clear();
    _controllerauctiontimemin.clear();
    _controllerauctiontimesec.clear();
    _controllerprice.clear();
    selectedImage = null;
    imageUrl = '';
  }

  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Add Products'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);print('${file?.path}');

                        if (file == null) return;

                        selectedImage = File(file.path);
                        // Update the image immediately after it's picked
                        setState(() {});
                      },
                      child: Container(
                        height: 140,
                        width: 160,
                        decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(16)),
                        child: selectedImage == null
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.camera_alt_rounded, size: 50, color: Colors.grey,),
                                  Text('Select Image',
                                    style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold,),),
                                ],
                              ),
                            )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(selectedImage!, width: 160, height: 140, fit: BoxFit.cover,),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _controllertitle,
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
                    controller: _controllerdescription,
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
                                    controller: _controllerauctiontimehr,
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
                                    controller: _controllerauctiontimemin,
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
                                    controller: _controllerauctiontimesec,
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
                              controller: _controllerprice,
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
                  SizedBox(height: 35,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      maximumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onSurface: Colors.transparent,
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: loading
                        ? null
                        : () async {
                      if (selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please upload an image')),
                        );
                        return;
                      }

                      if (key.currentState!.validate()) {
                        setState(() {
                          loading = true; // Set loading to true when the button is pressed
                        });

                        String title = _controllertitle.text;
                        String itemdescription = _controllerdescription.text;
                        String itemauctiontimehr = _controllerauctiontimehr.text;
                        String itemauctiontimemin = _controllerauctiontimemin.text;
                        String itemauctiontimesec = _controllerauctiontimesec.text;
                        String itemprice = _controllerprice.text;
                        String itemEmail = _user?.email ?? "test@xyz.com";

                        // Upload the selected image to Firebase Storage here
                        String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                        Reference referenceRoot = FirebaseStorage.instance.ref();
                        Reference referenceDirImages = referenceRoot.child('product_images');
                        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                        try {
                          await referenceImageToUpload.putFile(selectedImage!);
                          imageUrl = await referenceImageToUpload.getDownloadURL();

                          // Create a Map of data
                          Map<String, String> dataToSend = {
                            'title': title,
                            'description': itemdescription,
                            'time in hours': itemauctiontimehr,
                            'time in minutes': itemauctiontimemin,
                            'time in seconds': itemauctiontimesec,
                            'price': itemprice,
                            'image': imageUrl,
                            'userEmail':itemEmail,

                          };

                          // Add a new item
                          _reference.add(dataToSend).then((value) {
                            // Reset the form and loading state after successful submission
                            key.currentState!.reset();
                            setState(() {
                              loading = false;
                              selectedImage = null; // Clear the selected image
                              imageUrl = ''; // Clear the image URL
                            });

                            // Navigate to the MyProducts() screen
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => My_products(),
                            ));
                          });
                        } catch (error) {
                          // Handle any errors during the image upload
                          print("Error uploading image: $error");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error uploading image. Please try again later.')));
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                    child: Center(
                      child:
                      loading // Show a CircularProgressIndicator when loading is true
                          ? CircularProgressIndicator()
                          : Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
