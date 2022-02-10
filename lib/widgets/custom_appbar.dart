import 'package:flutter/material.dart';

PreferredSizeWidget CustomAppBar(BuildContext context, String title,
    [List<Widget>? actions]) {
  final mQ = MediaQuery.of(context);
  final height = mQ.size.height;
  final width = mQ.size.width;

  double makeResponsiveWidth(double mWidth) {
    final ratio = mWidth / 1080 * width;
    return mWidth * ratio;
  }

  double makeResponsiveHeight(double mHeight) {
    final ratio = mHeight / 1920 * height;
    return mHeight * ratio;
  }

  return PreferredSize(
    preferredSize: Size.fromHeight(110.0),
    child: Container(
      margin: EdgeInsets.only(
          top: makeResponsiveHeight(40) > 40 ? 40 : makeResponsiveHeight(40)),
      child: AppBar(
        actions: actions!= null ? actions : [Container(
          width: makeResponsiveWidth(105) > 105 ? 105 : makeResponsiveWidth(105),
          height: makeResponsiveHeight(50) > 50 ? 50 : makeResponsiveHeight(50),
        )],
        leadingWidth:
            makeResponsiveWidth(105) > 105 ? 105 : makeResponsiveWidth(105),
        //1080 1920
        // leadingWidth: 80,
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
        toolbarHeight:
            makeResponsiveHeight(100) > 100 ? 100 : makeResponsiveHeight(100),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 34, 90, 0),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: title,
              style: TextStyle(fontSize: 27.0, fontFamily: "Montserrat")),
        ),
      ),
    ),
  );

  // return PreferredSize(
  //   preferredSize: Size.fromHeight(110.0),
  //   child: Container(
  //     margin: EdgeInsets.only(top: 40),
  //     child: AppBar(
  //       // leadingWidth: 80,
  //       leadingWidth: 105,
  //       actions: [Container(
  //         width: 105,
  //         height: 55,
  //       )],
  //       leading: Builder(
  //         builder: (context) => IconButton(
  //             onPressed: () => Scaffold.of(context).openDrawer(),
  //             icon: Container(
  //               width: 43,
  //               height: 43,
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                   image: DecorationImage(
  //                       image: AssetImage("assets/icons/menu.png"))),
  //             )),
  //       ),
  //       bottomOpacity: 0,
  //       toolbarHeight: 100,
  //       centerTitle: true,
  //       elevation: 0,
  //       backgroundColor: Color.fromARGB(255, 34, 90, 0),
  //       title: RichText(
  //         textAlign: TextAlign.center,
  //         text: TextSpan(
  //             text: title,
  //             style: TextStyle(fontSize: 27.0, fontFamily: "Montserrat")),
  //       ),
  //     ),
  //   ),
  // );
}
