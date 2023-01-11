import 'package:ecommerce_user/pages/cart_page.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CartBubbleView extends StatelessWidget {
  const CartBubbleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.pushNamed(context, CartPage.routeName),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.shopping_cart, size: 30,),
            Positioned(
              left: -5,
              top: -5,
              child: Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(color: Colors.red,
                shape: BoxShape.circle,
                ),
                child:
                Center(child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: FittedBox(child: Consumer<CartProvider>(builder:(context,provider,child) =>Text('${provider.cartList.length}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),))),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
