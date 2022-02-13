import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

//Things to be done here:
// 1 - Get userdata such as names, address etc
// 2 - Store it in a collection 'user' instance in firestore database

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
