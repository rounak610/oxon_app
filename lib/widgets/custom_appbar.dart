import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget CustomAppBar(BuildContext context, String title,
    [List<Widget>? actions]) {
  return AppBar(
    actions: actions,
    flexibleSpace: Container(),
    leadingWidth: 105,
    leading: Builder(
      builder: (context) => IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Container(
            width: 43,
            height: 43,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icons/menu.png"))),
          )),
    ),
    bottomOpacity: 0,
    toolbarHeight: 172,
    centerTitle: true,
    elevation: 0,
    backgroundColor: Color.fromARGB(255, 34, 90, 0),
    titleTextStyle: Theme.of(context).textTheme.headline1,
    title: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: title,
          style: TextStyle(fontSize: 27.0, fontFamily: "Montserrat")),
    ),
  );
}
