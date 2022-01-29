import 'package:flutter/material.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String userName = "Aikagra";
    String userResidence = "Pilani";
    String userMobileNo = "98********";

    final ButtonStyle solidRoundButtonStyle = SolidRoundButtonStyle();

    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          appBar: CustomAppBar(context, widget.title),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/profile_pg.png"),
                        fit: BoxFit.cover)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(36, 0, 36, 0),
                child: Center(
                  child: Column(children: [
                    Table(
                      defaultColumnWidth: FixedColumnWidth(160),
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
                        onPressed: () {},
                        child: Text(
                          "Update Details",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        style: solidRoundButtonStyle,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Container(
                          child: Text(
                            "Check Your Wallet",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        style: solidRoundButtonStyle,
                      ),
                    )
                  ]),
                ),
              )
            ],
          )),
    );
  }
}
