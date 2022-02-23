import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:oxon/models/driver_loc_data.dart';
import 'package:oxon/pages/driver_passcode.dart';
import 'package:oxon/repositories/driver_loc_repository.dart';
import 'package:oxon/widgets/custom_appbar.dart';
import 'package:oxon/widgets/custom_drawer.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';


import '../theme/app_theme.dart';
class DriversSection extends StatefulWidget {
  const DriversSection({Key? key}) : super(key: key);

  @override
  _DriversSectionState createState() => _DriversSectionState();
}

class _DriversSectionState extends State<DriversSection> {

  late String final_pass;
  late String vehicle_no;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  final repository = DriverLocRepository();

  @override
  void initState()
  {
    getValidationData().whenComplete(() async
    {
      Timer(Duration(milliseconds: 2), () => Get.to(final_pass == null ? DriverAuth() : DriversSection));
    }
    );
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  Future getValidationData() async
  {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtained_pass = sharedPreferences.getString('password');
    setState(() {
      final_pass = obtained_pass!;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.colors.oxonGreen,
          drawer: CustomDrawer(),
          appBar: CustomAppBar(context, "Driver's Section",
            [
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async{
                    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.remove('password');
                    Get.to(DriverAuth());
                  },
                  child: Icon(
                      Icons.logout,
                    size: 40,
                  ),
                )
            ),
            ]
          ),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
                content: Text('Press again to exit the app'),
                duration: Duration(seconds: 2)),
            child: Stack(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 240, 0, 0),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              autofocus: true,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                                ),
                                border: OutlineInputBorder(

                                    borderRadius: BorderRadius.circular(20)),
                                hintText: 'Enter your vehicle number',
                                hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                                labelText: 'Vehicle number',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  vehicle_no = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter your vehicle number';
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                trackingStarted(vehicle_no);
                                _listenLocation(vehicle_no);
                                Fluttertoast.showToast(
                                    msg: 'Live location started',
                                    gravity: ToastGravity.TOP);
                              },
                            child: Text(
                              'Start Live Location',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.white, width: 2),
                                primary: Color.fromARGB(255, 34, 90, 0),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(40.0))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _stopListening();
                              Fluttertoast.showToast(
                                  msg: 'Live location ended',
                                  gravity: ToastGravity.TOP);
                            },
                            child: Text(
                              'End Live Location',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.white, width: 2),
                                primary: Colors.red,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(40.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> _listenLocation(String vehicle_no) async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      trackingStopped(vehicle_no);

      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      DriverLocData driverLocData;

      FirebaseFirestore.instance
          .collection("driver_loc_data")
          .where("vehicleNumber", isEqualTo: vehicle_no)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          print("empty");
          return;
        }
        driverLocData = DriverLocData.fromSnapshot(value.docs.first);
        if (driverLocData.locationsVisited.last !=
            GeoPoint(currentlocation.latitude!, currentlocation.longitude!)) {
          driverLocData.locationsVisited.add(
              GeoPoint(currentlocation.latitude!, currentlocation.longitude!));
          DriverLocRepository().updateDriverLocData(driverLocData);
        }
      });
    });
  }

  _stopListening() {
    trackingStopped(vehicle_no);
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg: "Select 'Allow all the time'",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
      openAppSettings();
    }
  }

  void trackingStarted(String vehicle_no) async {
    final loc = await location.getLocation();
    FirebaseFirestore.instance
        .collection("driver_loc_data")
        .where("vehicleNumber", isEqualTo: vehicle_no)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        print("empty");
        final driverLocData = DriverLocData(
            vehicleType: "ordinary_waste_collection",
            vehicleNumber: vehicle_no,
            locationsVisited: [GeoPoint(loc.latitude!, loc.longitude!)],
            routeId: "-999",
            dateOfTransport: Timestamp.now(),
            isVehicleParked: false);
        repository.addDriverLocData(driverLocData);
      } else {
        final driverLocData = DriverLocData.fromSnapshot(value.docs.first);
        driverLocData.isVehicleParked = false;

        driverLocData.locationsVisited = [
          GeoPoint(loc.latitude!, loc.longitude!)
        ];

        //

      }
    });
  }

  void trackingStopped(String vehicle_no) {
    FirebaseFirestore.instance
        .collection("driver_loc_data")
        .where("vehicleNumber", isEqualTo: vehicle_no)
        .limit(1)
        .get()
        .then((value) {
      final driverLocData = DriverLocData.fromSnapshot(value.docs.first);
      driverLocData.isVehicleParked = true;
      final pD = driverLocData.locationsVisited.last;
      driverLocData.locationsVisited = <dynamic>[pD];
      repository.updateDriverLocData(driverLocData);
    });
  }
}
