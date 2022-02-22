import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oxon_app/pages/profile_pg.dart';
import 'dart:io';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../theme/colors.dart';
import '../size_config.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  static const routeName = 'qr-scanner';

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int? scansToday;
  var lastScanDay;
  final FirebaseAuth auth = FirebaseAuth.instance;
  int currentUserCredits = 0;

  _fetch() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((ds) {
        scansToday =
        ds.data()!['scansToday'] == null ? 0 : ds.data()!['scansToday'];
        lastScanDay =
        ds.data()!['lastScanDay'] == null ? 0 : ds.data()!['lastScanDay'];
        currentUserCredits =
        ds.data()!['credits'] == null ? 0 : ds.data()!['credits'];
      }).catchError((e) {
        print(e);
      });
    }
  }

  Widget _QRResult(String? result) {
    if (result == 'oxon-van-qr' ) {
      if (scansToday! < 2) {
        if (lastScanDay == DateTime.now().day) {
          return Expanded(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: SizeConfig.screenHeight * 0.2,
                width: SizeConfig.widthMultiplier * 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '5 Rupees added to your wallet!',
                        style: TextStyle(color: Colors.green[900]),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25.0)),
                    TextButton(
                        onPressed: () async {
                          final user = await FirebaseAuth.instance.currentUser;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .update({
                            'credits': currentUserCredits + 5,
                            'scansToday': scansToday! + 1,
                            'lastScanDay': DateTime.now().day
                          }).then((value) {
                            Navigator.of(context)
                                .pushNamed(ProfilePage.routeName);
                          }).catchError((e) {
                            print(e);
                          });
                          await Navigator.of(context)
                              .pushReplacementNamed(ProfilePage.routeName);
                        },
                        child: Text(
                          'Got It!',
                          style:
                          TextStyle(color: Colors.purple, fontSize: 18.0),
                        ))
                  ],
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: SizeConfig.screenHeight * 0.2,
                width: SizeConfig.widthMultiplier * 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '5 Rupees added to your wallet!',
                        style: TextStyle(color: Colors.green[900]),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25.0)),
                    TextButton(
                        onPressed: () async {
                          final user = await FirebaseAuth.instance.currentUser;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .update({
                            'credits': currentUserCredits + 5,
                            'scansToday': 1,
                            'lastScanDay': DateTime.now().day
                          }).then((value) {
                            Navigator.of(context)
                                .pushNamed(ProfilePage.routeName);
                          }).catchError((e) {
                            print(e);
                          });
                          await Navigator.of(context)
                              .pushReplacementNamed(ProfilePage.routeName);
                        },
                        child: Text(
                          'Got It!',
                          style:
                          TextStyle(color: Colors.purple, fontSize: 18.0),
                        ))
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        return Expanded(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              height: SizeConfig.screenHeight * 0.2,
              width: SizeConfig.widthMultiplier * 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Sorry, you have surpassed today\'s scan limit.',
                      style: TextStyle(color: Colors.green[900]),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(ProfilePage.routeName);
                      },
                      child: Text(
                        'Got It!',
                        style: TextStyle(color: Colors.purple, fontSize: 18.0),
                      ))
                ],
              ),
            ),
          ),
        );
      }
    }

    return Expanded(
        flex: 1,
        child: Center(
            child: Text(
              'Please scan a valid QR code.',
              style: TextStyle(fontSize: 20),
            )));
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: AppColors().oxonGreen,
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                _QRResult(result?.code)
              ],
            ),
          );
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}