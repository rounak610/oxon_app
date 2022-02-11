import 'package:flutter/material.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/theme/app_theme.dart';

PreferredSizeWidget AppBarotpscreen(BuildContext context, String title,
    [List<Widget>? actions]) {
  final toolBarHeight = SizeConfig.screenHeight > 600
      ? 12 * SizeConfig.responsiveMultiplier +
          3 * SizeConfig.responsiveMultiplier
      : 12 * SizeConfig.responsiveMultiplier;
  final actionsSize = 13.3 * SizeConfig.responsiveMultiplier;

  return PreferredSize(
    preferredSize: Size.fromHeight(toolBarHeight),
    child: Container(
      margin: SizeConfig.screenHeight > 600
          ? EdgeInsets.only(top: 5.85 * SizeConfig.responsiveMultiplier)
          : EdgeInsets.all(0),
      child: AppBar(
        toolbarHeight: toolBarHeight,
        actions: actions != null
            ? actions
            : [
                Container(
                  width: actionsSize,
                  height: actionsSize,
                )
              ],
        leadingWidth: actionsSize,
        bottomOpacity: 0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 34, 90, 0),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: title, style: AppTheme.define().textTheme.headline1),
        ),
      ),
    ),
  );
}
