import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;
import 'package:oxon_app/models/driver_loc_data.dart';
import 'package:oxon_app/repositories/driver_loc_repository.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_theme.dart';

class DriversSection extends StatefulWidget {
  const DriversSection({Key? key}) : super(key: key);

  @override
  _DriversSectionState createState() => _DriversSectionState();
}

class _DriversSectionState extends State<DriversSection> {
  late String vehicle_no;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  final repository = DriverLocRepository();

  @override
  void initState() {
    super.initState();

    _requestPermission();

    location.changeSettings(
        interval: 5 * 1000, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppTheme.colors.oxonGreen,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(context, "Driver's Section"),
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
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Enter your vehicle number',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
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
                        _listenLocation(vehicle_no);
                        Fluttertoast.showToast(
                            msg: 'Live location started',
                            gravity: ToastGravity.TOP);
                        trackingStarted(vehicle_no);
                      },
                      child: Text(
                        'Start live location',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green[50],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _stopListening();
                        trackingStopped(vehicle_no);
                        Fluttertoast.showToast(
                            msg: 'Live location ended',
                            gravity: ToastGravity.TOP);
                      },
                      child: Text(
                        'End live location',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green[50],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0))),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
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
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg: "Select 'Allow all the time'",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
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
    });
  }
}
