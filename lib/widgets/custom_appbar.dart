import 'package:flutter/material.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/theme/app_theme.dart';

PreferredSizeWidget CustomAppBar(BuildContext context, String title,
    [List<Widget>? actions]) {
  // final toolBarHeight = 16.10 * SizeConfig.textMultiplier;

  final toolBarHeight = SizeConfig.screenHeight > 600 ? 12 * SizeConfig.responsiveMultiplier + 3 * SizeConfig.responsiveMultiplier : 12 * SizeConfig.responsiveMultiplier;
  final actionsSize = 13.3 * SizeConfig.responsiveMultiplier;
  // final toolBarHeight = 16.10 * SizeConfig.textMultiplier;
  // final toolBarHeight = 16.10 * SizeConfig.textMultiplier;
  return PreferredSize(
    preferredSize: Size.fromHeight(toolBarHeight),
    // preferredSize: Size.fromHeight(18 * SizeConfig.textMultiplier),
    // preferredSize: Size.fromHeight(20* SizeConfig.textMultiplier),
    child: Container(
      margin: SizeConfig.screenHeight > 600 ? EdgeInsets.only(top: 5.85 * SizeConfig.responsiveMultiplier) : EdgeInsets.all(0),
      // margin: EdgeInsets.only(top: 5.85 * SizeConfig.textMultiplier),
      // margin: EdgeInsets.only(top: 0 * SizeConfig.textMultiplier),
      child: AppBar(
        toolbarHeight: toolBarHeight,
        // toolbarHeight: 14.63 * SizeConfig.textMultiplier,

        actions: actions!= null ? actions : [Container(
          width: actionsSize,
          height: actionsSize,
          // width: 15.36 * SizeConfig.textMultiplier,
          // height:15.36 * SizeConfig.textMultiplier,
        )],
        // leadingWidth: 12 * SizeConfig.textMultiplier,
        leadingWidth: actionsSize,
        // leadingWidth: 15.36 * SizeConfig.textMultiplier,
        // //1080 1920
        // leadingWidth: 80,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Container(
                width: 6.29 * SizeConfig.responsiveMultiplier,
                height: 6.29 * SizeConfig.responsiveMultiplier,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icons/menu.png"))),
              )),
        ),
        bottomOpacity: 0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 34, 90, 0),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: title,
              style: AppTheme.define().textTheme.headline1),
        ),
      ),
    ),
  );
}
