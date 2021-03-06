import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oxon/models/mobile_number.dart';
import 'package:oxon/pages/otpscreen.dart';
import 'package:oxon/pages/products_pg.dart';
import 'package:oxon/pages/profile_pg.dart';
import 'package:oxon/pages/sustainable_mapping_pg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oxon/models/user_profile.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const routeName = '/welcome-page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController _controller = TextEditingController();
  bool showLoading = false;
  late int phonenumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/sign_in_pg.png"),
                      fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 480),
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.black54),
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                '+91',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          controller: _controller,
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 190, height: 60),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showLoading = true;
                            });

                            _controller.text.length == 10
                                ? {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OTPScreen(_controller.text)))
                                  }
                                : {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Enter a valid 10 digit phone number"),
                                    ))
                                  };
                          },
                          child: Text(
                            "Send OTP",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[50],
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(35.0))),
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
