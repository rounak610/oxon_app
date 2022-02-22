import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/pages/driver_passcode.dart';
import 'package:oxon_app/pages/sign_out.dart';
import 'package:oxon_app/pages/van_tracking.dart';
import 'package:oxon_app/pages/welcome_pg.dart';

import '../pages/donate_dustbin.dart';
import '../pages/products_pg.dart';
import '../pages/profile_pg.dart';
import '../pages/sustainable_mapping_pg.dart';
import '../pages/raise_concern.dart';
import '../pages/coming_soon.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget _tileItem(String text, String routeName, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(routeName);
        },
        title: Text(
          text,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.green[900]),
        ),
      ),
    );
  }

  String userName = "Not Updated";
  _fetch() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((ds) {
        userName = ds.data()!['name'];
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 15,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.green[900],
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: Image.asset(
                                'assets/images/user_img.png')
                            .image, //TO BE REPLACED WITH USER'S NETWORK IMAGE//
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text('Hello,',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900])),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: FutureBuilder(
                              future: _fetch(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done)
                                  return Text('Loading');
                                return Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900]),
                                );
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RaiseConcernDirect.routeName);
                  },
                  child: Text(
                    'Report a complaint',
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green[900],
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0))),
                ),
              ),
              _tileItem('Profile', ProfilePage.routeName, context),

              //_tileItem('Let\'s Shop', ComingSoon.routeName, context),
              _tileItem('Dustbin and Toilets', SusMapping.routeName, context),
              _tileItem('Van Tracking', VanTracking.routeName, context),
              // _tileItem('My Wallet', ComingSoon.routeName, context),
              _tileItem('Help the city', ComingSoon.routeName, context),
              _tileItem('Explore & Bid', ComingSoon.routeName, context),
              _tileItem("Driver's Section", DriverAuth.routeName, context),
              _tileItem('Log Out', SignOut.routeName, context),


              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 120,
                    padding: EdgeInsets.all(15),
                    child: Image.asset('assets/images/oxon_logo.png'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
