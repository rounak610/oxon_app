import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? userName;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;

  int selectedRadio = 1;
  String type = "dustbin";

  var cameraPosition = CameraPosition(
      target: LatLng(26.478196293732722, 76.73010114580393), zoom: 15);
  var cameraPosition2 = CameraPosition(
      target: LatLng(26.475905253817444, 76.72756981104612), zoom: 15.5);

  LatLng? _currMarker;
  MarkerId? _currMarkerId;
  LocData? _currLocData;

  var shouldAskFeedback = false;

  var deleteCount = 0;
  Marker? deleteMarker;

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
    getUserData();
    WidgetsBinding.instance?.addObserver(this);
    _tabController = new TabController(length: 3, vsync: this);
    onLayoutDone(Duration());
    setCustomMarker();
    selectedRadio = 0;
  }

  Widget CustomMap(Set<Marker> setOfMarkers, String type) {
    return Stack(
      children: [
        GoogleMap(
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition:
              type == "toilet" ? cameraPosition2 : cameraPosition,
          markers: setOfMarkers,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
            _controller.complete(controller);
          },
          onTap: (loc) {
            deleteCount = 0;
            deleteMarker = null;
            shouldAskFeedback = false;
            _currMarker = null;
            _currMarkerId = null;
            setState(() {});
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: Positioned(
            top: 20,
            right: 20,
            child: IconButton(
                iconSize: 8.45 * SizeConfig.responsiveMultiplier,
                onPressed: () => goToCurrLoc(),
                icon: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/icons/bigger_gray_bg.png"))),
                )),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Visibility(
              visible: shouldAskFeedback,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          thankForFeedback();

                          if (type == "dustbin") {
                            dustbinMarkers.removeWhere(
                                (element) => element.markerId == _currMarkerId);
                            _currLocData!.upvote = _currLocData!.upvote + 1;
                            repository.updateLocData(_currLocData!);
                            dustbinMarkers.add(createMarkerFromLocData(
                                _currLocData, dustbinMarkers.length + 1, type));
                            setState(() {});
                          } else {
                            toiletMarkers.removeWhere(
                                (element) => element.markerId == _currMarkerId);
                            _currLocData!.upvote = _currLocData!.upvote + 1;
                            repository.updateLocData(_currLocData!);
                            toiletMarkers.add(createMarkerFromLocData(
                                _currLocData, toiletMarkers.length + 1, type));
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: [
                            Text("Helpful\n$type location ",
                                style: TextStyle(fontSize: 10)),
                            Icon(Icons.arrow_circle_up),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () {
                          thankForFeedback();

                          if (type == "dustbin") {
                            dustbinMarkers.removeWhere(
                                (element) => element.markerId == _currMarkerId);
                            _currLocData!.downvote = _currLocData!.downvote + 1;
                            repository.updateLocData(_currLocData!);
                            dustbinMarkers.add(createMarkerFromLocData(
                                _currLocData, dustbinMarkers.length + 1, type));
                            setState(() {});
                          } else {
                            toiletMarkers.removeWhere(
                                (element) => element.markerId == _currMarkerId);
                            _currLocData!.downvote = _currLocData!.downvote + 1;
                            repository.updateLocData(_currLocData!);
                            toiletMarkers.add(createMarkerFromLocData(
                                _currLocData, toiletMarkers.length + 1, type));
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: [
                            Text("Unhelpful\n$type location ",
                                style: TextStyle(fontSize: 10)),
                            Icon(Icons.arrow_circle_down),
                          ],
                        ))
                  ],
                ),
              )),
        )
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

  void onTapMarker(LocData locData, count) {
    {
      final markerTappedLatLng =
          LatLng(locData.location.latitude, locData.location.longitude);

      if (_currMarker == markerTappedLatLng && locData.u_id == uid) {
        if (deleteCount == 1) {
          if (_currLocData != null &&
              auth.currentUser != null &&
              _currLocData?.u_id == uid) {
            repository.deleteLocData(_currLocData!);

            if (locData.type == "toilet") {
              toiletMarkers
                  .removeWhere((element) => element.markerId == _currMarkerId);
            } else {
              dustbinMarkers
                  .removeWhere((element) => element.markerId == _currMarkerId);
            }
            setState(() {});
          }
          deleteCount = 0;
        }
        if (deleteCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Press on the marker one more time to delete it.")));
          deleteCount += 1;
        }
      }

      //

      shouldAskFeedback = true;
      _currMarker = markerTappedLatLng;
      _currLocData = locData;
      _currMarkerId = MarkerId(count.toString());
      setState(() {});
    }
  }

  void _buildList(List<DocumentSnapshot>? snapshot) {
    var count = 0;
    snapshot!.forEach((element) {
      count += 1;
      final locData = LocData.fromSnapshot(element);

      if (locData.is_displayed) {
        if (locData.type == "dustbin") {
          dustbinMarkers
              .add(createMarkerFromLocData(locData, count, locData.type));
        } else {
          toiletMarkers.add(Marker(
              onTap: () => onTapMarker(locData, count),
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
    _locationData = await location.getLocation();

    //

    final id = await repository.addLocData(LocData(
        downvote: 0,
        is_displayed: true,
        location: GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
        name: userName != null ? userName! : "Anonymous",
        type: type,
        sub_type: "ordinary",
        u_id: uid,
        upvote: 0));

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
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: repository.getStream(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return LinearProgressIndicator();

                              _buildList(snapshot.data?.docs ?? []);

                              return CustomMap(dustbinMarkers, "dustbin");
                            }),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: repository.getStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            _buildList(snapshot.data?.docs ?? []);

                            return CustomMap(toiletMarkers, "toilet");
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
                                                              "\nThank you ${userName != null ? '${userName} ' : ''}for your contribution.\n\nOur world needs more people like you :)")
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
                                                  } catch (e, s) {}
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
    _locationData = await location.getLocation();
    CameraUpdate update = CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16));
    CameraUpdate zoom = CameraUpdate.zoomTo(16);
    _googleMapController.animateCamera(update);
    shouldAskFeedback = false;
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void thankForFeedback() {
    shouldAskFeedback = false;
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Thank you for your feedback")));
  }

  Marker createMarkerFromLocData(locData, count, type) {
    return Marker(
        markerId: MarkerId("${count}"),
        onTap: () => onTapMarker(locData, count),
        infoWindow: InfoWindow(
            title: type == "dustbin"
                ? "Dustbin located by ${locData.name}"
                : "Toilet located by ${locData.name}",
            snippet: locData.upvote != 0
                ? "${locData.upvote} people found helpful"
                : null),
        icon: type == "dustbin" ? dustbinIcon : toiletIcon,
        position:
            LatLng(locData.location.latitude, locData.location.longitude));
  }

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
}
