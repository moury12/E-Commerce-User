
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
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
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
backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(  backgroundColor: Colors.deepPurple.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Checkout',style: GoogleFonts.adamina(fontSize: 15),),
        centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(clipBehavior: Clip.none,
              child: Stack(clipBehavior: Clip.none,
                children: [
                  ClipPath(clipBehavior: Clip.none,
                    child: Container(
                      height: 120, decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(60.0)),
                        color: Colors.deepPurple.shade300),),
                  ),Positioned( top:0,
                    left: 20,
                    child: Text(
                        'Product Info',style: GoogleFonts.adamina(color: Colors.grey.shade200,fontSize: 12,fontWeight: FontWeight.bold)
                    ),
                  ),Positioned( top:17,
                    left: 20,
                    child: Text(
                        'you have ${cartProvider.cartList.length} items in your cart',style: GoogleFonts.adamina(color: Colors.grey.shade200,fontSize: 8,fontWeight: FontWeight.w500)
                    ),
                  ),

                  Positioned.fill(top: 30,
                      left: 30,
                      right: 30,
                      bottom: -100,
                      child: productInfoSection(),)

                ],
              ),
            ),
            SizedBox(height: 100,),
            buildHeader('Delivery Address'),
            deliveryAddressSection(),
            buildHeader('Payment Method'),
            paymentMethodSection(),
            InkWell(hoverColor: Colors.grey.withOpacity(1),
              onTap: _saveOrder,
              child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0)
                        .copyWith(top: 10, bottom: 10),
                    child: Text('Place Order',
                        style: GoogleFonts.monda(
                            fontSize: 12,
                            color: Colors.white,

                        ))  ,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(colors: [
                      Colors.deepPurple.shade200,
                      Colors.lightBlue.shade200,
                    ]),
                  )),
            )

          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(alignment: Alignment.topLeft,
        child: Text(
          title,style: GoogleFonts.adamina(color: Colors.deepPurple.shade900,fontSize: 12,fontWeight: FontWeight.bold)
        ),
      ),
    );
  }

  Widget productInfoSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(

        children: cartProvider.cartList
            .map((cartModel) => Card(clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
        ),
          elevation: 2,
              child: Row(
                children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(100),

    child:CachedNetworkImage(
    fit: BoxFit.cover,
    width: 70,
    height:70,
    imageUrl: cartModel.productImageUrl,
    placeholder: (context, url) =>
    const Center(child: CircularProgressIndicator()),
    errorWidget: (context, url, error) =>
    const Icon(Icons.panorama),
    ),)),SizedBox(width: 10,),Column( crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(cartModel.productName),
                    Text('Cocholate flavour',maxLines: 1,overflow: TextOverflow.ellipsis),
                    Text('${cartModel.quantity}*${cartModel.salePrice}$currencySymbol'),],)
                ],



                  ),
            ))
            .toList(),
      ),
    );
  }


  Widget deliveryAddressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              DropdownButton<String>(underline: SizedBox(),
                  value: city,
                  icon: Icon(IconlyLight.arrowDownCircle),
                  hint: Text('Select Your City',style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade300,fontWeight: FontWeight.bold),),
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
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  customeText('Address Line 1', adressLine1Controller),SizedBox(height: 5),
                  customeText('Address Line 2', adressLine2Controller),SizedBox(height: 5),
                  customeText('Zip Code', zipCodeController),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget customeText (String hint, TextEditingController controller){
    return  TextField(style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
      controller: controller,
      decoration: InputDecoration(
        hintStyle:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
        hintText: hint,
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(width: 0, color: Colors.transparent),),
        enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

          borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade200),),
        prefixIcon: Icon(Icons.add_location_alt_outlined,color: Colors.deepPurple.shade700,size: 20,),
      ),
    );
}
  Widget paymentMethodSection() {
    return Row(
      children: [
        Radio<String>(
            value: PaymentMethod.cod,
            groupValue: paymentMethodGroupValue,
            onChanged: (value) {
              setState(() {
                paymentMethodGroupValue = value!;
              });
            }),
        Text(PaymentMethod.cod,style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade300,fontWeight: FontWeight.bold)),
        Radio<String>(
            value: PaymentMethod.online,
            groupValue: paymentMethodGroupValue,
            onChanged: (value) {
              setState(() {
                paymentMethodGroupValue = value!;
              });
            }),
        Text(PaymentMethod.online,style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade300,fontWeight: FontWeight.bold)),
      ],
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
