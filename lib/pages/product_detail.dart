import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/theme/colors.dart';

import 'cart_pg.dart';

class ProductDetail extends StatefulWidget {
  final String description;
  final String ID;
  final String name;
  final String image;
  final int price;
  final int delivery;

  ProductDetail( {required this.ID,required this.description,required this.name,required this.price,required this.image,required this.delivery});
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final CollectionReference _productReference =
  FirebaseFirestore.instance.collection("Products");

  final CollectionReference _userRef =
  FirebaseFirestore.instance.collection("users");
  Color addback = AppColors().oxonOffWhite;
  Color addtext = AppColors().oxonGreen;
  User? _user =  FirebaseAuth.instance.currentUser;
  int count = 0 ;
  Object _add_to_cart(){
    if(count>0) {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      return _userRef
          .doc(_user?.uid)
          .collection("Cart").doc(widget.ID).set(
          {
            "ID": widget.ID,
            "name": widget.name,
            "image": widget.image,
            "price": widget.price,
            "quantity": count,
            "delivery":widget.delivery,
          }
      );
    }
    _userRef
        .doc(_user?.uid)
        .collection("Cart").doc(widget.ID).delete();
    return Null;
  }
  final SnackBar _snackBar = SnackBar(content:Text("Product Added to the cart"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            ListView(
              children: [
                Image.network(widget.image),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 25.0,
                  ),
                  child: Text(widget.name,
                    style: TextStyle(fontSize: 24,
                        color: AppColors().oxonGreen,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors().oxonOffWhite,
                      borderRadius: BorderRadius.circular(12.0),

                    ),
                    child:Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),child: Text("INR "+widget.price.toString(),style: TextStyle(fontSize: 30,color: AppColors().oxonGreen))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap : (){
                            setState(() {
                              count++;
                              if(count>0){
                                addtext = AppColors().oxonOffWhite;
                                addback = AppColors().oxonGreen;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors().oxonGreen,
                              borderRadius: BorderRadius.circular(12.0),

                            ),
                            child:Text(" + ",style: TextStyle(fontSize: 40,color: AppColors().oxonOffWhite)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 25.0,
                          horizontal: 25.0,

                        ),
                        child: Text("Quantity: "+count.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 15.0,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap : (){
                            setState(() {
                              // This call to setState tells the Flutter framework that something has
                              // changed in this State, which causes it to rerun the build method below
                              // so that the display can reflect the updated values. If we changed
                              // _counter without calling setState(), then the build method would not be
                              // called again, and so nothing would appear to happen.


                              if(count>0) {
                                count--;
                              }
                              if(count==0){
                                addtext = AppColors().oxonGreen;
                                addback = AppColors().oxonOffWhite;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors().oxonGreen,
                              borderRadius: BorderRadius.circular(12.0),

                            ),
                            child:Text("  -  ",style: TextStyle(fontSize: 40,color: AppColors().oxonOffWhite)),
                          ),
                        ),
                      ),
                    ),
                  ],

                ),
                Center(
                  child: Row(
                    children: [Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                      child: Center(
                        child: GestureDetector(

                          onTap : ()async{

                            await _add_to_cart();

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: addback,
                              borderRadius: BorderRadius.circular(12.0),

                            ),
                            child:Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 25.0,
                                ),child: Text("Add To Cart",style: TextStyle(fontSize: 20,color: addtext))),
                          ),
                        ),
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                        child: Center(
                          child: GestureDetector(

                            onTap : (){
                              if(count>0) {
                                _add_to_cart();

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartPage()));
                              }

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: addback,
                                borderRadius: BorderRadius.circular(12.0),

                              ),
                              child:Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 25.0,
                                  ),child: Text("Buy Now",style: TextStyle(fontSize: 20,color: addtext))),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15.0,
                    ),child: Text(widget.description)),
              ],
            ),
          ],
      ),
    );
  }
}
