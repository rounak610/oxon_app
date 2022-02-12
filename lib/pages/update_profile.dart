import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  String? name;
  String? DOB;
  String? city;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.colors.oxonGreen,
          drawer: CustomDrawer(),
          appBar: CustomAppBar(context, "Update Profile"),
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
                padding:EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Please enter the following details:-" ,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                             // borderSide: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w300),
                        ),
                        onChanged: (value){
                          setState(() {
                            name=value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              //borderSide: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText: 'Enter your city name',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                          labelText: 'City',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w300),
                        ),
                        onChanged: (value){
                          setState(() {
                            city=value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            //borderSide: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText: 'Enter your DOB (DD/MM/YYYY)',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w300),
                        ),
                        onChanged: (value){
                          setState(() {
                            DOB=value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(
                            "Select your Gender",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w100),
                          ),
                          value: gender,
                          dropdownColor: Color.fromARGB(255, 34, 90, 0),
                          isExpanded: true,
                          iconSize: 26,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          items: <String>[
                            'select your gender',
                            'Male',
                            'Female',
                            'None'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            );
                          }
                          ).toList(),
                          onChanged: (value) =>
                              setState(() => this.gender = value),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 250, height: 60),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Save Details',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green[50],
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(35.0))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
