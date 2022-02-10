import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oxon_app/models/loc_data.dart';
import 'package:oxon_app/repositories/loc_data_repository.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import 'package:permission_handler/permission_handler.dart' as permHandler;

class SusMapping extends StatefulWidget {
  SusMapping({Key? key}) : super(key: key); //, required this.title
  static const routeName = '/mapping-page';

  // final String title;

  @override
  _SusMappingState createState() => _SusMappingState();
}

class _SusMappingState extends State<SusMapping> with TickerProviderStateMixin {
  int selectedRadio = 1;
  String type = "dustbin";

  var userName = "Aikagra";

  var cameraPosition = CameraPosition(
      target: LatLng(26.4723125, 76.7268125),
      zoom: 16);

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      type = val == 0 ? "dustbin" : "toilet";
    });
  }

  String? value;

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _locationData = null;

  // _serviceEnabled = await location.serviceEnabled();

  final LocDataRepository repository = LocDataRepository();
  Set<Marker> dustbinMarkers = {};
  Set<Marker> toiletMarkers = {};
  Completer<GoogleMapController> _controller = Completer();
  var dustbinIcon = BitmapDescriptor.defaultMarker;
  var toiletIcon = BitmapDescriptor.defaultMarker;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _controller.complete(GoogleMap)
    _tabController = new TabController(length: 3, vsync: this);
    onLayoutDone(Duration());
    setCustomMarker();
    selectedRadio = 0;
    // dustbinIcon = BitmapDescriptor.
    // WidgetsBinding.instance?.addPostFrameCallback(onLayoutDone);
  }

  void _buildList(List<DocumentSnapshot>? snapshot) {
    var count = 0;
    snapshot!.forEach((element) {
      count += 1;
      final locData = LocData.fromSnapshot(element);
      if (locData.is_displayed) {
        if (locData.type == "dustbin") {
          dustbinMarkers.add(Marker(
              markerId: MarkerId("${count}"),
              infoWindow: InfoWindow(
                  title: "Dustbin located by ${locData.name}",
                  snippet: locData.upvote != 0
                      ? "${locData.upvote} people found helpful"
                      : null),
                icon: dustbinIcon,
                position: LatLng(locData.location.latitude, locData.location.longitude)
          
          )
          );
        } else {
          toiletMarkers.add(Marker(
              markerId: MarkerId("${count}"),
              infoWindow: InfoWindow(
                  title: "Toilet located by ${locData.name}",
                  snippet: locData.upvote != 0
                      ? "${locData.upvote} people found helpful"
                      : null),
              icon: dustbinIcon,
              position: LatLng(locData.location.latitude, locData.location.longitude)

          )
          );
        }
      }
    });
  }

  void setCustomMarker() async {
    // dustbinIcon = await _bitmapDescriptorFromSvgAsset(context, "assets/icons/svg_green_dustbin.svg");
    dustbinIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/dustbin_1.png',
    );
    toiletIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/toilet_1.png',
    );
    setState(() {});

    // ImageConfiguration(devicePixelRatio: MediaQuery.of(context).devicePixelRatio), 'assets/icons/dustbin_marker.png');
  }

  void getCurrLocationAndAdd(String type) async {
    _locationData = await location.getLocation();
    final id = await repository.addLocData(
      LocData(downvote: 0, is_displayed: true, location: GeoPoint(_locationData!.latitude!, _locationData!.longitude!), name: userName, type: type, sub_type: "ordinary", u_id: "firebase_u_id", upvote: 0)
    );
    print("The id: ${id.toString()}");

    cameraPosition = CameraPosition(target: LatLng(_locationData!.latitude!, _locationData!.longitude!), zoom: 16);
    setState(() {});
    _tabController.animateTo(0);
    final snack = SnackBar(content: Text("Location of the $type added to the map successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snack);
    print("${_locationData!.latitude}"); // WLC

  }

  void onLayoutDone(Duration timeStamp) async {
    print("on layout done called");
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

    print("_locationData");

    print((_locationData as LocationData).latitude);

    // setState required for components to react
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle solidRoundButtonStyle = SolidRoundButtonStyle();

    final mAppTheme = AppTheme.define();
    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          appBar: CustomAppBar(context, "Sustainable Mapping"),
          body: Column(
            children: [
              Container(
                child: TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 1,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                      insets: EdgeInsets.symmetric(horizontal: 50.0)),
                  controller: _tabController,
                  tabs: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(0),
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/dustbin.png"))),
                            )),
                        Text(
                          "Dustbins",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(1),
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/toilet.png"))),
                            )),
                        Text(
                          "Toilets",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(2),
                            icon: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/suggest_loc.png"))),
                            )),
                        Text(
                          "Suggest\nLocation",
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                height: (MediaQuery.of(context).size.height) * 0.4,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: repository.getStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            _buildList(snapshot.data?.docs ?? []);

                            // for (int i = 0;
                            //     i < snapshot.data!.docs.length;
                            //     i++) {
                            //   dustbinMarkers.add(Marker(
                            //     markerId: MarkerId("$i"),
                            //     infoWindow: InfoWindow(
                            //       // title: (snapshot.data!.docs[i] as Map<String, dynamic>).containsKey('name') ? "Dustbin located by $userName" : "Public Dustbin",//['name'], con
                            //       // title: "Dustbin located by ${snapshot.data!.docs[i]['name']}" ?? "Public Dustbin",//['name'], con
                            //       // title: "Dustbin located by ${snapshot.data!.docs[i]['name']}", // should be used
                            //       title: "Dustbin located by $userName",
                            //       snippet: "1k people found helpful"
                            //     ),
                            //     icon: dustbinIcon,
                            //     position: LatLng(
                            //         snapshot.data!.docs[i]["location"].latitude,
                            //         snapshot
                            //             .data!.docs[i]["location"].longitude),
                            //   ));
                            // }
                            // return Text('${_locationData != null ? _locationData!.latitude : "Not done" }');


                            return GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: cameraPosition,
                              markers: dustbinMarkers,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                // (_controller as GoogleMapController).showMarkerInfoWindow(markerId)
                                // PO: Need marker id
                              },
                            );
                          }),
                    ),
                    Text("coming soon"),
                    // Container(
                    //   child: StreamBuilder<QuerySnapshot>(
                    //       stream: repository.toiletsGetStream(),
                    //       builder: (context, snapshot) {
                    //         if (!snapshot.hasData)
                    //           return LinearProgressIndicator();
                    //
                    //         for (int i = 0;
                    //             i < snapshot.data!.docs.length;
                    //             i++) {
                    //           toiletMarkers.add(Marker(
                    //             markerId: MarkerId("$i"),
                    //             infoWindow: InfoWindow(
                    //               title: "Public Toilet",
                    //             ),
                    //             icon: BitmapDescriptor.defaultMarkerWithHue(
                    //                 BitmapDescriptor.hueRed),
                    //             position: LatLng(
                    //                 snapshot.data!.docs[i]["location"].latitude,
                    //                 snapshot
                    //                     .data!.docs[i]["location"].longitude),
                    //           ));
                    //         }
                    //
                    //         return Text(
                    //             '${_locationData != null ? _locationData!.latitude : "Not done"}');
                    //
                    //         // return GoogleMap(
                    //         //   mapType: MapType.hybrid,
                    //         //   initialCameraPosition: CameraPosition(
                    //         //       target: LatLng(26.4723125, 76.7268125),
                    //         //       zoom: 16),
                    //         //   markers: toiletMarkers,
                    //         //   onMapCreated: (GoogleMapController controller) {
                    //         //     _controller.complete(controller);
                    //         //   },
                    //         // );
                    //       }),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("What would you like to locate? ",
                                  style: mAppTheme.textTheme.headline3),
                              Row(
                                children: [
                                  Radio(
                                      visualDensity: VisualDensity.compact,
                                      value: 0,
                                      groupValue: selectedRadio,
                                      activeColor: Colors.white,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.white),
                                      onChanged: (val) =>
                                          setSelectedRadio(val as int)),
                                  Text(
                                    "Dustbin",
                                    style: mAppTheme.textTheme.headline4,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      visualDensity: VisualDensity.compact,
                                      value: 1,
                                      groupValue: selectedRadio,
                                      activeColor: Colors.white,
                                      fillColor: MaterialStateProperty.all(
                                          Colors.white),
                                      onChanged: (val) =>
                                          setSelectedRadio(val as int)),
                                  Text(
                                    "Toilet",
                                    style: mAppTheme.textTheme.headline4,
                                  )
                                ],
                              ),
                              Expanded(
                                child: Center(
                                    child: Align(
                                  alignment: Alignment.bottomCenter,
                                  // this works only when expanded
                                  // is parent
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(80, 10, 80, 5),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        getCurrLocationAndAdd(type);
                                        // location.getLocation()
                                      },
                                      child: Text(
                                        "Locate",
                                        style: mAppTheme.textTheme.headline3!
                                            .copyWith(
                                                color:
                                                    AppTheme.colors.oxonGreen),
                                      ),
                                      style: solidRoundButtonStyle,
                                    ),
                                  ),
                                )),
                              ),
                              Center(
                                child: Text(
                                  "*stand near the $type before pressing the button.",
                                  style: mAppTheme.textTheme.headline6,
                                ),
                              )
                            ],
                            //final FirebaseUser user = await auth.currentUser();
                            // final userid = user.uid;
                            // get user id somehow
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 18, 80, 18),
                child: OutlinedButton(
                    onPressed: () {
                      permHandler.openAppSettings(); // temp
                    },
                    child: Text(
                      "Guide The Way",
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Color.fromARGB(255, 34, 90, 0)),
                    ),
                    style: solidRoundButtonStyle),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 0, 80, 18),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Open In Maps",
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Color.fromARGB(255, 34, 90, 0)),
                    ),
                    style: solidRoundButtonStyle),
              ),
            ],
          )),
    );
  }
}
