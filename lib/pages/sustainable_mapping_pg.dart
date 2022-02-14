import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oxon_app/models/loc_data.dart';
import 'package:oxon_app/repositories/loc_data_repository.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class SusMapping extends StatefulWidget {
  SusMapping({Key? key}) : super(key: key);
  static const routeName = '/mapping-page';

  @override
  _SusMappingState createState() => _SusMappingState();
}

class _SusMappingState extends State<SusMapping>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int selectedRadio = 1;
  String type = "dustbin";

  var userName = "User Name";

  var cameraPosition =
      CameraPosition(target: LatLng(26.4723125, 76.7268125), zoom: 16);

  LatLng? _currMarker;
  MarkerId? _currMarkerId;

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

  final LocDataRepository repository = LocDataRepository();
  Set<Marker> dustbinMarkers = {};
  Set<Marker> toiletMarkers = {};
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;

  var dustbinIcon = BitmapDescriptor.defaultMarker;
  var toiletIcon = BitmapDescriptor.defaultMarker;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
    _tabController = new TabController(length: 3, vsync: this);
    onLayoutDone(Duration());
    setCustomMarker();
    selectedRadio = 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("APP_STATE: $state");

    if (state == AppLifecycleState.resumed) {
      print("in xyz resumed");
    } else if (state == AppLifecycleState.inactive) {
      print("in xyz inactive");
    } else if (state == AppLifecycleState.paused) {
      print("in xyz paused");
    } else if (state == AppLifecycleState.detached) {
      print("in xyz detached");
    }
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
              onTap: () {
                _currMarker = LatLng(
                    locData.location.latitude, locData.location.longitude);
                _currMarkerId = MarkerId(count.toString());
              },
              infoWindow: InfoWindow(
                  title: "Dustbin located by ${locData.name}",
                  snippet: locData.upvote != 0
                      ? "${locData.upvote} people found helpful"
                      : null),
              icon: dustbinIcon,
              position: LatLng(
                  locData.location.latitude, locData.location.longitude)));
        } else {
          toiletMarkers.add(Marker(
              markerId: MarkerId("${count}"),
              infoWindow: InfoWindow(
                  title: "Toilet located by ${locData.name}",
                  snippet: locData.upvote != 0
                      ? "${locData.upvote} people found helpful"
                      : null),
              icon: toiletIcon,
              position: LatLng(
                  locData.location.latitude, locData.location.longitude)));
        }
      }
    });
  }

  void setCustomMarker() async {
    dustbinIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/dustbin_1.png',
    );
    toiletIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/toilet_1.png',
    );
    setState(() {});
  }

  Future<String> getCurrLocationAndAdd(String type) async {
    print('in future asyn getcurrloc and add');
    _locationData = await location.getLocation();
    final id = await repository.addLocData(LocData(
        downvote: 0,
        is_displayed: true,
        location: GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
        name: userName,
        type: type,
        sub_type: "ordinary",
        u_id: "firebase_u_id",
        upvote: 0));
    print("The id: ${id.toString()}");

    // final snack = SnackBar(
    //     content: Text("Location of the $type added to the map successfully"));
    // ScaffoldMessenger.of(context).showSnackBar(snack);
    // print("${_locationData!.latitude}");

    return type;
  }

  void moveCameraFromAddLoc(String type) {
    cameraPosition = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16);
    setState(() {});
    if (type == "dustbin")
      _tabController.animateTo(0);
    else
      _tabController.animateTo(1);
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

    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle solidRoundButtonStyle = SolidRoundButtonStyle();
    final ButtonStyle solidRoundButtonStyleMinSize = SolidRoundButtonStyle(Size(
        146.32 * SizeConfig.responsiveMultiplier,
        7.61 * SizeConfig.responsiveMultiplier));

    final mAppTheme = AppTheme.define();
    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          appBar: CustomAppBar(
            context,
            "Sustainable Mapping",
          ),
          body: Column(
            children: [
              Container(
                child: TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 1,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                      insets: EdgeInsets.symmetric(
                          horizontal: 7.32 * SizeConfig.responsiveMultiplier)),
                  controller: _tabController,
                  tabs: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () => _tabController.animateTo(0),
                            icon: Container(
                              width: 4.10 * SizeConfig.responsiveMultiplier,
                              height: 4.10 * SizeConfig.responsiveMultiplier,
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
                              width: 4.10 * SizeConfig.responsiveMultiplier,
                              height: 4.10 * SizeConfig.responsiveMultiplier,
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
                              width: 4.10 * SizeConfig.responsiveMultiplier,
                              height: 4.10 * SizeConfig.responsiveMultiplier,
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
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      top: 3.51 * SizeConfig.responsiveMultiplier),
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: repository.getStream(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return LinearProgressIndicator();

                                  _buildList(snapshot.data?.docs ?? []);

                                  return GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: cameraPosition,
                                    markers: dustbinMarkers,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _googleMapController = controller;
                                      _controller.complete(controller);
                                    },
                                    onTap: (loc) {
                                      _currMarker = null;
                                      _currMarkerId = null;
                                    },
                                  );
                                }),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Positioned(
                              top: 20,
                              right: 20,
                              child: IconButton(
                                  iconSize:
                                      8.45 * SizeConfig.responsiveMultiplier,
                                  onPressed: () => goToCurrLoc(),
                                  icon: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/icons/bigger_gray_bg.png"))),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: repository.getStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            _buildList(snapshot.data?.docs ?? []);

                            return GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: cameraPosition,
                                markers: toiletMarkers,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                onTap: (loc) {
                                  _currMarker = null;
                                  _currMarkerId = null;
                                });
                          }),
                      Padding(
                        padding:
                            EdgeInsets.all(1 * SizeConfig.responsiveMultiplier),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                                2 * SizeConfig.responsiveMultiplier),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("What are you volunteering to locate?",
                                    style: mAppTheme.textTheme.headline3),
                                SizedBox(
                                  height: SizeConfig.responsiveMultiplier,
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        visualDensity: VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
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
                                        visualDensity: VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity,
                                        ),
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
                                // AlertDialog(
                                //   titleTextStyle: AppTheme.define()
                                //       .textTheme
                                //       .headline1!
                                //       .copyWith(color: Colors.black),
                                //   title: const Text('Thank you!'),
                                //   content: Container(
                                //     height:
                                //     SizeConfig.screenHeight * 0.5,
                                //     child: Column(
                                //       mainAxisAlignment:
                                //       MainAxisAlignment.center,
                                //       crossAxisAlignment:
                                //       CrossAxisAlignment.center,
                                //       children: [
                                //         Container(
                                //           height: SizeConfig
                                //               .screenHeight *
                                //               0.25,
                                //           decoration: BoxDecoration(
                                //               image: DecorationImage(
                                //                   image: AssetImage(
                                //                       "assets/images/badge_final.jpeg"))),
                                //         ),
                                //         Text(
                                //             "\nThank you <username> for your contribution.\n\nOur world needs more people like you :)")
                                //       ],
                                //     ),
                                //   ),
                                //   actions: <Widget>[
                                //     TextButton(
                                //       onPressed: () {
                                //         Navigator.pop(context, 'OK');
                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(SnackBar(
                                //             content: Text(
                                //               "Adding the location...",
                                //             )));
                                //         getCurrLocationAndAdd(type);
                                //       },
                                //       child: Center(
                                //           child: Text(
                                //               'Show added location on map',
                                //               style: AppTheme.define()
                                //                   .textTheme
                                //                   .headline5!
                                //                   .copyWith(
                                //                   color: AppTheme
                                //                       .colors
                                //                       .oxonGreen))),
                                //       style: solidRoundButtonStyle,
                                //     ),
                                //   ],
                                // ),
                                Container(
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FutureBuilder<String>(
                                              future:
                                                  getCurrLocationAndAdd(type),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return AlertDialog(
                                                    titleTextStyle:
                                                        AppTheme.define()
                                                            .textTheme
                                                            .headline1!
                                                            .copyWith(
                                                                color: Colors
                                                                    .black),
                                                    title: const Text(
                                                        'Thank you!'),
                                                    content: Container(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.5,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: SizeConfig
                                                                    .screenHeight *
                                                                0.25,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/images/badge_final.jpeg"))),
                                                          ),
                                                          Text(
                                                              "\nThank you <username> for your contribution.\n\nOur world needs more people like you :)")
                                                          // todo: add user name here
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, 'OK');
                                                          moveCameraFromAddLoc(
                                                              type);
                                                        },
                                                        child: Center(
                                                            child: Text(
                                                                'Show added location on map',
                                                                style: AppTheme
                                                                        .define()
                                                                    .textTheme
                                                                    .headline5!
                                                                    .copyWith(
                                                                        color: AppTheme
                                                                            .colors
                                                                            .oxonGreen))),
                                                        style:
                                                            solidRoundButtonStyle,
                                                      ),
                                                    ],
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "Error adding location. Ensure device location and internet is turned on and please try again"),
                                                  );
                                                } else {
                                                  try {
                                                    return AlertDialog(
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Adding ${type} on map...\nPlease wait..",
                                                            style: AppTheme
                                                                    .define()
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          CircularProgressIndicator()
                                                        ],
                                                      ),
                                                    );
                                                  } catch (e, s) {
                                                    print(s);
                                                  }
                                                }
                                                return Text(
                                                    "Error fetching location. Ensure device location and internet is turned on and please try again");
                                              },
                                            );
                                            return AlertDialog(
                                              content: Text(
                                                  "Error adding location. Ensure device location and internet is turned on and please try again"),
                                            );
                                          },
                                        );
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
                                ),
                                Center(
                                  child: Text(
                                    "*stand near the $type before pressing the button.",
                                    style: mAppTheme.textTheme.headline6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    11.71 * SizeConfig.responsiveMultiplier,
                    2.63 * SizeConfig.responsiveMultiplier,
                    11.71 * SizeConfig.responsiveMultiplier,
                    2.63 * SizeConfig.responsiveMultiplier),
                child: OutlinedButton(
                    onPressed: () => _launchMapUrl(),
                    child: Text(
                      "Guide The Way",
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Color.fromARGB(255, 34, 90, 0)),
                    ),
                    style: solidRoundButtonStyleMinSize),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    11.71 * SizeConfig.responsiveMultiplier,
                    0,
                    11.71 * SizeConfig.responsiveMultiplier,
                    2.63 * SizeConfig.responsiveMultiplier),
                child: OutlinedButton(
                    onPressed: () => _openInMaps(),
                    child: Text(
                      "Open In Maps",
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Color.fromARGB(255, 34, 90, 0)),
                    ),
                    style: solidRoundButtonStyleMinSize),
              ),
            ],
          )),
    );
  }

  goToCurrLoc() async {
    // update current location
    // update camera
    _locationData = await location.getLocation();
    CameraUpdate update = CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16));
    CameraUpdate zoom = CameraUpdate.zoomTo(16);
    _googleMapController.animateCamera(update);
    // _googleMapController.moveCamera(update);
  }

  void _launchMapUrl() async {
    if (_currMarkerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No dustbin/toilet selected yet.")));
      return;
    }
    _locationData = await location.getLocation();
    String mapOptions = [
      'origin=${_locationData!.latitude},${_locationData!.longitude}',
      'destination=${_currMarker!.latitude},${_currMarker!.longitude}',
      'dir_action=navigate'
    ].join('&');

    final url = 'https://www.google.com/maps/dir/?api=1&$mapOptions';
    print(url);
    print("above url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openInMaps() async {
    if (_currMarkerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No dustbin/toilet selected yet.")));
      return;
    }
    _locationData = await location.getLocation();

    final url =
        'https://www.google.com/maps/search/?api=1&query=${_currMarker!.latitude},${_currMarker!.longitude}';
    print(url);
    print("above url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
