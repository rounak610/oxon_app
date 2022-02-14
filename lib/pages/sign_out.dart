import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignOut extends StatefulWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  _SignOutState createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signout();
  }

  _signout() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/products_pg_bg.png"),
                fit: BoxFit.cover)),
      ),
    ]));
  }
}
