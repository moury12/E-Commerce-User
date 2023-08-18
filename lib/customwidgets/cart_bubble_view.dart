import 'package:ecommerce_user/pages/cart_page.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
class CartBubbleView extends StatelessWidget {
  const CartBubbleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder:(context,provider,child){
      return

      Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(IconlyBold.buy),
          provider.cartList.length !=0?  Positioned(
            left: -5,
            top: -5,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(color: Colors.red.shade300,
                shape: BoxShape.circle,
              ),
              child:
              Center(child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: FittedBox(child: Text('${provider.cartList.length}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
              )),
            ),
          )
      )):SizedBox.shrink()],
      );
    },


    );
  }
}
