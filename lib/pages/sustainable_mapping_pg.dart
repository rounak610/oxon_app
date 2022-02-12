import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oxon_app/models/loc_data.dart';
import 'package:oxon_app/pages/coming_soon.dart';
import 'package:oxon_app/repositories/loc_data_repository.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import 'package:permission_handler/permission_handler.dart' as permHandler;

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

  void getCurrLocationAndAdd(String type) async {
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

    cameraPosition = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 16);
    setState(() {});
    if (type == "dustbin")
      _tabController.animateTo(0);
    else
      _tabController.animateTo(1);

    final snack = SnackBar(
        content: Text("Location of the $type added to the map successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snack);
    print("${_locationData!.latitude}");
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
            "Dustbin and Toilets",
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

                              return GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: cameraPosition,
                                markers: dustbinMarkers,
                                onMapCreated: (GoogleMapController controller) {
                                  _googleMapController = controller;
                                  _controller.complete(controller);
                                },
                              );
                            }),
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
                            );
                          }),
                      Padding(
                        padding:
                            EdgeInsets.all(1 * SizeConfig.responsiveMultiplier),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                                1.2 * SizeConfig.responsiveMultiplier),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                      "What are you volunteering to locate?",
                                      style: mAppTheme.textTheme.headline3),
                                ),
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
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          11.71 *
                                              SizeConfig.responsiveMultiplier,
                                          1.46 *
                                              SizeConfig.responsiveMultiplier,
                                          11.71 *
                                              SizeConfig.responsiveMultiplier,
                                          0.73 *
                                              SizeConfig.responsiveMultiplier),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Adding the location...")));
                                          getCurrLocationAndAdd(type);
                                        },
                                        child: Text(
                                          "Locate",
                                          style: mAppTheme.textTheme.headline3!
                                              .copyWith(
                                                  color: AppTheme
                                                      .colors.oxonGreen),
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
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ComingSoon.routeName);
                    },
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
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ComingSoon.routeName);
                    },
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
}
