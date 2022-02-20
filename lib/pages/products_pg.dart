import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/pages/product_detail.dart';
import 'package:oxon_app/size_config.dart';

import 'package:oxon_app/pages/cart_pg.dart';
import 'package:oxon_app/theme/colors.dart';

import 'package:oxon_app/widgets/custom_appbar.dart';

import '../widgets/custom_drawer.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  static const routeName = '/products-page';

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

var scaffoldKey = GlobalKey<ScaffoldState>();

class _ProductsPageState extends State<ProductsPage> {
  final CollectionReference _productReference =
      FirebaseFirestore.instance.collection("Products");
bool plant=true;
bool other = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            drawer: CustomDrawer(),
            appBar: CustomAppBar(context, "Let's Shop", [
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
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
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                Image.asset('assets/images/products_pg_bg.png')
                                    .image,
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: Stack(
                      children: [
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
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(
                                            builder: (context) => ProductDetail(name: "${document.get('name')}",
                                              ID: document.id,
                                              description: "${document.get('description')}",
                                              image: "${document.get('image')}",
                                              price: document.get('price'),
                                            delivery: document.get('delivery'),
                                              isplant: document.get('isplant'),)
                                        ));
                                      },
                                      child: Container(
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          color: AppColors().oxonOffWhite,
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 24.0,
                                        ),
                                        child :Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0,),
                                                  child: Column(
                                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                                    children:[Container(
                                                      height:100.0,
                                                      child: Image.network(
                                                        "${document.get('image')}",
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                     Column(
                                                       mainAxisAlignment : MainAxisAlignment.end,

                                                       children: [
                                                         Padding(
                                                           padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                                                           child: Text("${document.get('name')}",
                                                             style: TextStyle(color:AppColors().oxonGreen,fontSize: 15),),
                                                         ),
                                                         Container(
                                                           decoration: BoxDecoration(
                                                             color: AppColors().oxonOffWhite,
                                                             borderRadius: BorderRadius.circular(12.0),

                                                           ),
                                                           child:Padding(
                                                               padding: const EdgeInsets.symmetric(
                                                                 vertical: 10.0,
                                                                 horizontal: 10.0,
                                                               ),child: Text("\u{20B9} ${document.get('price')}",
                                                               style: TextStyle(fontSize: 15,color: AppColors().oxonGreen))),
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
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
