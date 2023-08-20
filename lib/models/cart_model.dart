const String collectionCart = 'Cart';

const String cartFieldProductId = 'productId';
const String cartFieldCategoryId = 'categoryId';
const String cartFieldProductName = 'productName';
const String cartFieldProductwish = 'wish';
const String cartFieldProductextra = 'extra';
const String cartFieldProductImageUrl = 'productImageUrl';
const String cartFieldQuantity = 'quantity';
const String cartFieldSalePrice = 'salePrice';

class CartModel {
  String productId;
  String categoryId;
  String productName;
  String wish;
  String extra;
  String productImageUrl;
  num quantity;
  num salePrice;

  CartModel(
      {required this.productId,
      required this.categoryId,
      required this.productName,
      required this.wish,
      required this.extra,
      required this.productImageUrl,
      this.quantity = 1,
      required this.salePrice});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      cartFieldProductId: productId,
      cartFieldCategoryId: categoryId,
      cartFieldProductName: productName,
      cartFieldProductwish: wish??'Wishing you a haapy birthday',
      cartFieldProductextra: extra??'',
      cartFieldProductImageUrl: productImageUrl,
      cartFieldQuantity: quantity,
      cartFieldSalePrice: salePrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        productId: map[cartFieldProductId],
        categoryId: map[cartFieldCategoryId],
        productName: map[cartFieldProductName],
    wish: map[cartFieldProductwish]??'Wishing you a haapy birthday',
        extra: map[cartFieldProductextra]??'',
        productImageUrl: map[cartFieldProductImageUrl],
        quantity: map[cartFieldQuantity],
        salePrice: map[cartFieldSalePrice],
      );
}
