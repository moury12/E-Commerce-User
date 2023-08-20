import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/providers/product_provider.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product_model.dart';
import '../pages/product_details_page.dart';
class CartItemView extends StatelessWidget {
  final CartModel cartModel;
  final CartProvider provider;
  final ProductProvider productProvider;


  const CartItemView({Key? key, required this.cartModel,required this.provider, required this.productProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () async{
          final product = await productProvider.getProductById(cartModel.productId) ;

          Navigator.pushNamed(context, ProductDetailsPage.routeName ,arguments: product);

        },
        child: Stack(
        children: [

          Positioned(
            left: 30,
            right: 30,
            top: 20,
            child: Container(height: 100,
                decoration: BoxDecoration( color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(70),
            ),
              child:  Padding(
                padding:  EdgeInsets.only(left: 125.0,top: 15,right: 15),
                child: Text(maxLines: 1,overflow: TextOverflow.ellipsis,
                    '${cartModel.productName} ',style: GoogleFonts.adamina(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold,)),
              ),
            ),
          ),
          Positioned(
            right: 115,
            top: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 13.0,top: 5),
                  child: Text('${provider.priceWithQuantity(cartModel)}$currencySymbol ${cartModel.extra}+',style: GoogleFonts.adamina(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.bold)),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [IconButton(onPressed: (){
                    provider.decreaseQuantity(cartModel);
                  }, icon: Icon(Icons.remove_circle,color: Colors.deepPurple.shade900,)),
                    Text('${cartModel.quantity}',style: GoogleFonts.adamina(color: Colors.black54,fontSize: 10,fontWeight: FontWeight.bold)),
                    IconButton(onPressed: ()async{
                      final stock = await productProvider.getProductById(cartModel.productId) ;
                      provider.increaseQuantity(cartModel,stock,context);
                    }, icon: Icon(Icons.add_circle,color: Colors.deepPurple.shade900,)),],),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 50,bottom: 20, top: 0),
            child: ClipRRect( borderRadius: BorderRadius.circular(100),

              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                imageUrl: cartModel.productImageUrl,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Positioned(right: 50,
            top: 60,
            child: FloatingActionButton.small(
              backgroundColor: Colors.deepPurple.shade200,
              onPressed: (){
                provider.removeFromCart(cartModel.productId);
              },
              child: Icon(IconlyBold.delete,color: Colors.white,size: 20,),
            ),
          ),
        ],
    ),
      );
  }
}
