import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}
var scaffoldKey = GlobalKey<ScaffoldState>();

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            shadowColor: Colors.transparent,
            leading: Builder(builder: (context)
                {
                  return IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(Icons.article_rounded),
                  );
                }
            ),
            backgroundColor: Colors.green[900],
            actions: [
              IconButton(
                  onPressed: () {},
                  icon:Icon(Icons.add_shopping_cart_rounded)
              )
            ],
            title: Text("Let's Shop",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body:SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/products_pg_bg.png"),
                          fit: BoxFit.cover
                      )
                  ),
                ),
               SingleChildScrollView(
                 child: Column(
                   children: [
                     Padding(
                       padding: EdgeInsets.fromLTRB(10, 10, 150, 10),
                       child: Text("Your previous orders",
                         style: TextStyle(
                             fontSize: 25,
                             color: Colors.white,
                             fontWeight: FontWeight.w500
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 150,
                       width: MediaQuery.of(context).size.width,
                       child: Padding(
                         padding: EdgeInsets.fromLTRB(10, 0,10, 0),
                         child: ListView(
                           scrollDirection: Axis.horizontal,
                           children: [
                             Container(
                               width: 100,
                               decoration: BoxDecoration(
                               color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                               border: Border.all(
                               color: Colors.white,
                                width: 2
                               ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                     Padding(
                       padding: EdgeInsets.fromLTRB(10, 50,212, 10),
                       child: Text("Our Bestsellers",
                         style: TextStyle(
                             fontSize: 25,
                             color: Colors.white,
                             fontWeight: FontWeight.w500
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 150,
                       width: MediaQuery.of(context).size.width,
                       child: Padding(
                         padding: EdgeInsets.fromLTRB(10, 0,10, 0),
                         child: ListView(
                           scrollDirection: Axis.horizontal,
                           children: [
                             Container(
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                     Padding(
                       padding: EdgeInsets.fromLTRB(10, 50,140, 10),
                       child: Text("Recommended for you",
                         style: TextStyle(
                             fontSize: 25,
                             color: Colors.white,
                             fontWeight: FontWeight.w500
                         ),
                       ),
                     ),
                     SizedBox(
                       height: 150,
                       width: MediaQuery.of(context).size.width,
                       child: Padding(
                         padding: EdgeInsets.fromLTRB(10, 0,10, 0),
                         child: ListView(
                           scrollDirection: Axis.horizontal,
                           children: [
                             Container(
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),)
                                 ],
                               ),
                             ),
                             SizedBox(
                               width: 20,
                             ),
                             Container(
                               height: 80,
                               width: 100,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.all(Radius.circular(20)),
                                 border: Border.all(
                                     color: Colors.white,
                                     width: 2
                                 ),
                               ),
                               child: Column(
                                 children: [
                                   Container(
                                       height:80, width:80,
                                       child: Image(image: AssetImage("assets/images/oxon.png"))),
                                   Text("Product",
                                     style: TextStyle(
                                         fontSize: 20,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                   SizedBox(
                                     height: 10,
                                   ),
                                   Text("Price",
                                     style: TextStyle(
                                         fontSize: 15,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w500
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               )
              ],
            ),
          )
        )
    );
  }
}
