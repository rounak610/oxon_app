import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './pages/welcome_pg.dart';
import './pages/raise_concern.dart';
import './pages/take_picture.dart';
import './pages/sustainable_mapping_pg.dart';
import './pages/profile_pg.dart';
import './pages/donate_dustbin.dart';
import './pages/products_pg.dart';
import './pages/coming_soon.dart';


List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }

  runApp(MyApp());}


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
      home: WelcomePage(),
      routes: {
        RaiseConcernDirect.routeName: (context) => RaiseConcernDirect(),
        TakePictureScreen.routeName: (context) => TakePictureScreen(camera: cameras[0]),
        ProfilePage.routeName: (context) => ProfilePage(title: 'John Doe'), //Change later
        SusMapping.routeName: (context) => SusMapping(title: 'Title'),     //Change Later
        DonateDustbin.routeName: (context) => DonateDustbin(),
        ProductsPage.routeName: (context) => ProductsPage(),
        ComingSoon.routeName: (context) => ComingSoon()
      },
    );
  }
}
