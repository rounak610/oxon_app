import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oxon_app/pages/sigup_pg.dart';
import 'login_pg.dart';
import '../widgets/custom_drawer.dart';
import 'package:oxon_app/pages/products_pg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import 'package:oxon_app/pages/products_pg.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController _controller = TextEditingController();
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
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
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
              padding: EdgeInsets.all(32.0),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 460, 0, 0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 190, height: 60),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsPage()));
                        },
                        child: Text(
                          "Get OTP",
                          style: TextStyle(color: Colors.black, fontSize: 35),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[50],
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(35.0))),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green[50],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green[50],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
