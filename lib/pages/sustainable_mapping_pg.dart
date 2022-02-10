import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxon_app/repositories/loc_data_repository.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class SusMapping extends StatefulWidget {
  SusMapping({Key? key}) : super(key: key); //, required this.title
  static const routeName = '/mapping-page';

  // final String title;

  @override
  _SusMappingState createState() => _SusMappingState();
}

class _SusMappingState extends State<SusMapping> with TickerProviderStateMixin {
  final LocDataRepository repository = LocDataRepository();
  Set<Marker> dustbinMarkers = {};
  Set<Marker> toiletMarkers = {};
  Completer<GoogleMapController> _controller = Completer();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle solidRoundButtonStyle = SolidRoundButtonStyle();

    return SafeArea(
      child: Scaffold(
          drawer: CustomDrawer(),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          appBar: CustomAppBar(context, "Sustainable Mapping",),
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
                          stream: repository.dustbinsGetStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              dustbinMarkers.add(Marker(
                                markerId: MarkerId("$i"),
                                infoWindow: InfoWindow(
                                  title: "Public Dustbins",
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen),
                                position: LatLng(
                                    snapshot.data!.docs[i]["location"].latitude,
                                    snapshot
                                        .data!.docs[i]["location"].longitude),
                              ));
                            }

                            return GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(26.4723125, 76.7268125),
                                  zoom: 16),
                              markers: dustbinMarkers,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            );
                          }),
                    ),
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: repository.toiletsGetStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator();

                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              toiletMarkers.add(Marker(
                                markerId: MarkerId("$i"),
                                infoWindow: InfoWindow(
                                  title: "Public Toilet",
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed),
                                position: LatLng(
                                    snapshot.data!.docs[i]["location"].latitude,
                                    snapshot
                                        .data!.docs[i]["location"].longitude),
                              ));
                            }

                            return GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(26.4723125, 76.7268125),
                                  zoom: 16),
                              markers: toiletMarkers,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            "Coming Soon",
                            style: AppTheme.define().textTheme.headline1,
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
                    onPressed: () {},
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
