
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/auth/authservice.dart';
import 'package:ecommerce_user/models/address_model.dart';
import 'package:ecommerce_user/models/date_model.dart';
import 'package:ecommerce_user/models/notification_model.dart';
import 'package:ecommerce_user/models/order_model.dart';
import 'package:ecommerce_user/pages/orderSuccessfull_page.dart';
import 'package:ecommerce_user/pages/view_product_page.dart';
import 'package:ecommerce_user/providers/notification_provider.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../utils/constants.dart';

class CheckOutPage extends StatefulWidget {
  static const String routeName = '/checkout';
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  String paymentMethodGroupValue = PaymentMethod.cod;
  String? city;
  final adressLine1Controller = TextEditingController();
  final adressLine2Controller = TextEditingController();
  final zipCodeController = TextEditingController();
  @override
  void dispose() {
    adressLine1Controller.dispose();
    adressLine2Controller.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    setAddres();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildHeader('Product Info'),
            productInfoSection(),
            buildHeader('Order Summery'),
            orderSummerySection(),
            buildHeader('Delivery Address'),
            deliveryAddressSection(),
            buildHeader('Payment Method'),
            paymentMethodSection(),
            ElevatedButton(onPressed: _saveOrder, child: Text('Place Order'))
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 17),
      ),
    );
  }

  Widget productInfoSection() {
    return Card(
      child: Column(
        children: cartProvider.cartList
            .map((cartModel) => ListTile(
                  title: Text(cartModel.productName),
                  leading: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: cartModel.productImageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  trailing:
                      Text('${cartModel.quantity}*${cartModel.salePrice}BDT'),
                ))
            .toList(),
      ),
    );
  }

  Widget orderSummerySection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Sub total'),
            trailing: Text(
                '${cartProvider.getCartSubTotal().toString()}$currencySymbol'),
          ),
          ListTile(
            title: Text(
                'Discount (${orderProvider.orderConstantModel.discount}%)'),
            trailing: Text(
                '-${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}$currencySymbol'),
          ),
          ListTile(
            title: Text('Vat (${orderProvider.orderConstantModel.vat}%)'),
            trailing: Text(
                '${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}$currencySymbol'),
          ),
          ListTile(
            title: Text('Delivery Charge'),
            trailing: Text(
                '${orderProvider.orderConstantModel.deliveryCharge}$currencySymbol'),
          ),
          Divider(
            height: 2,
            color: Colors.black,
          ),
          ListTile(
            title: Text('Total',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            trailing: Text(
                '${orderProvider.calculateTotal(cartProvider.getCartSubTotal())}$currencySymbol'),
          ),
        ],
      ),
    );
  }

  Widget deliveryAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
                value: city,
                hint: Text('Select Your City'),
                isExpanded: true,
                items: cities
                    .map((city) => DropdownMenuItem<String>(
                        value: city, child: Text(city)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                }),
            TextField(
              controller: adressLine1Controller,
              decoration: InputDecoration(hintText: 'Address Line 1'),
            ),
            TextField(
              controller: adressLine2Controller,
              decoration: InputDecoration(hintText: 'Address Line 2'),
            ),
            TextField(
              controller: zipCodeController,
              decoration: InputDecoration(hintText: 'Zip Code'),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentMethodSection() {
    return Card(
      child: Row(
        children: [
          Radio<String>(
              value: PaymentMethod.cod,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              }),
          Text(PaymentMethod.cod),
          Radio<String>(
              value: PaymentMethod.online,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              }),
          Text(PaymentMethod.online),
        ],
      ),
    );
  }

  void _saveOrder() async {
    if (adressLine1Controller.text.isEmpty) {
      showMsg(context, 'Please Provide Your address');
      return;
    }
    if (zipCodeController.text.isEmpty) {
      showMsg(context, 'Please Provide Your zipCode');
      return;
    }
    if (city == null) {
      showMsg(context, 'Please Provide Your city');
      return;
    }
    EasyLoading.show(status: 'Please wait');
    final orderModel = OrderModel(
        orderId: generatedId,
        userId: AuthService.currentUser!.uid,
        orderStatus: OrderStatus.pending,
        paymentMethod: paymentMethodGroupValue,
        grandTotal:
            orderProvider.calculateTotal(cartProvider.getCartSubTotal()),
        discount: orderProvider.orderConstantModel.discount,
        VAT: orderProvider.orderConstantModel.vat,
        deliveryCharge: orderProvider.orderConstantModel.deliveryCharge,
        orderDate: DateModel(
            timestamp: Timestamp.fromDate(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year),
        deliveryAddress: AddressModel(
            addressLine1: adressLine1Controller.text,
            addressLine2: adressLine2Controller.text,
            city: city,
            zipcode: zipCodeController.text),
        productDetails: cartProvider.cartList);
try{
 await orderProvider.saveOrder(orderModel);
await  cartProvider.clearCart();
EasyLoading.dismiss();
final notificationModel =NotificationModel(id: DateTime.now().microsecondsSinceEpoch.toString(), type: NotificationType.order, message: 'A new order has been place #${orderModel.orderId}',orderModel: orderModel);
await Provider.of<NotificationProvider>(context,listen: false).addNotification(notificationModel);
 Navigator.pushNamedAndRemoveUntil(context, OrderSuccessFullPage.routeName, ModalRoute.withName(ViewProductPage.routeName));
}catch(error){
  EasyLoading.dismiss();
  rethrow;
}
}

  void setAddres() {
    if (userProvider.userModel != null) {
      if (userProvider.userModel!.addressModel != null) {
        final address = userProvider.userModel!.addressModel!;
        adressLine1Controller.text = address.addressLine1!;
        adressLine2Controller.text = address.addressLine2!;
        zipCodeController.text = address.zipcode!;
        city = address.city;
      }
    }
  }
}
