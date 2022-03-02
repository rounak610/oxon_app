import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon/theme/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../size_config.dart';
import '../widgets/custom_appbar.dart';
import 'cart_page.dart';
import 'cart_pg.dart';


class ProductDetail extends StatefulWidget {
  final String description;
  final String ID;
  final String name;
  List<dynamic>image;
  final int price;
  final int delivery;
  final bool isplant;

  ProductDetail(
      {required this.ID, required this.description, required this.name, required this.price, required this.image, required this.delivery, required this.isplant});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final CollectionReference _productReference =
  FirebaseFirestore.instance.collection("Products");

  final CollectionReference _userRef =
  FirebaseFirestore.instance.collection("users");
  Color addtext = AppColors().oxonOffWhite;
  Color addback = AppColors().oxonGreen;
  User? _user = FirebaseAuth.instance.currentUser;
  int count = 1;

  Object _add_to_cart() {
    if (count > 0) {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      if (widget.isplant) {
        int additional = 0;
        if (dropdownvalue[8] == 'B') {
          additional = 10;
        }
        else if (dropdownvalue[8] == 'F') {
          additional = 35;
        }
        else {
          additional = 70;
        }
        return _userRef
            .doc(_user?.uid)
            .collection("Cart").doc(widget.ID).set(
            {
              "ID": widget.ID,
              "name": widget.name,
              "image": widget.image,
              "price": widget.price + additional,
              "quantity": count,
              "delivery": widget.delivery,
              "additional": dropdownvalue,
              "isplant": widget.isplant
            });
      }
      return _userRef
          .doc(_user?.uid)
          .collection("Cart").doc(widget.ID).set(
          {
            "ID": widget.ID,
            "name": widget.name,
            "image": widget.image,
            "price": widget.price,
            "quantity": count,
            "delivery": widget.delivery,
            "isplant": widget.isplant
          }
      );
    }
    _userRef
        .doc(_user?.uid)
        .collection("Cart").doc(widget.ID).delete();
    return Null;
  }

  String dropdownvalue = 'Plastic Bag +\u{20B9}10';
  var items = [
    'Plastic Bag +\u{20B9}10',
    'Earthen Teracotta Pot +\u{20B9}70',
    'Plastic Flowerpot +\u{20B9}35'
  ];
  final SnackBar _snackBar = SnackBar(
      content: Text("Product Added to the cart"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(context, "Let's Shop", [
          GestureDetector(
          onTap: (){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CartPageNew()),
    );
    },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
            width: 50,
            height: 50,
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
      ),
               ]
           ),
    body: Stack(
    children: [
    ListView(
    children: [
    CarouselSlider.builder(options: CarouselOptions(height: 400),
    itemCount: widget.image.length,
    itemBuilder: (context, index,realIndex){
    final imageurl = widget.image[index];
    return buildImage(imageurl,index);
    },

    ),
    Center(
    child: Padding(
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
    ),
    Center(
    child: Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 10.0,
    ),child: Text("\u{20B9} "+widget.price.toString(),style: TextStyle(fontSize: 30,color: AppColors().oxonGreen))),
    ),
    if(widget.isplant)...[
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    DropdownButton(

    // Initial Value
    value: dropdownvalue,

    // Down Arrow Icon
    icon: const Icon(Icons.keyboard_arrow_down),

    // Array list of items
    items: items.map((String items) {
    return DropdownMenuItem(
    value: items,
    child: Text(items),
    );
    }).toList(),
    // After selecting the desired option,it will
    // change button value to selected value
    onChanged: (String? newValue) {
    setState(() {
    dropdownvalue = newValue!;
    });
    },
    ),
    ],
    ),
    ],

    Center(
    child: Row(
    children: [Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 17.0,
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
    builder: (context) => CartPageNew()));
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

    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children:[
    Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 10.0,
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

    width: 45.0,

    decoration: BoxDecoration(
    color: AppColors().oxonGreen,
    borderRadius: BorderRadius.circular(12.0),

    ),

    child:Center(child: Text(" - ",style: TextStyle(fontSize: 30,color: AppColors().oxonOffWhite))),

    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 10.0,

    ),
    child: Text("Quantity: "+count.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
    Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 5.0,
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
    child:Text(" + ",style: TextStyle(fontSize: 30,color: AppColors().oxonOffWhite)),
    ),
    ),
    ),
    ),
    ],


    ),
    Padding(
    padding: const EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 15.0,
    ),child: Text(widget.description)),
    ],
    ),
    ],
    )
    ,
    );
  }

  Widget buildImage(imageurl, int index) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
        child: Image.network(widget.image[index], fit: BoxFit.fitWidth,),
      );


}