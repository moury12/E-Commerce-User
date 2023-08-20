import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/pages/product_details_page.dart';
import 'package:ecommerce_user/providers/product_provider.dart';
import 'package:ecommerce_user/providers/wishList_provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../customwidgets/empty_screen.dart';
import '../providers/shopping_cart_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class WishListPage extends StatefulWidget {
  static const String routeName = '/fav';
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late CartProvider cartProvider;
late ProductProvider productProvider;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
    appBar:  AppBar(
        backgroundColor: Colors.deepPurple.shade50,
        foregroundColor: Colors.black54,
        elevation: 0,
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:userProvider.userModel==null?Text(''): Image.network(userProvider.userModel!.imageUrl??'',height: 30,width: 40,fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
              return  Icon (IconlyLight.profile);
            },),
          ),
        )],
        title: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(90),color: Colors.deepPurple),
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 7),
            child: Icon(IconlyBold.heart,color: Colors.deepPurple.shade50,),
          ),
        )
      ),
      body: Consumer<WishListProvider>(
        builder: (context, provider, child) => Column(
          children: [
            provider.wishList.isEmpty?Expanded(child: EmptyWidget(text: 'Your Wishlist is currently empty!',)):
            Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final wishModel = provider.wishList[index];
                    return
                      InkWell(onTap: () async{
                        final product = await productProvider.getProductById(wishModel.productId) ;

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
                                      borderRadius: BorderRadius.circular(70)
                                  ),

                                  child:      Padding(
                                    padding:  EdgeInsets.only(left: 125.0,top: 15,right: 15),
                                    child: Text(maxLines: 1,overflow: TextOverflow.ellipsis,
                                        '${wishModel.productName} ',style: GoogleFonts.adamina(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold,)),
                                  ),


                              ),
                            ),
                            Positioned(
                              right: 115,
                              top: 50,
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(left: 13.0,top: 5),
                                    child: Text('${wishModel.salePrice}$currencySymbol',style: GoogleFonts.adamina(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.bold)),
                                  ),

                                  TextButton.icon(onPressed: () {

                                  }, icon: Icon(IconlyLight.buy),label: Text(wishModel.quantity.toString()),
                                  ),

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
                                  imageUrl: wishModel.productImageUrl,
                                  placeholder: (context, url) =>
                                  const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(right:0,top:20,
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.deepPurple.shade200,
                                onPressed: (){
                                  provider.removeFromFav(wishModel.productId);
                                },
                                child: Icon(IconlyBold.delete,color: Colors.white,size: 20,),
                              ),
                            ), Positioned(right:0,bottom:0,
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.deepPurple.shade200,
                                onPressed: ()async{
                                  final product= await productProvider.getProductById(wishModel.productId);
                                wishModel.quantity>0?  cartProvider.addToCart(product,'',''):cartProvider.isProductInCart(wishModel.productId)?showMsg(context, 'product is already in cart'):showMsg(context, 'Sorry! product is not available in stock');
                                },
                                child: Icon(IconlyBold.buy,color: Colors.white,size: 20,),
                              ),
                            ),
                          ],
                        ),
                      );
                  },
                  itemCount: provider.wishList.length,
                )),

          ],
        ),
      ),
    );
  }
}