import 'package:ecommerce_user/auth/authservice.dart';
import 'package:ecommerce_user/models/order_item.dart';
import 'package:ecommerce_user/models/order_model.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/order_constant_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
List<OrderModel> orderList=[];
List<OrderItem> orderitemList=[];
  getOrderConstants() {
    DbHelper.getOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  int getDiscountAmount(num cartSubTotal) {
    return ((cartSubTotal*orderConstantModel.discount)/100).round();
  }

  int getVatAmount(num cartSubTotal) {
    final priceAfterDiscount =cartSubTotal-getDiscountAmount(cartSubTotal);
    return((priceAfterDiscount*orderConstantModel.vat)/100).round();
  }

 int calculateTotal(num cartSubTotal) {
    return ((cartSubTotal-getDiscountAmount(cartSubTotal)+getVatAmount(cartSubTotal)+orderConstantModel.deliveryCharge)).round();
 }

  Future<void> saveOrder(OrderModel orderModel) {
    return DbHelper.saveOrder(orderModel); }
  getAllOrderByUser() {
    DbHelper.getAllOrderByUser(AuthService.currentUser!.uid).listen((snapshot) {
      orderList = List.generate(snapshot.docs.length,
              (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      orderitemList=orderList.map((order) => OrderItem(orderModel: order)).toList();
      notifyListeners();
    });
  }
}
