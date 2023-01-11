import 'dart:io';

import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/models/rating_model.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList
          .sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
      notifyListeners();
    });
  }

  List<CategoryModel> getCategoryListForFiltering() {
    return [CategoryModel(categoryName: 'All'), ...categoryList];
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(CategoryModel categoryModel) {
    DbHelper.getAllProductsByCategory(categoryModel).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> deleteImage(String downloadUrl) {
    return FirebaseStorage.instance.refFromURL(downloadUrl).delete();
  }

  Future<void> addRating(String productId, double userRateing,UserModel usermodel) async{
    final ratingmodel= RatingModel(
        ratingId: usermodel.userId, userModel: usermodel, productId: productId, rating: userRateing);
    await DbHelper.addRating(ratingmodel);
    final snapshot= await DbHelper.getRatingsByProduct(productId);
    final ratingList= List.generate(snapshot.docs.length,
            (index) => RatingModel.fromMap(snapshot.docs[index].data()));
    double totalRating =0.0;
for(var model in ratingList){
  totalRating +=model.rating;
}
final avgRating= totalRating/ratingList.length;
return DbHelper.updateProductField(productId, { productFieldAvgRating:avgRating});
  }

  Future<void> addComment(CommentModel commentModel) async {

return DbHelper.addComment(commentModel);
  }

 Future<List<CommentModel>> getAllcommentsByProduct(String productId) async{
final snapshot = await DbHelper.getAllcommentsByProduct(productId);
return List.generate(snapshot.docs.length, (index) => CommentModel.fromMap(snapshot.docs[index].data()));
  }
}
