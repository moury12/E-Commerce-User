import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/models/rating_model.dart';


import '../models/category_model.dart';
import '../models/order_constant_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class DbHelper {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db
          .collection(collectionOrderConstant)
          .doc(documentOrderConstant)
          .snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          CategoryModel categoryModel) =>
      _db
          .collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldId',
              isEqualTo: categoryModel.categoryId)
          .snapshots();
static Future<void>updateUserField(String uid, Map<String, dynamic> map){
  return _db.collection(collectionUser).doc(uid).update(map);
}
  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }
  static Future<QuerySnapshot<Map<String, dynamic>>> getRatingsByProduct(String pid) =>
      _db
          .collection(collectionProduct)
          .doc(pid).collection(collectionRating)
          .get();
  static Future<void> addRating(RatingModel ratingmodel) async{
  final ratDoc=_db.collection(collectionProduct).doc(ratingmodel.productId).collection(collectionRating).doc(ratingmodel.userModel.userId);
  return ratDoc.set(ratingmodel.toMap());

  }
  static Future<void>updateProductField(String pid, Map<String, dynamic> map){
    return _db.collection(collectionProduct).doc(pid).update(map);
  }

  static Future<void> addComment(CommentModel commentmodel) async{
    return _db.collection(collectionProduct).doc(commentmodel.productId).collection(collectionComment).doc(commentmodel.commentId).set(commentmodel.toMap());
  }

  static Future<QuerySnapshot<Map<String , dynamic>>> getAllcommentsByProduct(String productId) {
    return _db.collection(collectionProduct).doc(productId).collection(collectionComment)
        .where(commentFieldApproved, isEqualTo: true)
        .get();
  }
}
