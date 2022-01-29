import 'package:flutter/material.dart';
import 'pages/welcome_pg.dart';

void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 27.0, fontWeight: FontWeight.w600),
          headline2: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(
      ),
    );
  }
}