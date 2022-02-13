import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);
  static const routeName = '/coming-soon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.oxonGreen,
      appBar: CustomAppBar(context, 'Feature not available'),
      drawer: CustomDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(content: Text('Press again to exit the app'),duration: Duration(seconds:2)),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/products_pg_bg.png"),
                      fit: BoxFit.cover)),
            ),
            Center(
                child: Text(
              'Coming Soon!',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ))
          ],
        ),
      ),
    );
  }
}
