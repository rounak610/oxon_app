import 'package:flutter/material.dart';
import 'package:oxon_app/pages/sustainable_mapping_pg.dart';
import 'welcome_pg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:oxon_app/pages/welcome_pg.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:oxon_app/widgets/Appbar_otpscreen.dart';
import 'package:oxon_app/theme/app_theme.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool showLoading = false;
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBarotpscreen(context, "OTP Verification"),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/products_pg_bg.png"),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: showLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text('Enter OTP',
                              style: AppTheme.define().textTheme.headline1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: PinPut(
                          fieldsCount: 6,
                          textStyle: const TextStyle(
                              fontSize: 25.0, color: Colors.white),
                          eachFieldWidth: 40.0,
                          eachFieldHeight: 55.0,
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          submittedFieldDecoration: pinPutDecoration,
                          selectedFieldDecoration: pinPutDecoration,
                          followingFieldDecoration: pinPutDecoration,
                          pinAnimationType: PinAnimationType.fade,
                          onSubmit: (pin) async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: _verificationCode,
                                          smsCode: pin))
                                  .then((value) async {
                                if (value.user != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SusMapping()),
                                  );
                                }
                              });
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              _scaffoldkey.currentState
                                  // ignore: deprecated_member_use
                                  ?.showSnackBar(
                                      SnackBar(content: Text('invalid OTP')));
                            }
                          },
                        ),
                      )
                    ],
                  ),
          ),
        ]));
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          setState(() {
            showLoading = false;
          });
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print("user logged in");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SusMapping()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) async {
          setState(() {
            showLoading = false;
          });
          print(e.message);
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            showLoading = false;
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
