import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oxon/models/concern.dart';
import 'package:oxon/pages/sustainable_mapping_pg.dart';
import 'package:oxon/repositories/maps_repository.dart';
import 'package:oxon/theme/app_theme.dart';
import 'package:oxon/widgets/custom_appbar.dart';
import 'package:oxon/widgets/custom_drawer.dart';
import 'package:oxon/api/firebase_api.dart';

//import 'package:flutter_share_me/flutter_share_me.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../models/concern.dart';

class PreviewReport extends StatefulWidget {
  const PreviewReport({Key? key}) : super(key: key);

  static const routeName = '/preview-report';

  @override
  _PreviewReportState createState() => _PreviewReportState();
}

final _formKey = GlobalKey<FormState>();

class _PreviewReportState extends State<PreviewReport> {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _locationData = null;


  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  String collectionName = "complaint_images";

  void onLayoutDone(Duration timeStamp) async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {});
  }

  String userName = "Not Updated";
  String mobile = "Not updated";
  String twitter = "Not updated";

  _fetch() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((ds) {
        userName = ds.data()!['name'];
        mobile = ds.data()!['mobile'];
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Concern;
    final description = args.description;
    final issueType = args.issueType;
    final imagePath = args.imagePath;
    final problem = args.authorityType;


    return SafeArea(
        child: Scaffold(
      backgroundColor: AppTheme.colors.oxonGreen,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(context, "Preview Your Report"),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        Image.asset('assets/images/products_pg_bg.png').image,
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FutureBuilder(
                            future: _fetch(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) return Text('Loading');
                              return Text(
                                userName,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              );
                            })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Mobile No. :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FutureBuilder(
                            future: _fetch(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) return Text('Loading');
                              return Text(
                                mobile,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              );
                            })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Problem Category :",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            issueType,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Issue :",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            problem,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Location :",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FutureBuilder<String>(
                            future: getCurrentLocationAddress(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData)
                              {
                                return Expanded(
                                    child: Text("${snapshot.data}",
                                        style: AppTheme.define()
                                            .textTheme
                                            .headline4)
                                );
                              }
                              else if (snapshot.hasError)
                              {
                                return Text(
                                    "Error fetching location. Ensure device location is turned on and please try again");
                              }
                              else {
                                try {
                                  return Row(
                                    children: [
                                      Text(
                                        "Getting location data...\nPlease wait..",
                                        style: AppTheme.define()
                                            .textTheme
                                            .headline2,
                                      ),
                                      CircularProgressIndicator()
                                    ],
                                  );
                                } catch (e, s) {
                                  print(s);
                                }
                              }
                              return Text(
                                  "Error fetching location. Ensure device location is turned on and please try again");
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description :",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        description,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Photo Uploaded :",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.file(File(imagePath))),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      autofocus: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          //borderSide: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Enter your twitter username',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        labelText: 'Twitter username',
                        labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onChanged: (value) {
                        setState(() {
                          twitter = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('*Enter your twitter username only when you do not belong to the Gangapur City',
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w200
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 250, height: 60),
                          child: ElevatedButton(
                            onPressed: () async {

                              if (_formKey.currentState!.validate())
                              {
                              }

                              _uploadComplaint_Details(imagePath, userName,description,issueType,problem, twitter);

                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green[50],
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(35.0))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 300, height: 60),
                        child: ElevatedButton(
                          onPressed: () => _onShare(context, imagePath,
                              issueType, description, problem),
                          child: Text(
                            'Share via Twitter',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green[900],
                                fontWeight: FontWeight.w900),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[50],
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(35.0))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 250, height: 60),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SusMapping()));
                          },
                          child: Text(
                            'Go back to home',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              primary: Color.fromARGB(255, 34, 90, 0),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(35.0))),
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    ));
  }

  void _onShare(BuildContext context, String imagePath, String issueType,
      String description, String problem) async
  {
    final locationAddress = await getCurrentLocationAddress();
    final box = context.findRenderObject() as RenderBox?;
    List<String> imagePaths = [imagePath];
    String str =
        "@AshokChandnaINC @drsubhashg @DrJitendraSingh @RajSampark @_PParashar \nI have a issue with ${issueType} \nWe have ${problem} at ${locationAddress} \n${description} \nComplaint posted by @oxon_life";
    if (imagePath.isNotEmpty)
    {
      await Share.shareFiles(imagePaths,
          text: str,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    else
      {
      await Share.share(issueType,
          subject: description,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  //to upload the image taken by the user to the firebase storage
  _uploadComplaint_Details(String imagePath, String username, String description, String issueType, String problem, String twitter)
  async {
    var uniquekey = firestoreRef.collection(collectionName);
    String uploadFileName = 'uploaded by' + username + 'at' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference = storageRef.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath));
    uploadTask.snapshotEvents.listen((event)
    {
      print(event.bytesTransferred.toString()+ "\t" + event.totalBytes.toString());
    }
    );

    await uploadTask.whenComplete(()
    async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('complaints').add({
        'description': description,
        'issueType': issueType,
        'problem': problem,
        'twitter username': twitter,
        'image': uploadPath
      })
          .then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Thanks for using Oxon, your complain is registered\nWe will soon get back to you with further updates on your complain.'),
              duration: Duration(seconds: 8),
            ),
          );
        }
      }).catchError((e) {
        print(e);
      }
      );
    }
    );
  }


  Future<String> getCurrentLocationAddress() async
  {
    const errorMessage =
        "Error fetching location data. Ensure device location and internet is switched on and please try again.";
    _locationData = await location.getLocation();

    if (_locationData == null || _locationData!.latitude == null) {
      return errorMessage;
    }

    final geoCodedData = await MapsRepository().convertLatLngToGeoCodedLoc(
        LatLng(_locationData!.latitude!, _locationData!.longitude!));

    if (geoCodedData == null) {
      return errorMessage;
    }
    return "${geoCodedData.formattedAddress} (${geoCodedData.compoundPlusCode})";
  }
}
