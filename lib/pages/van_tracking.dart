import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oxon_app/models/driver_loc_data.dart';
import 'package:oxon_app/repositories/driver_loc_repository.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class VanTracking extends StatefulWidget {
  VanTracking({Key? key}) : super(key: key);
  static const routeName = '/van-tracking-page';

  @override
  _VanTrackingState createState() => _VanTrackingState();
}

class _VanTrackingState extends State<VanTracking>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  String? userName;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;

  var cameraPosition =
      CameraPosition(target: LatLng(26.4814719, 76.7298792), zoom: 15);

  Set<Polyline> _polylines = {};

  String? value;

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _locationData = null;

  final DriverLocRepository repository = DriverLocRepository();
  Set<Marker> vanMarkers = {};
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;
  var truckIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();

    getUserData();
    WidgetsBinding.instance?.addObserver(this);
    onLayoutDone(Duration());
    setCustomMarker();
  }

  Widget CustomMap(Set<Marker> setOfMarkers, String type) {
    return Stack(
      children: [
        GoogleMap(
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: cameraPosition,
          markers: setOfMarkers,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
            _controller.complete(controller);
            setState(() {});
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
              iconSize: 8.45 * SizeConfig.responsiveMultiplier,
              onPressed: () => goToCurrLoc(),
              icon: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/icons/blue_bg_gps_icon.png"))),
              )),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _googleMapController.setMapStyle("[]");
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.detached) {}
  }

  //

  void setCustomMarker() async {
    truckIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/truck.png',
    );

    setState(() {});
  }

  void moveCameraFromAddLoc(String type) {
    cameraPosition = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16);
    setState(() {});
  }

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
    // cameraPosition = CameraPosition(
    //     target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
    //     zoom: 15);

    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          appBar: CustomAppBar(
            context,
            "Van Tracking",
          ),
          body: Container(
            margin: SizeConfig.screenHeight > 600
                ? EdgeInsets.only(top: 5.85 * SizeConfig.responsiveMultiplier)
                : EdgeInsets.all(0),
            child: StreamBuilder<QuerySnapshot>(
                stream: repository.getStreamDriverLoc(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  _buildListVanMarkers(snapshot.data?.docs ?? []);

                  return CustomMap(vanMarkers, "dustbin");
                }),
          )),
    );
  }

  goToCurrLoc() async {
    _locationData = await location.getLocation();
    CameraUpdate update = CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16));
    CameraUpdate zoom = CameraUpdate.zoomTo(16);
    _googleMapController.animateCamera(update);
    setState(() {});
  }

  //

  //

  void getUserData() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((ds) {
        userName = ds.data()!['name'];
      }).catchError((e) {
        userName = null;
      });
    }

    setState(() {});
  }

  void _buildListVanMarkers(List<DocumentSnapshot>? snapshot) {
    vanMarkers.clear();
    _polylines.clear();
    var count = 0;

    try {
      snapshot!.forEach((element) {
        final driverLocData = DriverLocData.fromSnapshot(element);

        if (!driverLocData.isVehicleParked &&
            driverLocData.locationsVisited.isNotEmpty) {
          final latLngList = <LatLng>[];
          driverLocData.locationsVisited.forEach((geoPoint) {
            latLngList.add(LatLng(geoPoint.latitude, geoPoint.longitude));
          });
          _polylines.add(Polyline(
              polylineId: PolylineId(count.toString()),
              points: latLngList,
              color: Colors.blue));
        }

        count += 1;
        vanMarkers.add(Marker(
            markerId: MarkerId("${count}"),
            infoWindow: InfoWindow(
              title:
                  "Waste collection van (Vehicle No. - ${driverLocData.vehicleNumber})",
            ),
            icon: truckIcon,
            position: LatLng(driverLocData.locationsVisited.last.latitude,
                driverLocData.locationsVisited.last.longitude)));

        //
      });
    } catch (e) {}
  }
}
