import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oxon/models/dustbin_data.dart';
import 'package:oxon/models/loc_data.dart';
import 'package:oxon/models/toilet_data.dart';
import 'package:oxon/repositories/loc_data_repository.dart';
import 'package:oxon/size_config.dart';
import 'package:oxon/styles/button_styles.dart';
import 'package:oxon/theme/app_theme.dart';
import 'package:oxon/widgets/custom_appbar.dart';
import 'package:oxon/widgets/custom_drawer.dart';
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
  dynamic _currLocData;




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
  var cSDustbinIcon = BitmapDescriptor.defaultMarker;
  var toiletIcon = BitmapDescriptor
      .defaultMarker; //cS - crowd sourced (located by users not government)
  var cSToiletIcon = BitmapDescriptor.defaultMarker;

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
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition:
          type == "toilet" ? cameraPosition2 : cameraPosition,
          markers: setOfMarkers,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
            _controller.complete(controller);
            setState(() {});
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
        Align(

          alignment: Alignment.bottomLeft,
          child: Visibility(
              visible: shouldAskFeedback,
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: type == "toilet"
                          ? [
                        ElevatedButton(
                            onPressed: () =>
                                updateToiletBasedOnCondition(
                                    ToiletDataUpdateConditions.Helpful),
                            child: smallText("Helpful \ntoilet location")),
                        ElevatedButton(
                            onPressed: () =>
                                updateToiletBasedOnCondition(
                                    ToiletDataUpdateConditions.NotCleaned),
                            child: smallText("Toilet \nnot cleaned")),
                        ElevatedButton(
                            onPressed: () =>
                                updateToiletBasedOnCondition(
                                    ToiletDataUpdateConditions.NotPresent),
                            child: smallText("Toilet \nnot present")),
                      ]
                          : [
                        ElevatedButton(
                            onPressed: () =>
                                updateDustbinBasedOnCondition(
                                    DustbinDataUpdateConditions.Helpful),
                            child: smallText("Helpful \ndustbin location")

                        ),
                        ElevatedButton(
                            onPressed: () =>
                                updateDustbinBasedOnCondition(
                                    DustbinDataUpdateConditions
                                        .Overflowing),
                            child: smallText("Dustbin \noverflowing")),
                        ElevatedButton(
                            onPressed: () =>
                                updateDustbinBasedOnCondition(
                                    DustbinDataUpdateConditions
                                        .NotPresent),
                            child: smallText("Dustbin \nnot present")),
                      ])







                //









                //



                //







                //













                //



























              )),
        )
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _googleMapController.setMapStyle("[]");
    } else if (state == AppLifecycleState.inactive) {} else
    if (state == AppLifecycleState.paused) {} else
    if (state == AppLifecycleState.detached) {}
  }

  Future<void> onTapMarker(LocData locData, count) async {
    {
      final markerTappedLatLng =
      LatLng(locData.location.latitude, locData.location.longitude);

      if (_currMarker == markerTappedLatLng && locData.uId == uid) {
        print("in delete");
        print("del count $deleteCount");
        if (deleteCount == 1) {
          if (_currLocData != null &&
              auth.currentUser != null &&
              _currLocData?.uId == uid) {


            print("curr marker id $_currMarkerId");
            _googleMapController.hideMarkerInfoWindow(_currMarkerId!);

            if (locData.type == "toilet") {
              print('true');
              print("before ${toiletMarkers.length}");

              print('_currMarkerId $_currMarkerId');
              toiletMarkers
                  .removeWhere((element) => element.markerId == _currMarkerId);

              print("after ${toiletMarkers.length}");
            } else {
              dustbinMarkers
                  .removeWhere((element) => element.markerId == _currMarkerId);
            }
            deleteCount = 0;

            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return FutureBuilder<String>(
                  future: type == "dustbin"
                      ? repository.deleteDustbinData(_currLocData!)
                      : repository.deleteToiletData(_currLocData),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return AlertDialog(
                        content:
                        Text("Marker deleted", textAlign: TextAlign.center),
                      );
                    } else if (snapshot.hasError) {
                      return AlertDialog(
                        content: Text(
                          "Error deleting. Make sure internet is on.",
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      try {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Deleting marker... \nPlease wait...",
                                  style: AppTheme
                                      .define()
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: Colors.black),

                              ),
                              CircularProgressIndicator()
                            ],
                          ),
                        );
                      } catch (e, s) {}
                    }

                    return Text("Error deleting. Make sure internet is on.");
                  },
                );
                return AlertDialog(
                  content: Text(
                      "Error adding location. Ensure device location and internet is turned on and please try again"),
                );
              },
            );
            setState(() {});
          }
        }
        if (deleteCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Press on the marker one more time to delete it."),
            duration: Duration(seconds: 1),
          ));
          deleteCount += 1;
        }
      } else if (locData.uId == uid) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Press on the marker 2 more times to delete it."),
            duration: Duration(seconds: 1)));
      }

      if (!locData.usersVoted.contains(uid))
        shouldAskFeedback = true;
      else
        shouldAskFeedback = false;

      _currMarker = markerTappedLatLng;
      _currLocData = locData;
      _currMarkerId = MarkerId(count.toString());
      setState(() {});
    }
  }






  //





















  void setCustomMarker() async {
    dustbinIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/dustbin_1.png',
    );
    toiletIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/toilet_1.png',
    );

    cSDustbinIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/crowd_sourced_dustbin.png',
    );
    cSToiletIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(52, 52)),
      'assets/icons/crowd_sourced_toilet.png',
    );
    setState(() {});
  }

  Future<String> getCurrLocationAndAdd(String type) async {
    rewardUserOnContributingDustbinToiletLoc();
    _locationData = await location.getLocation();
    print("_loc ${_locationData!.latitude}");

    if (type == "dustbin") {
      final id = await repository.addDustbinData(
          DustbinData(locatedBy: userName != null ? userName! : "Anonymous",
              helpfulCount: 0,
              uId: uid,
              usersVoted: [uid],
              subType: "ordinary",
              type: type,
              isDisplayed: true,
              location
              : GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
              notPresentCount: 0,
              overflowingCount: 0)
      );
    } else {
      final id = await repository.addToiletData(
          ToiletData(locatedBy: userName != null ? userName! : "Anonymous",
              helpfulCount: 0,
              uId: uid,
              usersVoted: [uid],
              subType: "ordinary",
              type: type,
              isDisplayed: true,
              location
                  : GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
              notPresentCount: 0,
              notCleanedCount: 0)
      );
    }













    return type;
  }

  void moveCameraFromAddLoc(String type) {
    cameraPosition = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16);
    cameraPosition2 = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16);

    if (type == "dustbin") {
      resetCurrentData();
      _tabController.animateTo(0);
    } else {
      resetCurrentData();
      _tabController.animateTo(1);
    }

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
            "Dustbins and Toilets",
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
                            onPressed: () {
                              _tabController.animateTo(0);
                              resetCurrentData();
                            },
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              _tabController.animateTo(1);
                              resetCurrentData();
                            },
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6,
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
                            stream: repository.getStreamDustbin(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return LinearProgressIndicator();

                              _buildListDustbinMarkers(
                                  snapshot.data?.docs ?? []);

                              return CustomMap(dustbinMarkers, "dustbin");
                            }),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: repository.getStreamToilet(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            _buildListToiletMarkers(snapshot.data?.docs ?? []);

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
                                                    AppTheme
                                                        .define()
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
                                                              "\nThank you ${userName !=
                                                                  null
                                                                  ? '${userName} '
                                                                  : ''}for your contribution.\n\nOur world needs more people like you :)")
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
                      style: Theme
                          .of(context)
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
                      style: Theme
                          .of(context)
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
    setState(() {});
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
        'https://www.google.com/maps/search/?api=1&query=${_currMarker!
        .latitude},${_currMarker!.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }




  //




  //






  Marker createMarkerFromLocData(locData, count, type) {
    return Marker(
        markerId: MarkerId("${count}"),
        onTap: () => onTapMarker(locData, count),
        infoWindow: InfoWindow(
            title: type == "dustbin"
                ? "Dustbin located by ${locData.locatedBy}"
                : "Toilet located by ${locData.locatedBy}",
            snippet: locData.helpfulCount != 0
                ? "${locData.helpfulCount} people found helpful"
                : null),
        icon: locData.uId == "-999" ? (type == "dustbin"? dustbinIcon : toiletIcon) : (type == "dustbin"? cSDustbinIcon : cSToiletIcon),
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

  void resetCurrentData() {
    dustbinMarkers = {};
    toiletMarkers = {};
    _currLocData = null;
    _currMarker = null;
    _currMarkerId = null;
    shouldAskFeedback = false;
    deleteCount = 0;
    deleteMarker = null;
  }

  updateToiletBasedOnCondition(ToiletDataUpdateConditions condition) {
    final toiletData = _currLocData as ToiletData;


    toiletMarkers.removeWhere(
            (element) => element.markerId.value == _currMarkerId!.value);

    switch (condition) {
      case ToiletDataUpdateConditions.NotPresent:
        toiletData.notPresentCount = toiletData.notPresentCount + 1;
        break;

      case ToiletDataUpdateConditions.NotCleaned:
        toiletData.notCleanedCount = toiletData.notCleanedCount + 1;
        break;
      case ToiletDataUpdateConditions.Helpful:
        toiletData.helpfulCount = toiletData.helpfulCount + 1;
        break;
    }
    toiletData.usersVoted.add(uid);
    repository.updateToiletData(toiletData);
    toiletMarkers.add(
        createMarkerFromLocData(_currLocData, toiletMarkers.length + 1, type));



    shouldAskFeedback = false;
    setState(() {});

    //






    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Thank you for your feedback")));
  }

  updateDustbinBasedOnCondition(DustbinDataUpdateConditions condition) {
    final dustbinData = _currLocData as DustbinData;


    dustbinMarkers.removeWhere(
            (element) => element.markerId.value == _currMarkerId!.value);

    switch (condition) {
      case DustbinDataUpdateConditions.NotPresent:
        dustbinData.notPresentCount = dustbinData.notPresentCount + 1;
        break;

      case DustbinDataUpdateConditions.Helpful:
        dustbinData.helpfulCount = dustbinData.helpfulCount + 1;
        break;
      case DustbinDataUpdateConditions.Overflowing:
        dustbinData.overflowingCount = dustbinData.overflowingCount + 1;
        break;
    }

    shouldAskFeedback = false;
    dustbinData.usersVoted.add(uid);
    repository.updateDustbinData(dustbinData);
    dustbinMarkers.add(
        createMarkerFromLocData(_currLocData, dustbinMarkers.length + 1, type));
    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Thank you for your feedback")));


  }

  void _buildListToiletMarkers(List<DocumentSnapshot>? snapshot) {
    var count = 0;
    snapshot!.forEach((element) {
      count += 1;
      final toiletData = ToiletData.fromSnapshot(element);

      if (toiletData.isDisplayed) {
        toiletMarkers.add(Marker(
            onTap: () => onTapMarker(toiletData, count),
            markerId: MarkerId("${count}"),
            infoWindow: InfoWindow(
                title: "Toilet located by ${toiletData.locatedBy}",
                snippet: toiletData.helpfulCount != 0
                    ? "${toiletData.helpfulCount} people found helpful"
                    : null),
            icon: toiletData.uId == "-999" ? toiletIcon : cSToiletIcon,
            position: LatLng(
                toiletData.location.latitude, toiletData.location.longitude)));
      }
    });
  }

  void _buildListDustbinMarkers(List<DocumentSnapshot>? snapshot) {
    var count = 0;
    snapshot!.forEach((element) {
      count += 1;
      final dustbinData = DustbinData.fromSnapshot(element);

      if (dustbinData.isDisplayed) {
        dustbinMarkers.add(Marker(
            onTap: () => onTapMarker(dustbinData, count),
            markerId: MarkerId("${count}"),
            infoWindow: InfoWindow(
                title: "Dustbin located by ${dustbinData.locatedBy}",
                snippet: dustbinData.helpfulCount != 0
                    ? "${dustbinData.helpfulCount} people found helpful"
                    : null),
            icon: dustbinData.uId == "-999" ? dustbinIcon : cSDustbinIcon,
            position: LatLng(dustbinData.location.latitude,
                dustbinData.location.longitude)));
      }
    });
  }

  void rewardUserOnContributingDustbinToiletLoc() {
    //todo: add credits to user's wallet
    return;
  }
}

enum ToiletDataUpdateConditions { NotPresent, NotCleaned, Helpful }

enum DustbinDataUpdateConditions { NotPresent, Overflowing, Helpful }

Text smallText(String text) {
  return Text(text, style: AppTheme.define().textTheme.headline6!.copyWith(fontSize: 10),);
}

// todo: in sus mapping and van tracking, show prominent disclosure.