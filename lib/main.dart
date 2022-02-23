import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oxon_app/pages/cart_pg.dart';
import 'package:oxon_app/pages/coming_soon.dart';
import 'package:oxon_app/pages/donate_dustbin.dart';
import 'package:oxon_app/pages/driver_passcode.dart';
import 'package:oxon_app/pages/preview_report.dart';
import 'package:oxon_app/pages/products_pg.dart';
import 'package:oxon_app/pages/profile_pg.dart';
import 'package:oxon_app/pages/raise_concern.dart';
import 'package:oxon_app/pages/sign_out.dart';
import 'package:oxon_app/pages/sustainable_mapping_pg.dart';
import 'package:oxon_app/pages/take_picture.dart';
import 'package:oxon_app/pages/update_profile.dart';
import 'package:oxon_app/pages/van_tracking.dart';
import 'package:oxon_app/pages/welcome_pg.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/pages/qr_scanner_pg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

List<CameraDescription> cameras = [];
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'notifications_channel', //id
  'Notifications channel', //title
  description:
      'This channel is used for implementing the notifications feature ',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> notificationsBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  FirebaseMessaging.onBackgroundMessage(
      (message) => notificationsBackgroundHandler(message));
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          theme: AppTheme.define(),
          debugShowCheckedModeBanner: false,
          home: InitializerWidget(),
          routes: {
            RaiseConcernDirect.routeName: (context) => RaiseConcernDirect(),
            TakePictureScreen.routeName: (context) =>
                TakePictureScreen(camera: cameras[0]),
            ProfilePage.routeName: (context) => ProfilePage(),
            SusMapping.routeName: (context) => SusMapping(),
            VanTracking.routeName: (context) => VanTracking(),
            DonateDustbin.routeName: (context) => DonateDustbin(),
            ProductsPage.routeName: (context) => ProductsPage(),
            ComingSoon.routeName: (context) => ComingSoon(),
            PreviewReport.routeName: (context) => PreviewReport(),
            UpdateProfile.routeName: (context) => UpdateProfile(),
            WelcomePage.routeName: (context) => WelcomePage(),
            SignOut.routeName: (context) => SignOut(),
            QRScannerPage.routeName: ((context) => QRScannerPage()),
            DriverAuth.routeName: (context) => DriverAuth(),
            CartPage.routeName: ((context) => CartPage())
          },
        );
      });
    });
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  late FirebaseAuth _auth;
  late User? _user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(child: LinearProgressIndicator()),
          )
        : _user == null
            ? WelcomePage()
            : ProductsPage();
  }
}
