import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/pages/product_details_page.dart';
import 'package:ecommerce_user/pages/view_product_page.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/product_model.dart';

class ProductGridView extends StatelessWidget {
  final ProductModel productModel;

  const ProductGridView({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailsPage.routeName ,arguments: productModel);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
              child: Stack(clipBehavior: Clip.none, children: [
            Column(children: [
              Expanded(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: productModel.thumbnailImageUrl,
                  placeholder: (context, url) => const Center(
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
             Container(
                  height: 90,
                  width: double.infinity,
                  color: Colors.deepPurple.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          productModel.productName,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.teal,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  productModel.stock.toString(),
                                  style: TextStyle(color: Colors.teal),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    productModel.available ||
                                            productModel.stock > 0
                                        ? 'Available'
                                        : 'Not Available',
                                    style: TextStyle(color: Colors.red)),
                                SizedBox(
                                  width: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      productModel.productDiscount > 0
                          ? Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${calculatePriceAfterDiscount(
                                      productModel.salePrice,
                                      productModel.productDiscount,
                                    )} BDT',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text('${productModel.salePrice} BDT',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough))
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${productModel.salePrice} BDT',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500))
                                  ])),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(productModel.avgRating!.toStringAsFixed(1)),
                            const SizedBox(width: 5,),
                            RatingBar.builder(
                              initialRating: productModel.avgRating!.toDouble(),
                              minRating: 0.0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: false,
                              itemSize: 15,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.deepPurple.shade500,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ]),
            if (productModel.productDiscount > 0)
              Positioned(
                  right: -5,
                  top: -10,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Colors.pink.shade500),
                    child: Center(
                      child: Text(
                        '${productModel.productDiscount.toString()}%',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ))
          ])),
        ));
  }

  ListTile desgin() {
    return ListTile(
      title: Text(productModel.productName),
      subtitle: Text(productModel.category.categoryName),
      trailing: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: Colors.teal,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                productModel.stock.toString(),
                style: TextStyle(color: Colors.teal),
              )
            ],
          )
        ],
      ),
    );
  }
}
