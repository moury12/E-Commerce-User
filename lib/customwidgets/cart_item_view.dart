import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
class CartItemView extends StatelessWidget {
  final CartModel cartModel;
  final CartProvider provider;

  const CartItemView({Key? key, required this.cartModel,required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading:  CachedNetworkImage(
              width: 70,
              height: 70,
              imageUrl: cartModel.productImageUrl,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            title: Text(cartModel.productName),
            subtitle: Text('price: ${cartModel.salePrice.toString()}'),
            trailing: IconButton(
              onPressed: (){
//provider.removeFromCart(productModel.productId!);
              },
              icon: Icon(Icons.delete),
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: (){
                provider.decreaseQuantity(cartModel);
              }, icon: Icon(Icons.remove_circle)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${cartModel.quantity}',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              IconButton(onPressed: (){
                provider.increaseQuantity(cartModel);
              }, icon: Icon(Icons.add_circle)),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('${provider.priceWithQuantity(cartModel)}BDT',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ],

          )
        ],
      ),
    );
  }
}
