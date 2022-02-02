import 'package:flutter/material.dart';
import 'package:oxon_app/styles/button_styles.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class SusMapping extends StatefulWidget {
  SusMapping({Key? key, required this.title}) : super(key: key);
  static const routeName = '/mapping-page';

  final String title;

  @override
  _SusMappingState createState() => _SusMappingState();
}

class _SusMappingState extends State<SusMapping> with TickerProviderStateMixin {
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
          backgroundColor: Color.fromARGB(255, 34, 90,
              0), // add this to remove the line green between appbar and body
          appBar: CustomAppBar(context, widget.title),
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
                height: 100,
                child: TabBarView(
                  // TODO: add map here
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
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
                            onPressed: () {},
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
                            onPressed: () {},
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
                margin: EdgeInsets.fromLTRB(80, 50, 80, 18),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Guide The Way",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    style: solidRoundButtonStyle),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 0, 80, 18),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Open In Maps",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    style: solidRoundButtonStyle),
              ),
            ],
          )),
    );
  }
}
