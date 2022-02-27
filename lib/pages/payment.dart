import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oxon_app/widgets/Appbar_otpscreen.dart';
import 'package:oxon_app/theme/app_theme.dart';

import '../theme/colors.dart';

class Payment extends StatefulWidget {
  final int total;
  Payment(this.total);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay razorpay;
  late String mobile;

  _fetch() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((ds) {
        mobile = ds.data()!['mobile'];
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetch();
    razorpay = new Razorpay();
    openCheckout();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentsuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymenterror);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalwallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "esPAPF1snLA8qnWKD7wl9XRn",
      "amount": widget.total * 100,
      "name": "Oxon",
      "description": "Your final amount",
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void paymentsuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS ", timeInSecForIosWeb: 4);

    final CollectionReference _userRef =
    FirebaseFirestore.instance.collection("users");
    Color addtext = AppColors().oxonOffWhite;
    Color addback = AppColors().oxonGreen;
    User? _user =  FirebaseAuth.instance.currentUser;
    final CollectionReference _order =
    FirebaseFirestore.instance.collection("orders");
    Object _add_to_cart(){
      return _order.doc(_user?.uid).set(
          {"customer name": _user?.displayName,
            "contact": _user?.phoneNumber,
            "cart":_userRef.doc(_user?.uid).collection("cart")
          }
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Thanks for using Oxon, your order has been successfully created\nOur marketing team will get back to you soon for more details.'),
        duration: Duration(seconds: 8),
      ),
    );

  }

  void paymenterror(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR ", timeInSecForIosWeb: 4);
  }

  void externalwallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET ", timeInSecForIosWeb: 4);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarotpscreen(context, "Payment"),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/products_pg_bg.png"),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                    'Press the Back button at top left corner to go back',
                    style: AppTheme.define().textTheme.headline1),
              ),
            ),
          )
        ]));
  }
}
