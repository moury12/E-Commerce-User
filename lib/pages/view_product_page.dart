import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce_user/pages/order_page.dart';
import 'package:ecommerce_user/pages/product_details_page.dart';
import 'package:ecommerce_user/pages/wish_list_page.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/providers/wishList_provide.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import '../utils/notificationService.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;
  final txtcontroller =TextEditingController();
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    Provider.of<WishListProvider>(context, listen: false).getAllFavItems();
    Provider.of<OrderProvider>(context,listen: false).getAllOrderByUser();
    super.didChangeDependencies();
  }
  String selectedCategory = '';
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print('Got a message whilst in the foreground!');
      //print('Message data: ${message.data}');

      if (message.notification != null) {
        //print('Message also contained a notification: ${message.notification}');
        NotificationService service = NotificationService();
        service.sendNotifications(message);
      }
    });
    setupInteractedMessage();
    super.initState();
  }
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        //toolbarHeight: 45,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        elevation: 0,
        title: Text('Bakery Shop',style: GoogleFonts.adamina(fontSize: 15),),
        centerTitle: true,
        leading: Card(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
            elevation: 2,child: IconButton(onPressed: (){Navigator.pushNamed(context, OrderPage.routeName);},
            icon: Icon(IconlyBold.bag2,color: Colors.deepPurple.shade700,size: 20,))),
        actions: [ Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            elevation: 2,child: IconButton(onPressed: (){},
            icon: Icon(IconlyBold.notification,color: Colors.deepPurple.shade700,size: 20,))),],
      ),
      //drawer: MainDrawer(),

      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),elevation: 2,
    child: TextField(controller: txtcontroller,
      onChanged: (query) {
        setState(() {
          searchQuery = query; // Update the search query whenever the user types
        });
      },
      decoration: InputDecoration(
    focusedBorder:  OutlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0, color: Colors.transparent),),
        prefixIcon: Icon(IconlyLight.search,color: Colors.deepPurple.shade700,size: 20,),
        suffixIcon:Card(color: Colors.deepPurple.shade700,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
        ),
        elevation: 2,child: IconButton(onPressed: (){},
        icon: Icon(IconlyBold.filter,color: Colors.white,size: 20,))) ,
        hintStyle:GoogleFonts.adamina(fontSize: 10) ,
        hintText: 'Search for your cake...',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
        ),
      ),
    ),
  ),
),
                Container(height: 40, width: double.infinity,
                  child: ListView.builder(scrollDirection: Axis.horizontal,
                    itemCount: provider.categoryList.length,
                    itemBuilder: (context, index) {
                    final cat = provider.categoryList[index];
                    bool isSelected = selectedCategory == cat.categoryName; // Check if the category is selected
                    return InkWell(onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategory = ''; // Reset the selected category if double-clicked
                        } else {
                          selectedCategory = cat.categoryName; // Set the selected category
                        }
                      });
                    },
                      child: Card(
                      color: isSelected ? Colors.deepPurple.shade300 : Colors.deepPurple.shade50,

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          elevation: 2,child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(cat.categoryName,style: GoogleFonts.adamina(color: isSelected ? Colors.white : Colors.black,fontSize: 10),),
                          )),
                    ) ;
                  },),
                ),
               Container(height:  250,width: double.infinity,
                 child:
                    Swiper(
                     autoplayDelay: 2000,
                     autoplay: true,
                     layout: SwiperLayout.DEFAULT,
                     viewportFraction: 0.9,
                     itemWidth: 330,
                     itemCount: provider.featuredProducts.length,
                     itemBuilder: (context, index) {
                       final product=provider.featuredProducts[index];
                       return  InkWell(onTap: () {
                         Navigator.pushNamed(context, ProductDetailsPage.routeName ,arguments: product);

                       },
                         child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Card(clipBehavior: Clip.hardEdge,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20)
                           ),
                             elevation: 4,
                             child: Stack(
                               children: [
                                 Positioned(right:-70,
                                   bottom: -20,

                                   child: ClipRRect(borderRadius: BorderRadius.circular(360).copyWith(topRight: Radius.circular(20)),
                                     child: FancyShimmerImage(height: 250,
                                       width: 250,
                                       imageUrl: product.thumbnailImageUrl,
                                      boxFit: BoxFit.cover,
                                       errorWidget:Icon(Icons.image),
                                     ),
                                   ),
                                 ),
                                 Positioned(top: 30,
                                     left:10,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         SizedBox(width:115,
                                             child: Text(

                                                 product.productName,style: GoogleFonts.sacramento(fontSize: 25,color: Colors.black, fontWeight: FontWeight.w500),maxLines: 1,textAlign: TextAlign.center,)),
                                         Text(product.category.categoryName,style: GoogleFonts.sacramento(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w500)),

                                       ],
                                     )),
                                 Positioned(
                                   top: 110,
                                   bottom: 60,
                                   left:-15,
                                   child: Container(

                                     child: Padding(
                                       padding: const EdgeInsets.all(3.0).copyWith(left: 18),
                                       child: Column(children: [Text(' Special discount\n up to',style: GoogleFonts.monda(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w500)),
                                        ],),
                                     ),
                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.purple.withOpacity(0.5)),
                                   ),
                                 ), Positioned(bottom: 58,
                                   left:28,
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(
                                         '${ product.productDiscount.toString()}%',style: GoogleFonts.adamina(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.deepPurple.shade900,)
                                     ),
                                   ),
                                 ),



                               ],
                             ),
                           ),
                         ),
                       );
                     },



               )),
               Container( decoration: BoxDecoration(
                 borderRadius:
                 BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40),),
                 gradient: LinearGradient(colors: [
                   Colors.deepPurple.shade100,
                   Colors.lightBlue.shade100,
                 ]),
               ),
                 child: Column(
                   children: [
                     // Align(
                     //   alignment: Alignment.topLeft,
                     //   child: Padding(
                     //     padding: const EdgeInsets.only( left: 28),
                     //     child: Text(
                     //       'Popular',style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade900,fontWeight: FontWeight.bold),),
                     //   ),
                     // ),

                     SizedBox(height: 20,),Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(height: 200,width: double.infinity,
                         child: ListView.builder(scrollDirection: Axis.horizontal,
                           itemBuilder: (context, index) {
                             final product=provider.productList[index];
                             if ((selectedCategory.isEmpty ||
                                 product.category.categoryName == selectedCategory) &&
                                 (searchQuery.isEmpty ||
                                     product.productName
                                         .toLowerCase()
                                         .contains(searchQuery.toLowerCase()))){
                               return InkWell(
                                 onTap: () {
                                   Navigator.pushNamed(context, ProductDetailsPage.routeName ,arguments: product);

                                 },
                                 child: Stack(
                                   children: [  Padding(
                                     padding: const EdgeInsets.all(3.0),
                                     child: ClipRRect(
                                       child: FancyShimmerImage(height: 120,
                                         width: 150,
                                         boxFit: BoxFit.cover,
                                         imageUrl: product.thumbnailImageUrl,

                                       ),
                                       borderRadius: BorderRadius.circular(20),
                                     ),
                                   ),
                                     Positioned(top:110,
                                       bottom:-2,
                                       left:10,
                                       right:10,

                                       child: Card(
                                         shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(20)
                                         ),
                                         child: FittedBox(
                                           child: Column(
                                             children: [


                                               Padding(
                                                 padding: const EdgeInsets.all(2.0),
                                                 child: Text(
                                                   product.productName,
                                                   style: GoogleFonts.adamina(fontSize: 12,
                                                       color: Colors.deepPurple,
                                                       fontWeight: FontWeight.bold),
                                                 ),
                                               ),
                                               Text(
                                                 product.category.categoryName,
                                                 style: GoogleFonts.adamina(fontSize: 9,
                                                     color: Colors.black54,
                                                     fontWeight: FontWeight.normal),
                                               ),
                                               Row(

                                                 children: [
                                                   TextButton.icon(onPressed: () {},
                                                     icon: Icon(IconlyBold.star, size: 15,
                                                       color: Colors.yellow.shade600,),
                                                     label: Text(
                                                       product.avgRating!.toStringAsFixed(1),
                                                       style: GoogleFonts.adamina(fontSize: 10,
                                                           color: Colors.deepPurple
                                                               .shade300,fontWeight: FontWeight.w600),),),
                                                   Text("${product.salePrice
                                                       .toString()}$currencySymbol",style: GoogleFonts.monda(fontSize: 10,color: Colors.purple.shade900, fontWeight: FontWeight.w600))
                                                 ],
                                                 mainAxisAlignment: MainAxisAlignment
                                                     .spaceBetween,
                                               )
                                             ],
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               );
                             }
                             else {
                               return SizedBox.shrink(); // Hide non-matching products
                             }
                           },itemCount: provider.productList.length,
                         ),
                       ),
                     )
                   ],
                 ),
               )
              ],
            ),
          ) ;
        },
      ),
    );
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  void _handleMessage(RemoteMessage message) {
    if (message.data['key'] == 'promo') {
      print('REDIRECTING...');
      final code = message.data['value'];
      /*//final productModel = Provider.of<ProductProvider>(context, listen: false)
      .getProductByIdFromCache(id);*/
      Navigator.pushNamed(context, WishListPage.routeName, arguments: code);
    } else if (message.data['key'] == 'product') {
      final id = message.data['value'];
      Provider.of<ProductProvider>(context, listen: false)
          .getProductById(id)
          .then((value) => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: value));
    }
  }
}
