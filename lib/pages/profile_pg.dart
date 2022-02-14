import 'package:flutter/material.dart';
import 'package:oxon_app/pages/coming_soon.dart';
import 'package:oxon_app/pages/update_profile.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key); //, required this.title

  static const routeName = '/profile-page';

  // final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String userName = "Not set";
    String userResidence = "Not set";
    String userMobileNo = "Not set";
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    String? uid;
    void setData() async {
      user = auth?.currentUser;
      uid = user?.uid;
      setState(() async {
        await FirebaseFirestore.instance
            .collection('users/$uid')
            .doc(uid)
            .get()
            .then((dataSnapshot) {
          setState(() {
            userResidence = dataSnapshot.data()!['address'];
            userMobileNo = dataSnapshot.data()!['number'];
            userName = dataSnapshot.data()!['name'];
          });
        });
      });
    }

    final ButtonStyle solidRoundButtonStyle = SolidRoundButtonStyle(Size(
        146.32 * SizeConfig.responsiveMultiplier,
        7.61 * SizeConfig.responsiveMultiplier));
    @override
    initState() {
      setData();
      super.initState();
    }

    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          appBar: CustomAppBar(context, "Profile"),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
                content: Text('Press again to exit the app'),
                duration: Duration(seconds: 2)),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/profile_pg.png"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      5.27 * SizeConfig.responsiveMultiplier,
                      0,
                      5.27 * SizeConfig.responsiveMultiplier,
                      0),
                  child: Center(
                    child: Column(children: [
                      SizedBox(
                        height: 5.85 * SizeConfig.responsiveMultiplier,
                      ),
                      Table(
                        defaultColumnWidth: FixedColumnWidth(
                            23.41 * SizeConfig.responsiveMultiplier),
                        children: [
                          TableRow(children: [
                            Text("Name: ",
                                style: Theme.of(context).textTheme.headline2),
                            Text(userName,
                                style: Theme.of(context).textTheme.headline2)
                          ]),
                          TableRow(children: [
                            SizedBox(height: 25),
                            SizedBox(height: 25)
                          ]),
                          TableRow(children: [
                            Text("Residence: ",
                                style: Theme.of(context).textTheme.headline2),
                            Text(userResidence,
                                style: Theme.of(context).textTheme.headline2)
                          ]),
                          TableRow(children: [
                            SizedBox(height: 25),
                            SizedBox(height: 25)
                          ]),
                          TableRow(children: [
                            Text("Mobile No. : ",
                                style: Theme.of(context).textTheme.headline2),
                            Text(userMobileNo,
                                style: Theme.of(context).textTheme.headline2)
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(UpdateProfile.routeName);
                          },
                          child: Text(
                            "Update Details",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(color: AppTheme.colors.oxonGreen),
                          ),
                          style: solidRoundButtonStyle,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ]
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
