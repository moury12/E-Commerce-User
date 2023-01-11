import 'package:ecommerce_user/providers/order_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  static const String routeName = '/order';
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Consumer<OrderProvider>(
            builder: (context, provider, child) {
              final itemList=provider.orderitemList;
              return ExpansionPanelList(expansionCallback:(index, isExpanded) {
                setState(() {
                  itemList[index].isExpanded=!isExpanded;
                });
              },
              children: itemList.map<ExpansionPanel>((orderItem) => ExpansionPanel(
                isExpanded: orderItem.isExpanded,
                  headerBuilder: (context, isExpanded) => ListTile(
                title: Text(getFormattedDate(orderItem.orderModel.orderDate.timestamp.toDate(),pattern: 'dd/MM/yyyy'),
                ),
                subtitle: Text(orderItem.orderModel.orderStatus),
                trailing: Text('${orderItem.orderModel.grandTotal}$currencySymbol'),
              ), body:
             Column(
               children: orderItem.orderModel.productDetails.map((cartModel) {
                 return ListTile(
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
