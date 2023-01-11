import 'package:ecommerce_user/customwidgets/cart_item_view.dart';
import 'package:ecommerce_user/models/product_model.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'checkout_page.dart';
class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key }) : super(key: key);
//final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart'),),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(child: ListView.builder(itemBuilder:(context, index) {
              final cartModel =provider.cartList[index];
              return CartItemView(cartModel: cartModel, provider: provider, );
            },
            itemCount: provider.cartList.length,)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                    child: Text('Sub Total : ${provider.getCartSubTotal()} BDT'
                        ),
                  ),
                  ElevatedButton(onPressed: provider.totalItemInCart==0? null :(){
                    Navigator.pushNamed(context, CheckOutPage.routeName);
                  }, child: Text('Checkout'))
                ],),
              ),
            )
          ],
        ),
      ),
    );
  }
}
