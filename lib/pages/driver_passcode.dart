import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxon_app/pages/drivers_section.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import 'package:pinput/pin_put/pin_put.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_appbar.dart';

class DriverAuth extends StatefulWidget {
  const DriverAuth({Key? key}) : super(key: key);
  static const routeName = '/drivers-section';

  @override
  _DriverAuthState createState() => _DriverAuthState();
}

class _DriverAuthState extends State<DriverAuth> {

  int password = 787862;  //driver need to enter this passcode
  late int input;
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

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
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text('Enter passcode',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PinPut(
                        fieldsCount: 6,
                        textStyle: const TextStyle(
                            fontSize: 25.0, color: Colors.white),
                        eachFieldWidth: 40.0,
                        eachFieldHeight: 55.0,
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: pinPutDecoration,
                        selectedFieldDecoration: pinPutDecoration,
                        followingFieldDecoration: pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onChanged: (value){
                          setState(() {
                            input = int.parse(value); // this is the right way to convert string to int
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () async
                            {
                              try
                              {
                                if(password == input)
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DriversSection()));
                                  }
                                else if(input != password)
                                  {
                                  Fluttertoast.showToast(
                                      msg: 'Wrong passcode\n Try again!!',
                                      gravity: ToastGravity.TOP);
                                }
                                else if(input == null)
                                  {
                                    Fluttertoast.showToast(
                                        msg: 'Please enter the correct passcode',
                                        gravity: ToastGravity.TOP);
                                  }
                              }
                              catch (e)
                              {
                                print(e);
                                Fluttertoast.showToast(
                                    msg: 'Wrong passcode\n Try again!!',
                                    gravity: ToastGravity.TOP);
                              }
                            },
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
                                  borderRadius:
                                  new BorderRadius.circular(35.0))),
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
