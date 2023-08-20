import 'package:ecommerce_user/customwidgets/cart_item_view.dart';
import 'package:ecommerce_user/models/product_model.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../customwidgets/empty_screen.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  late ProductProvider productProvider;


  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
        elevation: 0,
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:userProvider.userModel==null?Text(''):
            Image.network(userProvider.userModel!.imageUrl!,height: 30,width: 40,fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
           return  Icon (IconlyLight.profile);
            },
            ),
          ),
        )],
        title: Text(
          'My Cart',
          style: GoogleFonts.adamina(fontSize: 15),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child)
        {

        return  Column(
                  children: [
                    provider.cartList.isEmpty
                        ? Expanded(
                            child: EmptyWidget(
                            text: 'Your Cart is currently empty!',
                          ))
                        : Expanded(
                            child: ListView.builder(
                            itemBuilder: (context, index)  {
                              final cartModel = provider.cartList[index];
                              return CartItemView(
                                cartModel: cartModel,
                                provider: provider,
                                productProvider: productProvider,
                              );
                            },
                            itemCount: provider.cartList.length,
                          )),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                          color: Colors.deepPurple.shade300),
                      child: Column(
                        children: [
                          orderSummerySection(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Total : ${provider.getCartSubTotal()} $currencySymbol',
                                    style: GoogleFonts.monda(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                InkWell(
                                  hoverColor: Colors.grey.withOpacity(1),
                                  onTap: provider.totalItemInCart == 0
                                      ? null
                                      : () {
                                          Navigator.pushNamed(
                                              context, CheckOutPage.routeName);
                                        },
                                  child:
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0)
                                            .copyWith(top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            Text('Checkout',
                                                style: GoogleFonts.monda(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Icon(
                                              IconlyBold.arrowRight2,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        gradient: LinearGradient(colors: [
                                          Colors.deepPurple.shade200,
                                          Colors.lightBlue.shade200,
                                        ]),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
    );
  }

  Widget orderSummerySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Listtile('Sub total(${cartProvider.cartList.length} items)', '${cartProvider.getCartSubTotal().toString()}$currencySymbol'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: Listtile('Discount (${orderProvider.orderConstantModel.discount}%)', '-${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}$currencySymbol'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: Listtile('Vat (${orderProvider.orderConstantModel.vat}%)', '${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}$currencySymbol'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: Listtile('Delivery Charge',  '${orderProvider.orderConstantModel.deliveryCharge}$currencySymbol'),
          ),

          ],
            ),
    );

  }
  Widget Listtile(String title,String trail){
    return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ Text('${title}:',style: GoogleFonts.monda(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w500)),
          Text(trail,style: GoogleFonts.monda(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w500)),
        ],
    );
  }
}
