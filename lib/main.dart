import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oxon/pages/cart_page.dart';
import 'package:oxon/pages/cart_pg.dart';
import 'package:oxon/pages/coming_soon.dart';
import 'package:oxon/pages/donate_dustbin.dart';
import 'package:oxon/pages/driver_passcode.dart';
import 'package:oxon/pages/preview_report.dart';
import 'package:oxon/pages/products_pg.dart';
import 'package:oxon/pages/profile_pg.dart';
import 'package:oxon/pages/qr_scanner_pg.dart';
import 'package:oxon/pages/raise_concern.dart';
import 'package:oxon/pages/sign_out.dart';
import 'package:oxon/pages/sustainable_mapping_pg.dart';
import 'package:oxon/pages/take_picture.dart';
import 'package:oxon/pages/update_profile.dart';
import 'package:oxon/pages/van_tracking.dart';
import 'package:oxon/pages/welcome_pg.dart';
import 'package:oxon/size_config.dart';
import 'package:oxon/theme/app_theme.dart';
import 'package:oxon/user_data.dart';

List<CameraDescription> cameras = [];
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'notifications_channel',
  'Notifications channel',
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
            CartPage.routeName: ((context) => CartPage()),
            CartPageNew.routeName: (context) => CartPageNew()
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
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          if (UserData.user == null) {
            return WelcomePage();
          } else {
            if (UserData.mobileNumber != null) {
              return SusMapping();
            } else {
              return UpdateProfile();
            }
          }
        }
        return Scaffold(
            backgroundColor: AppTheme.colors.oxonGreen,
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.all(16),child: Image(image: AssetImage("assets/images/oxon_logo.png"), width: SizeConfig.responsiveMultiplier * 26,)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Empowering Happy and Healthy Life", style: AppTheme.define().textTheme.headline6, textAlign: TextAlign.center,),
                    )
                  ],
                )));
      },
      future: UserData().getUserData(),
    );
  }
}
