import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import '../models/concern.dart';

class PreviewReport extends StatefulWidget {
  const PreviewReport({Key? key}) : super(key: key);

  static const routeName = '/preview-report';

  @override
  _PreviewReportState createState() => _PreviewReportState();
}

class _PreviewReportState extends State<PreviewReport> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Concern;
    final description = args.description;
    final issueType = args.issueType;
    final image = args.image;

    return SafeArea(
        child: Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(context, "Preview Your Report", [
        Container(
          width: 105,
          height: 105,
          child: IconButton(
              onPressed: () {},
              icon: Container(
                width: 43,
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icons/shopping_cart.png"))),
              )),
        )
      ]),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Name :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Aikagra",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Mobile No. :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "99*******",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Twitter :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "@*******",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Issue :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "XXXXXXXXXXXXXXXXXXX",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Location :",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "XXXXXXXXX",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    description,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w200),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Photo Uploaded:",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "*Note: A Twitter post will be uploaded on your handle with this report tagging the involved authorities.",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 250, height: 60),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green[50],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 250, height: 60),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Share via...',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green[50],
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 250, height: 60),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Go back',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.white, width: 2),
                          primary: Color.fromARGB(255, 34, 90, 0),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0))),
                    ),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    ));
  }
}
