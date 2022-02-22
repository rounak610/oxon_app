import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/pages/payment.dart';
import 'package:oxon_app/pages/payment_page.dart';

import 'package:oxon_app/theme/colors.dart';
import 'package:oxon_app/widgets/cart_item.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart-page';
  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection("users");
  User? _user = FirebaseAuth.instance.currentUser;
  int total =
      0; //can be modified to get delivery rate data directly from firebase collection delivery rate

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(context, 'Cart'),
      backgroundColor: Color.fromARGB(255, 34, 90, 0),
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(20.0, 5, 15.0, 5),
              child: Text(
                "Swipe left to delete a product from the cart",
                style: TextStyle(
                    color: AppColors().oxonOffWhite,
                    fontWeight: FontWeight.bold),
              )),
          Container(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future: _userRef.doc(_user?.uid).collection("Cart").get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Scaffold(
                          body: Center(
                            child: Text("Error Loading products"),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView(
                          padding: EdgeInsets.only(
                            top: 30.0,
                            bottom: 20.0,
                          ),
                          children: snapshot.data!.docs.map((document) {
                            int p = document.get('price') as int;
                            int q = document.get('quantity') as int;
                            int d = document.get('delivery') as int;
                            total += p * q;
                            total += d;
                            return CartItem(
                                "${document.get('ID')}",
                                document.get('price'),
                                document.get('quantity'),
                                "${document.get('name')}");
                          }).toList(),
                        );
                      }
                      return Scaffold(
                        body: Center(
                          child: LinearProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5.0,
            right: 15,
            left: 15,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => (Payment(total))));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: AppColors().oxonOffWhite),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 25.0,
                        ),
                        child: Text("Proceed to payment",
                            style: TextStyle(
                                fontSize: 20, color: AppColors().oxonGreen)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
