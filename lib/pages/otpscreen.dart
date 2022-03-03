import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxon/pages/products_pg.dart';
import 'package:oxon/pages/update_profile.dart';
import 'package:oxon/size_config.dart';
import 'package:oxon/theme/app_theme.dart';
import 'package:oxon/widgets/Appbar_otpscreen.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:timer_button/timer_button.dart';

class OTPScreen extends StatefulWidget {
  final String phone;

  OTPScreen(this.phone);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool showLoading = false;
  int? _resendToken;
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    void signinWithPhoneAuthCredential(
        PhoneAuthCredential phoneAuthCredential) async {
      final QuerySnapshot result = await firestore
          .collection('users')
          .where('mobile', isEqualTo: widget.phone)
          .limit(1)
          .get();
      setState(() {
        showLoading = true;
      });
      try {
        final authCredential = await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential);
        setState(() {
          showLoading = false;
        });

        if (result.docs.length != 0) {
          if (authCredential.user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductsPage())); ////////LOGIC FOR OLD USERS
          }
        } else {
          final user = await FirebaseAuth
              .instance.currentUser; //////////LOGIC FOR NEW USERS
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .set({
                'credits': 50,
              })
              .then((value) async {})
              .catchError((e) {
                print(e);
              });
          const bonusSnackBar = SnackBar(
            content: Text('Yay!Rs. 50 signing up bonus added to wallet!!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(bonusSnackBar);
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateProfile()));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          showLoading = false;
        });
        FocusScope.of(context).unfocus();
        _scaffoldkey.currentState
            // ignore: deprecated_member_use
            ?.showSnackBar(SnackBar(content: Text("Invaild OTP")));
      }
    }

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
                ? Center(child: LinearProgressIndicator())
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
                              PhoneAuthCredential phoneAuthCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: _verificationCode,
                                      smsCode: pin);
                              signinWithPhoneAuthCredential(
                                  phoneAuthCredential);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                          "Didn't receive code?",
                          style: AppTheme.define().textTheme.headline4,
                        ),
                      ),
                      TimerButton(
                        label: "Resend OTP",
                        timeOutInSeconds: 30,
                        onPressed: () async {
                          _verifyPhone();
                        },
                        disabledColor: Colors.grey.shade300,
                        color: Colors.white,
                        buttonType: ButtonType.ElevatedButton,
                        disabledTextStyle: new TextStyle(
                            fontSize: 3.22 * SizeConfig.responsiveMultiplier,
                            color: Colors.black),
                        activeTextStyle: new TextStyle(
                            fontSize: 3.22 * SizeConfig.responsiveMultiplier,
                            color: Colors.black),
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
          signinWithPhoneAuthCredential(credential);
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
            _resendToken = resendToken;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120),
        forceResendingToken: _resendToken);
  }

  void signinWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    final QuerySnapshot result = await firestore
        .collection('users')
        .where('mobile', isEqualTo: widget.phone)
        .limit(1)
        .get();
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });

      if (result != null) {
        if (authCredential.user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProductsPage()));
        }
      } else {
        if (authCredential.user != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateProfile()));
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      FocusScope.of(context).unfocus();
      _scaffoldkey.currentState
          // ignore: deprecated_member_use
          ?.showSnackBar(SnackBar(content: Text("Invaild OTP")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
