import 'package:flutter/material.dart';

class Drawer extends StatefulWidget {
  const Drawer({super.key, required ListView child});

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            InkWell(
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
              },
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  foregroundImage: AssetImage('assets/profile.png'),
                ),
                accountName: Text("",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 660,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 30,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        title: Text(
                          'Discounts',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                      },
                      child: ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(
                            'Categories',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                      },
                      child: ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(
                            'Products',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                      },
                      child: ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(
                            'Orders',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.white,
                      endIndent: 7,
                    ),
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                      },
                      child: ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(
                            'Contact Support',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                    ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        title: Text(
                          'About Us',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                      },
                      child: ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          title: Text(
                            'FAQs',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 120,
                          top: 100,
                        ),
                        child: TextButton(
                            onPressed: () {

                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
