import 'package:ecommerce_user/auth/authservice.dart';
import 'package:ecommerce_user/db/db_helper.dart';
import 'package:ecommerce_user/models/product_model.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import '../models/cart_model.dart';
class CartProvider extends ChangeNotifier{
List<CartModel> cartList=[];
bool isProductInCart (String pid){
  bool tag= false;
  for(final cartModel in cartList){
    if(cartModel.productId==pid){
    tag=true;
    break;
  }
}
return tag;
}
int get totalItemInCart => cartList.length;
  Future<void> addToCart(ProductModel productModel) {
final cartModel= CartModel(productId: productModel.productId!,categoryId:productModel.category.categoryId! , productName: productModel.productName, productImageUrl: productModel.thumbnailImageUrl, salePrice: num.parse(calculatePriceAfterDiscount(productModel.salePrice,productModel.productDiscount)));
return DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
  }

  Future<void> removeFromCart(String s) {
  return DbHelper.removeFromCart(AuthService.currentUser!.uid, s);
  }

  void getAllCartItems() {
  DbHelper.getAllCartItems(AuthService.currentUser!.uid).listen((snapshot){
cartList =List.generate(snapshot.docs.length, (index) => CartModel.fromMap(snapshot.docs[index].data()));
notifyListeners();
  });
  }
num priceWithQuantity(CartModel cartModel)=>
  cartModel.salePrice*cartModel.quantity;

  void decreaseQuantity(CartModel cartModel) {
    if(cartModel.quantity>1){
      cartModel.quantity-=1;
      DbHelper.updateCartQuantity(AuthService.currentUser!.uid,cartModel);
    }
  }

  void increaseQuantity(CartModel cartModel) {
    cartModel.quantity+=1;
    DbHelper.updateCartQuantity(AuthService.currentUser!.uid,cartModel);
  }
  num getCartSubTotal(){
    num total=0;
    for(final cartModel in cartList){
      total+= priceWithQuantity(cartModel);
    }
    return total;
  }

  Future<void> clearCart() {
    return DbHelper.clearCartItem(AuthService.currentUser!.uid, cartList);
  }
}