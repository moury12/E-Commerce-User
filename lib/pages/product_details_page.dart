import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/auth/authservice.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  final txtcontroller =TextEditingController();
  final focusNode =FocusNode();
String displayUrl="";
double userRateing =0.0;
  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    displayUrl=productModel.thumbnailImageUrl;

    super.didChangeDependencies();
  }
@override
  void dispose() {
    txtcontroller.dispose();
    super.dispose();
  }
  @override  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            imageUrl: displayUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
Padding(
  padding: const EdgeInsets.all(8.0),
  child:SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        InkWell(
          onTap: (){
setState(() {
    displayUrl=productModel.thumbnailImageUrl;
});}, child: Card(
            child: CachedNetworkImage(
              width: 80,
              height: 80,
              imageUrl:productModel.thumbnailImageUrl ,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        ...productModel.additionalImages.map((url) {
          if(url.isEmpty){
            return const SizedBox();
          }
          return InkWell(
            onTap: (){
setState(() {
    displayUrl=url;
});
            },
            child: Expanded(
              child: Card(
                child: CachedNetworkImage(
                  width: 80,
                  height: 80,
                  imageUrl: url,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        }).toList()
      ],
    ),
  ),
),
          ButtonBar(
          alignment: MainAxisAlignment.end,
            buttonMinWidth: 10,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border)),
              Consumer<CartProvider>(builder:(context, provider, child){
                final isInCart=provider.isProductInCart(productModel.productId!);
                return IconButton(onPressed: (){
                  if(isInCart){
                    provider.removeFromCart(productModel.productId!);
                  }
                  else{
                    provider.addToCart(productModel);
                  }
                }, icon: Icon(isInCart?Icons.remove_shopping_cart :Icons.shopping_cart_outlined));}  ),
                TextButton.icon(onPressed: (){}, icon: Icon(Icons.shopping_bag_outlined), label: Text('Buy Now'),)
            ],
          ),
          ListTile(
            title: Text(productModel.productName,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple),),
            subtitle: Text(productModel.category.categoryName),
          ),
         productModel.shortDescription==null?
           Text(''):Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(productModel.shortDescription!),
         ),
          ListTile(
            title: Text('Sale Price: $currencySymbol${calculatePriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Rate This Product ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 14),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (
                      RatingBar.builder(initialRating: productModel.avgRating!.toDouble(),itemSize: 25,

                          itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.deepPurple.shade300, ), onRatingUpdate: (rating){
                        userRateing=rating;
                      })
                  ),
                  ),
                  OutlinedButton(onPressed: () async{
                    if(AuthService.currentUser!.isAnonymous){
                      showMsg(context, "Please! Sign in to rate this product");
                      return;
                    }
                    EasyLoading.show(status: 'please wait');
                    await productProvider.addRating(productModel.productId!,userRateing,context.read<UserProvider>().userModel!);
                    EasyLoading.dismiss();
                    showMsg(context, 'Thanks for rating');
                  }, child: Text('Submit'),style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurple)),)
                ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(elevation: 5,
              child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Add your Comment ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 14),),
                    ),
                   TextField(
                     maxLines: 3,
controller: txtcontroller,
                     decoration: InputDecoration(border: OutlineInputBorder()),
                     focusNode: focusNode,
                   ),
                    OutlinedButton(onPressed: () async{
                      if(txtcontroller.text.isEmpty){
                        showMsg(context, 'Please! provide a valid comment');
                        return;
                      }
                      if(AuthService.currentUser!.isAnonymous){
                        showMsg(context, "Please! Sign in to comment on this product");
                        return;
                      }
                      EasyLoading.show(status: 'please wait');
                      final commentModel= CommentModel(commentId: DateTime.now().microsecondsSinceEpoch.toString(), userModel: context.read<UserProvider>().userModel!,
                          comment: txtcontroller.text,productId: productModel.productId!,date:getFormattedDate(DateTime.now(),pattern: 'dd/MM/yyyy')
                      );
                      await productProvider.addComment(commentModel);
                      EasyLoading.dismiss();
                      focusNode.unfocus();
                      txtcontroller.clear();
                      showMsg(context, 'Thanks for your comment, your comment is waiting for admin approval');
                      final notificationModel =NotificationModel(id: DateTime.now().microsecondsSinceEpoch.toString(), type: NotificationType.comment, message: 'Product ${productModel.productName} has a new comment which is waiting for admin approval',commentModel:commentModel );
                      await Provider.of<NotificationProvider>(context,listen: false).addNotification(notificationModel);
                    }, child: Text('Submit'),style: ButtonStyle(foregroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurple)),)
                  ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('All comments', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
          ),
          FutureBuilder<List<CommentModel>>(future: productProvider.getAllcommentsByProduct(productModel.productId!),
              builder: (context, snapshot) {
if(snapshot.hasData){
  final commentlist= snapshot.data!;
  if(commentlist.isEmpty){
   return Center(child: Text('No comments found'));
  }
  else{
    return Column(
children:
  commentlist.map((comment) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        leading:Container(

            child:comment.userModel.imageUrl==null?
            Image.asset(
              'assets/s.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ):
          CachedNetworkImage(
            width: 50,
            height: 50,
            imageUrl: comment.userModel.imageUrl!,
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
        ),
        title: Text(comment.userModel.displayName??comment.userModel.email),
subtitle: Text(comment.date),
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(comment.comment,style: TextStyle(fontSize: 15)),
      )
    ],
  )).toList()

    );
  }}
  if(snapshot.hasError){
    return Center(child: Text('Failed to load comments'));
  }
  else{
    return CircularProgressIndicator();
  }
},)
        ],
      ),

    );
  }
}
