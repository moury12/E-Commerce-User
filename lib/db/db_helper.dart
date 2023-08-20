import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/models/cart_model.dart';
import 'package:ecommerce_user/models/comment_model.dart';
import 'package:ecommerce_user/models/notification_model.dart';
import 'package:ecommerce_user/models/order_model.dart';
import 'package:ecommerce_user/models/rating_model.dart';
import '../models/category_model.dart';
import '../models/order_constant_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/wish_model.dart';

class DbHelper {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String id) =>
      _db.collection(collectionProduct).doc(id).get();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db
          .collection(collectionOrderConstant)
          .doc(documentOrderConstant)
          .snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

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
  static Future<void> updateUserField(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }

  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUser)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRatingsByProduct(
          String pid) =>
      _db
          .collection(collectionProduct)
          .doc(pid)
          .collection(collectionRating)
          .get();

  static Future<void> addRating(RatingModel ratingmodel) async {
    final ratDoc = _db
        .collection(collectionProduct)
        .doc(ratingmodel.productId)
        .collection(collectionRating)
        .doc(ratingmodel.userModel.userId);
    return ratDoc.set(ratingmodel.toMap());
  }

  static Future<void> updateProductField(String pid, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(pid).update(map);
  }

  static Future<void> addComment(CommentModel commentmodel) async {
    return _db
        .collection(collectionProduct)
        .doc(commentmodel.productId)
        .collection(collectionComment)
        .doc(commentmodel.commentId)
        .set(commentmodel.toMap());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllcommentsByProduct(
      String productId) {
    return _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(collectionComment)
        .where(commentFieldApproved, isEqualTo: true)
        .get();
  }

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel
            .toMap()); //cart er information usercollection e rakha hobe
  }

  static Future<void> removeFromCart(String uid, String s) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(s)
        .delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCartItems(
          String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();
static Future<void> addToFav(String uid, WishListModel wishModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionFav)
        .doc(wishModel.productId)
        .set(wishModel
            .toMap()); //cart er information usercollection e rakha hobe
  }

  static Future<void> removeFromFav(String uid, String s) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionFav)
        .doc(s)
        .delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFavItems(
          String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionFav)
          .snapshots();

  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> saveOrder(OrderModel orderModel) async {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc(orderModel.orderId);
    wb.set(orderDoc, orderModel.toMap());
    for (final cartModel in orderModel.productDetails) {
      final snapshotProduct = await _db
          .collection(collectionProduct)
          .doc(cartModel.productId)
          .get();
      final snapshotCategory = await _db
          .collection(collectionCategory)
          .doc(cartModel.categoryId)
          .get();

      final prevProductStock = snapshotProduct.data()![productFieldStock];
      final prevCategoryStock =
          snapshotCategory.data()![categoryFieldProductCount];
      final proDoc = _db.collection(collectionProduct).doc(cartModel.productId);
      final catDoc =
          _db.collection(collectionCategory).doc(cartModel.categoryId);
      wb.update(
          proDoc, {productFieldStock: (prevProductStock - cartModel.quantity)});
      wb.update(catDoc, {
        categoryFieldProductCount: (prevCategoryStock - cartModel.quantity)
      });
    }
    return wb.commit();
  }

  static Future<void> clearCartItem(
      String uid, List<CartModel> cartList) async {
    final wb = _db.batch();
    for (final cartModel in cartList) {
      final doc = _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productId);
      wb.delete(doc);
    }
    wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrderByUser(
          String uid) =>
      _db
          .collection(collectionOrder)
          .where(orderFieldUserId, isEqualTo: uid)
          .snapshots();

  static Future<void> addNotification(NotificationModel notificationModel) {
    return _db
        .collection(collectionNotification)
        .doc(notificationModel.id)
        .set(notificationModel.toMap());
  }
}
