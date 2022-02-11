import 'package:flutter/material.dart';
import 'package:oxon_app/widgets/cart_item.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  static const routeName = '/cart-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(context, 'Cart'),
      backgroundColor: Color.fromARGB(255, 34, 90, 0),
      body: Column(children: [
        CartItem('id', 'productId', 10, 1, 'Item1'),
        CartItem('id', 'productId', 10, 2, 'Item2'),

      ],),
    );
  }
}
