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
  List<ProductModel> get featuredProducts {
    return productList.where((product) => product.featured || product.productDiscount > 0).toList();
  }
  Future<ProductModel> getProductById(String id) async {
    final snapshot = await DbHelper.getProductById(id);
    return ProductModel.fromMap(snapshot.data()!);
  }

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

  Future<void> addRating(String productId, double userRating, UserModel userModel) async {
    final ratingModel = RatingModel(
        ratingId: userModel.userId,
        userModel: userModel,
        productId: productId,
        rating: userRating
    );

    await DbHelper.addRating(ratingModel);

    final snapshot = await DbHelper.getRatingsByProduct(productId);
    notifyListeners();
    final ratingList = List.generate(snapshot.docs.length, (index) => RatingModel.fromMap(snapshot.docs[index].data()));

    double totalRating = 0.0;
    for (var model in ratingList) {
      totalRating += model.rating;
    }

    final avgRating = totalRating / ratingList.length;

    // Update the average rating in the database
    await DbHelper.updateProductField(productId, {productFieldAvgRating: avgRating});
  }

  Future<void> addComment(CommentModel commentModel) async {

return DbHelper.addComment(commentModel);
  }

 Future<List<CommentModel>> getAllcommentsByProduct(String productId) async{
   final snapshot = await DbHelper.getAllcommentsByProduct(productId);
   notifyListeners();
   return List.generate(snapshot.docs.length, (index) => CommentModel.fromMap(snapshot.docs[index].data()));
  }
}
