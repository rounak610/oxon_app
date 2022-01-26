import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Widget _tileItem(String text, String routename) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        onTap: () {},
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
      backgroundColor: Colors.green[50],
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
                    backgroundImage: Image.asset('assets/images/profile_pic.jpg')
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
          _tileItem('Profile', 'routename'),
          _tileItem('My Wallet', 'routename'),
          _tileItem('Let\'s Shop', 'routename'),
          _tileItem('Sustainable Mapping', 'routename'),
          _tileItem('Explore & Bid', 'routename'),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                padding: EdgeInsets.all(15),
                child: Image.asset('assets/images/oxon_logo.jpeg'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
