import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon/theme/colors.dart';

import 'cart_pg.dart';

class PaymentPage extends StatefulWidget {
  final int price;

  PaymentPage({required this.price});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? userCredits;
  int? finalPrice;

  final FirebaseAuth auth = FirebaseAuth.instance;

  _fetch() async {
    int price = widget.price;

    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((ds) {
        print(ds);
        userCredits = ds.data()!['credits'] == null ? 0 : ds.data()!['credits'];

        if (price! * 0.2 >= userCredits!) {
         FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .update({
                'credits': 0,
              })
              .then((value) {})
              .catchError((e) {
                print(e);
              });
          finalPrice = (price! * 0.8).toInt();
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .update({
                'credits': userCredits! - (0.2 * price!).toInt(),
              })
              .then((value) {})
              .catchError((e) {
                print(e);
              });
          finalPrice = (price! * 0.8 + 50).toInt();
        }
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Stack(
              children: [
                Center(
                    child: Text("PAY your total = " +
                        finalPrice.toString())),
              ],
            ),
          );
        });
  }
}
