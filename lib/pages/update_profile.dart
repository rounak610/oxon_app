import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oxon_app/models/mobile_number.dart';
import 'package:oxon_app/pages/profile_pg.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import 'package:date_field/date_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _UpdateProfileState extends State<UpdateProfile> {

  late String email;
  late String name;
  late String city;
  late String mobile;
  String? gender;
  DateTime? DOB;

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
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        onChanged: (value)
                        {
                          setState(() {
                            name=value;
                          });
                        },
                        validator: (value)
                        {
                          if(value==null)
                          {
                            return 'Please enter your name';
                          }
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        maxLength: 10,
                        autofocus: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            // borderSide: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          hintText: 'Enter your mobile number',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        onChanged: (value)
                        {
                          setState(() {
                            mobile=value;
                          });
                        },
                        validator: (value)
                        {
                          if(value==null)
                          {
                            return 'Please enter your mobile number';
                          }
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          '*Enter the same number that you used for login',
                          style: TextStyle(color: Colors.white, fontSize: 15, ),
                        ),
                      ),
                      SizedBox(
                        height: 34,
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
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        onChanged: (value)
                        {
                          setState(() {
                            city=value;
                          }
                          );
                        },
                        validator: (value)
                        {
                          if(value==null)
                          {
                            return 'Please enter your city name';
                          }
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      DateTimeFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            //borderSide: BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hintText: 'Select your date of birth',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                          suffixIcon: Icon(Icons.event_outlined,
                          color: Colors.white,
                          ),
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,

                        onDateSelected: (DateTime value)
                        {
                          setState(() {
                            DOB=value;
                          });
                        },
                        validator: (DateTime? e) {
                          if(e==null)
                            {
                              return 'Please enter your date of birth';
                            }
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
                                fontSize: 20,
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
                              setState(() => this.gender = value!),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                                width: 250, height: 60),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Processing data....'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .add({
                                  'name':name,
                                  'mobile':mobile,
                                  'gender': gender,
                                  'DOB': DOB,
                                  'city':city,
                                }).then((value) {
                                  if (value != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  }
                                }).catchError((e) {
                                  print(e);
                                });
                              },
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
