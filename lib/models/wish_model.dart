const String collectionFav = 'WishList';

const String favFieldProductId = 'productId';
const String favFieldCategoryId = 'categoryId';
const String favFieldProductName = 'productName';
const String favFieldProductImageUrl = 'productImageUrl';
const String favFieldQuantity = 'quantity';
const String favFieldSalePrice = 'salePrice';

class WishListModel {
  String productId;
  String categoryId;
  String productName;
  String productImageUrl;
  num quantity;
  num salePrice;

  WishListModel(
      {required this.productId,
        required this.categoryId,
        required this.productName,
        required this.productImageUrl,
        this.quantity = 1,
        required this.salePrice});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      favFieldProductId: productId,
      favFieldCategoryId: categoryId,
      favFieldProductName: productName,
      favFieldProductImageUrl: productImageUrl,
      favFieldQuantity: quantity,
      favFieldSalePrice: salePrice,
    };
  }

  factory WishListModel.fromMap(Map<String, dynamic> map) => WishListModel(
    productId: map[favFieldProductId],
    categoryId: map[favFieldCategoryId],
    productName: map[favFieldProductName],
    productImageUrl: map[favFieldProductImageUrl],
    quantity: map[favFieldQuantity],
    salePrice: map[favFieldSalePrice],
  );
}
