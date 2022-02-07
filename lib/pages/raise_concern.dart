import 'package:flutter/material.dart';
import 'package:oxon_app/models/concern.dart';
import 'package:oxon_app/pages/take_picture.dart';

import '../widgets/custom_drawer.dart';

class RaiseConcernDirect extends StatefulWidget {
  const RaiseConcernDirect({Key? key}) : super(key: key);

  static const routeName = '/raise-concern-direct';

  @override
  _RaiseConcernDirectState createState() => _RaiseConcernDirectState();
}

class _RaiseConcernDirectState extends State<RaiseConcernDirect> {
  String authorityDropdownValue = 'One';
  String issueTypeDropdownValue = 'One';

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.article_rounded),
            );
          }),
          backgroundColor: Color.fromARGB(255, 34, 90, 0),
          title: Text(
            "Raise a Concern",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/products_pg_bg.png"),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    'Concerned Authority :',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '*The authority to whom the issue should be reported.',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 25, top: 10, bottom: 30),
                    child: DropdownButtonFormField(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      hint: Text('Select'),
                      dropdownColor: Color.fromARGB(255, 34, 90, 0),
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      isExpanded: true,
                      value: authorityDropdownValue,
                      items: <String>['One', 'Two', 'Free', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          authorityDropdownValue = newValue as String;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Type of Issue :',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '*If concern is not listed, use "Custom" option.',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 25, top: 10, bottom: 30),
                    child: DropdownButtonFormField(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      hint: Text('Select'),
                      dropdownColor: Color.fromARGB(255, 34, 90, 0),
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      isExpanded: true,
                      value: issueTypeDropdownValue,
                      items: <String>['One', 'Two', 'Free', 'Four']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          issueTypeDropdownValue = newValue as String;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Description of Issue :',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '*Optional',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25, top: 10, bottom: 20),
                    width: double.infinity,
                    child: TextFormField(
                      controller: descriptionController,
                      textInputAction: TextInputAction.done,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Note : You need to click a pictures of the issue to be reported in the next screen.',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.only(right: 25),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              TakePictureScreen.routeName,
                              arguments: Concern(
                                  description: descriptionController.text,
                                  authorityType: authorityDropdownValue,
                                  issueType: issueTypeDropdownValue,
                                  image: Image.asset(
                                      'assets/images/oxon_logo.png')));
                        },
                        child: Text(
                          'Proceed',
                          style:
                              TextStyle(color: Colors.green[900], fontSize: 20),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide())))),
                  ),
                ],
              ),
            ),
          )
        ]
        )
    );
  }
}
