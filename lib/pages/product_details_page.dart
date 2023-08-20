import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/auth/authservice.dart';
import 'package:ecommerce_user/customwidgets/empty_screen.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/providers/wishList_provide.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../models/product_model.dart';
import '../providers/notification_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;
  final txtcontroller = TextEditingController();
  final focusNode = FocusNode();
  String addExtra='';
  String displayUrl = "";
  double userRateing = 0.0;
   TextEditingController controller= TextEditingController();
  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    displayUrl = productModel.thumbnailImageUrl;
    Provider.of<ProductProvider>(context, listen: false).getAllcommentsByProduct(productModel.productId!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    txtcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 230,
              pinned: true,
              backgroundColor: Colors.grey.shade100.withOpacity(0.2),
              elevation: 0,
              toolbarHeight: 40,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(0)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 200,
                        imageUrl: displayUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: 19,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(90),
                          ),
                        ),
                      ),
                      bottom: -1,
                      left: 0,
                      right: 0,
                    ),
                  ],
                ),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  displayUrl = productModel.thumbnailImageUrl;
                                });
                              },
                              child: Card(
                                child: CachedNetworkImage(
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  imageUrl: productModel.thumbnailImageUrl,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            ...productModel.additionalImages.map((url) {
                              if (url.isEmpty) {
                                return const SizedBox();
                              }
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    displayUrl = url;
                                  });
                                },
                                child: Card(
                                  child: CachedNetworkImage(
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    imageUrl: url,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              );
                            }).toList()
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        productModel.productName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            RatingBar.builder(
                                initialRating:
                                    productModel.avgRating!.toDouble(),
                                itemSize: 15,
                                itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.deepPurple.shade300,
                                    ),
                                onRatingUpdate: (rating) async{
                                  userRateing = rating;

                                    if (AuthService.currentUser!.isAnonymous) {
                                      showMsg(context,
                                          "Please! Sign in to rate this product");
                                      return;
                                    }
                                    EasyLoading.show(status: 'please wait');
                                    await productProvider.addRating(
                                        productModel.productId!,
                                        userRateing,
                                        context.read<UserProvider>().userModel!);
                                    EasyLoading.dismiss();
                                    showMsg(context, 'Thanks for rating');
                                }),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              productModel.avgRating!.toStringAsFixed(1),
                              style: GoogleFonts.adamina(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      trailing:  productModel.productDiscount > 0
                          ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${productModel.salePrice} $currencySymbol',
                                style: const TextStyle(
                                    fontSize: 11,
                                    decoration:
                                    TextDecoration.lineThrough)),
                            Text(
                              '${calculatePriceAfterDiscount(
                                productModel.salePrice,
                                productModel.productDiscount,
                              )} $currencySymbol',style: GoogleFonts.monda(fontSize: 10,color: Colors.purple, fontWeight: FontWeight.w500)
                            ),

                          ],
                        ),
                      )
                          : Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('${productModel.salePrice}$currencySymbol',style: GoogleFonts.monda(fontSize: 10,color: Colors.purple, fontWeight: FontWeight.w500)))
                    ),
                    productModel.shortDescription == null
                        ? Text('')
                        : Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                      child: Align(alignment: Alignment.topLeft,
                        child: Text(
                                '${productModel.shortDescription!}. we have ${productModel.stock} products on stock.',style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12,color: Colors.black
                        ),),
                      ),
                    ),
                    Align(alignment:Alignment.topLeft,
                      child: Text('      Write your wish on cake',
                          style: GoogleFonts.adamina(
                              fontWeight: FontWeight.w700,color: Colors.deepPurple, fontSize: 10)),
                    ),
              Padding(
                padding:  EdgeInsets.all(5.0).copyWith(left: 10,right: 30),
                child: Container(height: 50,
                  decoration: BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(50), ),
                  child: TextField(
                    style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                    controller: controller,

                    decoration: InputDecoration(
                      hintStyle:GoogleFonts.adamina(fontSize: 10,color: Colors.black54) ,
                      hintText: 'Wishing you a haapy birthday',
                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(width: 0, color: Colors.transparent),),
                      enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

                        borderSide: BorderSide(width: 1, color: Colors.transparent),),
                     // prefixIcon: Icon(Icons.add_location_alt_outlined,color: Colors.deepPurple.shade700,size: 20,),
                    ),
                  ),
                ),
              ),
                    Align(alignment:Alignment.topLeft,
                      child: Text('      Add extra',
                          style: GoogleFonts.adamina(
                              fontWeight: FontWeight.w700,color: Colors.deepPurple, fontSize: 10)),
                    ),

FittedBox(
  child: Row(children: [
    TextButton(onPressed: (){
      setState(() {
        addExtra='🍒';
      });
    }, child: Text('🍒')),
    TextButton(onPressed: (){  setState(() {
      addExtra='🍫';
    });}, child: Text('🍫')),
    TextButton(onPressed: (){  setState(() {
      addExtra='🍓';
    });}, child: Text('🍓')),
    TextButton(onPressed: (){  setState(() {
      addExtra='🍧';
    });}, child: Text('🍧')),

    TextButton(onPressed: (){  setState(() {
      addExtra='🍭';
    });}, child: Text('🍭')),
  ],),
),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 2,
                              child: SizedBox(
                                width: 230,
                                child: TextField(
                                  controller: txtcontroller,
                                  onChanged: (query) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0, color: Colors.transparent),
                                    ),
                                    hintStyle:
                                    GoogleFonts.adamina(fontSize: 10),
                                    hintText: 'Add your comment here...',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              bottom: 10,
                              child: Card(
                                  color: Colors.deepPurple.shade700,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  elevation: 2,
                                  child: IconButton(
                                      onPressed: () async {
                                        print(txtcontroller.text);
                                        if (txtcontroller.text.isEmpty) {
                                          showMsg(context,
                                              'Please! provide a valid comment');
                                          return;
                                        }
                                        if (AuthService.currentUser!.isAnonymous) {
                                          showMsg(context,
                                              "Please! Sign in to comment on this product");
                                          return;
                                        }
                                        EasyLoading.show(status: 'please wait');
                                        final commentModel = CommentModel(
                                            approved: true,
                                            commentId: DateTime.now()
                                                .microsecondsSinceEpoch
                                                .toString(),
                                            userModel: context
                                                .read<UserProvider>()
                                                .userModel!,
                                            comment: txtcontroller.text,
                                            productId: productModel.productId!,
                                            date: getFormattedDate(DateTime.now(),
                                                pattern: 'dd/MM/yyyy'));
                                        await productProvider
                                            .addComment(commentModel);
                                        EasyLoading.dismiss();
                                        //focusNode.unfocus();
                                        txtcontroller.clear();
                                        showMsg(context,
                                            'Thanks for your comment, your comment is waiting for admin approval');
                                        final notificationModel = NotificationModel(
                                            id: DateTime.now()
                                                .microsecondsSinceEpoch
                                                .toString(),
                                            type: NotificationType.comment,
                                            message:
                                            'Product ${productModel.productName} has a new comment which is waiting for admin approval',
                                            commentModel: commentModel);
                                        await Provider.of<NotificationProvider>(
                                            context,
                                            listen: false)
                                            .addNotification(notificationModel);
                                      },
                                      icon: Icon(
                                        IconlyBold.arrowRight,
                                        color: Colors.white,
                                        size: 20,
                                      ))),
                            )
                          ],
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          buttonMinWidth: 10,
                          children: [

                            Consumer<WishListProvider>(
                                builder: (context, provider, child) {
                                  final isInCart = provider
                                      .isProductInWishList(productModel.productId!);
                                  return IconButton(
                                      onPressed: () {
                                        if (isInCart) {
                                          provider.removeFromFav(
                                              productModel.productId!);
                                        } else {
                                          if (AuthService.currentUser!.isAnonymous) {
                                            showMsg(context, 'Please sign in to add this product on wishlist');
                                            return;
                                          }else{
                                          productModel.stock>0?
                                          provider.addToFav(productModel):showMsg(context, 'Sorry! product is not available in stock');
                                        }}
                                      },
                                      icon: Icon(isInCart
                                          ? IconlyBold.heart
                                          : IconlyLight.heart,color: Colors.deepPurple.shade900,));
                                }),
                            Consumer<CartProvider>(
                                builder: (context, provider, child) {
                                  final isInCart = provider
                                      .isProductInCart(productModel.productId!);
                                  return IconButton(
                                      onPressed: () {
                                        if (isInCart) {
                                          provider.removeFromCart(
                                              productModel.productId!);
                                        } else {
                                          if (AuthService.currentUser!.isAnonymous) {
                                            showMsg(context, 'Please sign in to add this product on wishlist');
                                            return;
                                          }else{
                                          productModel.stock>0?
                                          provider.addToCart(productModel,controller.text,addExtra):showMsg(context, 'Sorry! product is not available in stock');
                                        }}
                                      },
                                      icon: FittedBox(
                                        child: Icon(isInCart
                                            ? Icons.remove_shopping_cart
                                            : Icons.shopping_cart_outlined,color: Colors.deepPurple.shade900,),
                                      ));
                                }),
                          ],
                        ),
                      ],
                    ),
SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(alignment:Alignment.topLeft,
                        child: Text('     Comments',
                            style: GoogleFonts.adamina(
                                fontWeight: FontWeight.w700,color: Colors.deepPurple, fontSize: 10)),
                      ),
                    ),
                    FutureBuilder<List<CommentModel>>(
                      future: productProvider
                          .getAllcommentsByProduct(productModel.productId!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final commentlist = snapshot.data!;
                          if (commentlist.isEmpty) {
                            return EmptyWidget(text: 'No comments found');
                          } else {
                            return Column(
                                children: commentlist
                                    .map((comment) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0).copyWith(top: 0,bottom: 0),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: ListTile(
                                                    leading: ClipRRect(
                                                      child: CachedNetworkImage(
                                                              width: 50,
                                                              height: 50,
                                                              imageUrl: comment
                                                                  .userModel
                                                                  .imageUrl??'',
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget: (context,
                                                                      url, error) =>
                                                                   Image.asset(
                                                                    'assets/s.png',
                                                                    height: 50,
                                                                    width: 50,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                            ),
                                                     borderRadius: BorderRadius.circular(90),
                                                    ),
                                                    title: Text(comment
                                                            .userModel.displayName ??
                                                        comment.userModel.email, maxLines: 1,overflow: TextOverflow.ellipsis,style: GoogleFonts.adamina(fontWeight: FontWeight.w600, fontSize: 10),),
                                                    subtitle: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(comment.comment,style: GoogleFonts.adamina(fontWeight: FontWeight.w500, fontSize: 10),),
                                                        Text(comment.date,style: GoogleFonts.monda(fontSize: 7,color: Colors.purple, fontWeight: FontWeight.w500)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ))
                                    .toList());
                          }
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Failed to load comments'));
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              ),

            ]),
          ),
        ],
      ),
    );
  }
}
