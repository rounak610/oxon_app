import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon/pages/product_detail.dart';
import 'package:oxon/size_config.dart';
import 'package:oxon/theme/app_theme.dart';
import 'package:oxon/theme/colors.dart';
import 'package:oxon/widgets/custom_appbar.dart';

import '../widgets/custom_drawer.dart';
import 'cart_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  static const routeName = '/products-page';

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

var scaffoldKey = GlobalKey<ScaffoldState>();

class _ProductsPageState extends State<ProductsPage> {
  List<dynamic>? slide_images;

  final CollectionReference _productReference =
      FirebaseFirestore.instance.collection('Products');
  bool plant = true;
  bool other = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _fetch() async {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('side_show_images')
            .doc('slide_images')
            .get()
            .then((ds) {
          print(ds);
          slide_images = ds.data()!['images'];
        }).catchError((e) {
          print(e);
        });
      }
    }

    return SafeArea(
        child: Scaffold(
            drawer: CustomDrawer(),
            appBar: CustomAppBar(context, "Let's Shop", [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPageNew()),
                  );
                },
                child: Container(
                    width: 105,
                    height: 105,
                    child: Container(
                      width: 6.29 * SizeConfig.responsiveMultiplier,
                      height: 6.29 * SizeConfig.responsiveMultiplier,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/icons/shopping_cart.png"))),
                    )),
              ),
            ]),
            backgroundColor: Color.fromARGB(255, 34, 90, 0),
            body: FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  return DoubleBackToCloseApp(
                    snackBar: const SnackBar(
                        content: Text('Press again to exit the app'),
                        duration: Duration(seconds: 2)),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: Image.asset(
                                          'assets/images/products_pg_bg.png')
                                      .image,
                                  fit: BoxFit.cover)),
                        ),
                        FutureBuilder<QuerySnapshot>(
                            future: _productReference.get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Scaffold(
                                  body: Center(
                                    child: Text("Error Loading products"),
                                  ),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ListView(
                                  padding: EdgeInsets.only(
                                    top: 30.0,
                                    bottom: 20.0,
                                  ),
                                  children: snapshot.data!.docs.map((document) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                      name:
                                                          "${document.get('name')}",
                                                      ID: document.id,
                                                      description:
                                                          "${document.get('description')}",
                                                      image:
                                                          document.get('image'),
                                                      price:
                                                          document.get('price'),
                                                      delivery: document
                                                          .get('delivery'),
                                                      isplant: document
                                                          .get('isplant'),
                                                    )));
                                      },
                                      child: Container(
                                        height: 210.0,
                                        decoration: BoxDecoration(
                                          color: AppColors().oxonOffWhite,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 24.0,
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    10.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 100.0,
                                                        child: Image.network(
                                                          "${document.get('image')[0]}",
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 5.0),
                                                              child: Center(
                                                                child: Text(
                                                                  "${document.get('name')}",
                                                                  style: TextStyle(
                                                                      color: AppColors()
                                                                          .oxonGreen,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors()
                                                                  .oxonOffWhite,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical: 5.0,
                                                                  horizontal:
                                                                      5.0,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      "\u{20B9} ${document.get('price')}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              AppColors().oxonGreen)),
                                                                )),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return Scaffold(
                                backgroundColor: AppTheme.colors.oxonGreen,
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            })
                      ],
                    ),
                  );
                })));
  }

  Widget buildImage(String urlImage, int index) => Container(
        color: Colors.grey,
        child: Image.network(
          urlImage,
          fit: BoxFit.fill,
        ),
      );
}
