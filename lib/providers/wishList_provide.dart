import 'package:flutter/cupertino.dart';

import '../auth/authservice.dart';
import '../db/db_helper.dart';
import '../models/product_model.dart';
import '../models/wish_model.dart';
import '../utils/helper_functions.dart';

class WishListProvider with ChangeNotifier{
  List<WishListModel> wishList=[];
  bool isProductInWishList (String pid){
    bool tag= false;
    for(final favProduct in wishList){
      if(favProduct.productId==pid){
        tag=true;
        break;
      }
    }
    return tag;
  }
  Future<void> addToFav(ProductModel productModel) {
    final wish= WishListModel(quantity: productModel.stock,
        productId: productModel.productId!,categoryId:productModel.category.categoryId! , productName: productModel.productName, productImageUrl: productModel.thumbnailImageUrl, salePrice: num.parse(calculatePriceAfterDiscount(productModel.salePrice,productModel.productDiscount)));
    return DbHelper.addToFav(AuthService.currentUser!.uid, wish);
  }

  Future<void> removeFromFav(String s) {
    return DbHelper.removeFromFav(AuthService.currentUser!.uid, s);
  }

  void getAllFavItems() {
    DbHelper.getAllFavItems(AuthService.currentUser!.uid).listen((snapshot){
      wishList =List.generate(snapshot.docs.length, (index) => WishListModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}