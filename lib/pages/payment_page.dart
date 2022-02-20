import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/theme/colors.dart';

import 'cart_pg.dart';

class PaymentPage extends StatefulWidget {
  final int price;

  PaymentPage( {required this.price});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Text("PAY your total = "+widget.price.toString())),
        ],
      ),
    );
  }
}
