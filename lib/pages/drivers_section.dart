import 'package:flutter/material.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

import '../theme/app_theme.dart';
class DriversSection extends StatefulWidget {
  const DriversSection({Key? key}) : super(key: key);

  @override
  _DriversSectionState createState() => _DriversSectionState();
}

class _DriversSectionState extends State<DriversSection> {
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

                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
