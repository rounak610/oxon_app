import 'package:flutter/material.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);
  static const routeName = '/coming-soon';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Feature not available'),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/products_pg_bg.png"),
                    fit: BoxFit.cover)),
          ),
          Center(child: Text('Coming Soon!',style: TextStyle(color: Colors.white,fontSize: 30),))
        ],
      ),
    );
  }
}
