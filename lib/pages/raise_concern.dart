import 'package:flutter/material.dart';
import 'package:oxon_app/models/concern.dart';
import 'package:oxon_app/pages/take_picture.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import '../widgets/custom_drawer.dart';

class RaiseConcernDirect extends StatefulWidget {
  const RaiseConcernDirect({Key? key}) : super(key: key);

  static const routeName = '/raise-concern-direct';

  @override
  _RaiseConcernDirectState createState() => _RaiseConcernDirectState();
}

class _RaiseConcernDirectState extends State<RaiseConcernDirect> {
  String? issueSubTypeDropdownValue;
  String? issueTypeDropdownValue;
  String? value;

  List<String> mainIssueTypes = [
    'Select',
    'Dustbin',
    'Sewerage Problem',
    'Road Light',
    'Road Related Problems',
    'Water Related Problems',
    'Enroachment',
    'Other'
  ];

  List<String> selectSubTypeList(String issueType) {
    if (issueType == 'Dustbin') return dustbin;
    if (issueType == 'Sewerage Problem') return sewer;
    if (issueType == 'Road Light') return roadLight;
    if (issueType == 'Road Related Problems') return roadRelated;
    if (issueType == 'Water Related Problems') return waterRelated;
    if (issueType == 'Enroachment') return enroachment;

    return <String>['Other'];
  }

  List<String> select = ['Other'];
  List<String> dustbin = [
    'Dustbin unavailable in locality',
    'Dustbins overfilled',
    'Non- Classification of Dustbins',
    'Place of Dustbins',
    'Not managed properly',
    'Other (Please specify)'
  ];
  List<String> sewer = [
    'Overfilled drainage systems',
    'Lack of proper sewarage system',
    'Uncleaned sewerage',
    'Leakage of sewerage chambers',
    'Sewerage pipes',
    'Other (Please specify)'
  ];
  List<String> roadLight = [
    'Unavailability of road lights',
    'Defect in road lights',
    'Lights at always ON Mode',
    'Other (Please specify)'
  ];
  List<String> roadRelated = [
    'Roads are broken or unbuilt',
    'Narrow roads',
    'Too many speed breakers on the road',
    'Unavailability of roads',
    'Encroached roads',
    'Other (Please specify)'
  ];
  List<String> waterRelated = [
    'No or very little water supply',
    'Irregular schedule of water supply',
    'Undrinkable & dirty water',
    'Leakage of pipes',
    'Water & Electricity supply Balance',
    'Other (Please specify)'
  ];
  List<String> enroachment = [
    'Encroachment over private property',
    'Encroachment over public property',
    'Encroachment over roads',
    'Built of stairs & Ramp',
    'Absence of Parking',
    'Absence of property documentation',
    'Other (Please specify)'
  ];
  List<String> other = ['Other'];

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.colors.oxonGreen,
        drawer: CustomDrawer(),
        appBar: CustomAppBar(context, "Raise a Concern"),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
              content: Text('Press again to exit the app'),
              duration: Duration(seconds: 2)),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/products_pg_bg.png"),
                      fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
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
                      '*If concern is not listed, use "Other" option.',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 25, 5),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                            value: issueTypeDropdownValue,
                            dropdownColor: Color.fromARGB(255, 34, 90, 0),
                            isExpanded: true,
                            iconSize: 26,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items: mainIssueTypes
                                .map((String issueTypeDropdownValue) {
                              return DropdownMenuItem<String>(
                                value: issueTypeDropdownValue,
                                child: Text(
                                  issueTypeDropdownValue,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (issueTypeDropdownValue) => setState(
                                () => this.issueTypeDropdownValue =
                                    issueTypeDropdownValue),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Issue Subtype :',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '*Provide a few more details.',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 25, 5),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                            value: issueSubTypeDropdownValue,
                            dropdownColor: Color.fromARGB(255, 34, 90, 0),
                            isExpanded: true,
                            iconSize: 26,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items: selectSubTypeList(
                                    issueTypeDropdownValue == null
                                        ? 'Select'
                                        : issueTypeDropdownValue as String)
                                .map((String issueSubTypeDropdownValue) {
                              return DropdownMenuItem<String>(
                                value: issueSubTypeDropdownValue,
                                child: Text(
                                  issueSubTypeDropdownValue,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                            onChanged: (issueSubTypeDropdownValue) => setState(
                                () => this.issueSubTypeDropdownValue =
                                    issueSubTypeDropdownValue),
                          ),
                        ),
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
                                    description:
                                        descriptionController.text == null
                                            ? 'No description'
                                            : descriptionController.text,
                                    authorityType:
                                        issueSubTypeDropdownValue == null
                                            ? 'Not selected'
                                            : issueSubTypeDropdownValue,
                                    issueType: issueTypeDropdownValue == null
                                        ? 'Not selected'
                                        : issueTypeDropdownValue,
                                    imagePath: 'assets/images/oxon_logo.png'));
                          },
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                                color: Colors.green[900], fontSize: 20),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
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
          ]),
        ));
  }
}
