import 'package:ecommerce_user/providers/order_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../customwidgets/empty_screen.dart';
import '../providers/user_provider.dart';

class OrderPage extends StatefulWidget {
  static const String routeName = '/order';
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        elevation: 0,
        actions: [ Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/d.png',height: 30,width: 30,),
        ),],
        title: Text(
          'My Orders',
          style: GoogleFonts.adamina(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Consumer<OrderProvider>(
            builder: (context, provider, child) {
              final itemList=provider.orderitemList;
              return provider.orderList.isEmpty?Center(child: EmptyWidget(text: 'You haven\'t ordered yet!',))
              :ExpansionPanelList(expansionCallback:(index, isExpanded) {
                setState(() {
                  itemList[index].isExpanded=!isExpanded;
                });
              },
              children: itemList.map<ExpansionPanel>((orderItem) => ExpansionPanel(

                isExpanded: orderItem.isExpanded,
                  headerBuilder: (context, isExpanded) => ListTile(
                title: Text(getFormattedDate(orderItem.orderModel.orderDate.timestamp.toDate(),),
                  style: GoogleFonts.adamina(fontSize: 12,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),),
                subtitle: Text(orderItem.orderModel.orderStatus),
                trailing: Text('${orderItem.orderModel.grandTotal}$currencySymbol', style: GoogleFonts.adamina(fontSize: 10,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.normal),),
              ), body:
             Column(
               children: orderItem.orderModel.productDetails.map((cartModel) {
                 return ListTile(
                  leading: FancyShimmerImage(height: 40,
                      width: 40,
                      imageUrl: cartModel.productImageUrl),
                   title:Text(cartModel.productName) ,
                   trailing: Text('${cartModel.quantity}x${cartModel.salePrice}'),
                 );
               }).toList(),
             )
              )).toList(),);
            },
          ),
        ),
      ),
    );
  }

}
class Orderbubble extends StatelessWidget {
  const Orderbubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder:(context,provider,child){
      return

        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(IconlyBold.bag2,color: Colors.deepPurple.shade700,size: 20,),
            provider.orderList.length !=0?  Positioned(
                left: -5,
                top: -5,
                child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(color: Colors.red.shade300,
                      shape: BoxShape.circle,
                    ),
                    child:
                    Center(child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: FittedBox(child: Text('${provider.orderList.length}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                      )),
                    ),
                    )
                )):SizedBox.shrink()],
        );
    },


    );;
  }
}

