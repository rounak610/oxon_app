import 'package:flutter/material.dart';

import '../pages/donate_dustbin.dart';
import '../pages/products_pg.dart';
import '../pages/profile_pg.dart';
import '../pages/sustainable_mapping_pg.dart';
import '../pages/raise_concern.dart';
import '../pages/coming_soon.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
                          child: Text(
                            'John Doe', //TO BE REPLACED WITH USER'S NAME//
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900]),
                          ),
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
                    'Raise a Concern',
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green[900]),
                ),
              ),
              _tileItem('Profile', ProfilePage.routeName, context),
              _tileItem('My Wallet', ComingSoon.routeName, context),
              _tileItem('Let\'s Shop', ComingSoon.routeName, context),
              _tileItem('Dustbin and Toilets', SusMapping.routeName, context),
              _tileItem('Donate a Dustbin', ComingSoon.routeName, context),
              _tileItem('Explore & Bid', ComingSoon.routeName, context),
              _tileItem('Van Tracking', ComingSoon.routeName, context),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
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
