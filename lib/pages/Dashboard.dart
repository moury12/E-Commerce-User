import 'package:ecommerce_user/customwidgets/cart_bubble_view.dart';
import 'package:ecommerce_user/pages/cart_page.dart';
import 'package:ecommerce_user/pages/wish_list_page.dart';
import 'package:ecommerce_user/pages/user_profile.dart';
import 'package:ecommerce_user/pages/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import '../providers/shopping_cart_provider.dart';
import '../providers/user_provider.dart';

class DashBoard extends StatefulWidget {
  static const String routeName = '/dash';

  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    Provider.of<OrderProvider>(context,listen: false).getAllOrderByUser();
    super.didChangeDependencies();
  }
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container( decoration:index==0?  BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.deepPurple.shade100,
          Colors.lightBlue.shade100,
        ])
      ):BoxDecoration(),
        child: BottomNavigationBar(
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
selectedItemColor:index==1?Colors.deepPurple.shade900 :Colors.deepPurple.shade700,
          unselectedItemColor: index==1?Colors.deepPurple.shade50:Colors.deepPurple.shade200,

          items:  [

            BottomNavigationBarItem(
              icon: Icon(IconlyBold.home),
             label: "",

              //selectedColor:Colors.deepPurple.shade800 ,
            ), BottomNavigationBarItem(
                icon: CartBubbleView()
                ,label: ""
              //selectedColor:Colors.deepPurple.shade800 ,
            ),  BottomNavigationBarItem(
              icon: Icon(IconlyBold.heart),label: ""
              //selectedColor:Colors.deepPurple.shade800 ,
            ),   BottomNavigationBarItem(
              icon: Icon(IconlyBold.user2),label: ""
              //selectedColor:Colors.deepPurple.shade800 ,
            ),


          ],

          backgroundColor: index==1?Colors.deepPurple.shade300:index==0?Colors.transparent  :Colors.white,


          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },

        ),
      ),
      body: getSelectedPage(index: index),
    );
  }
  Widget getSelectedPage({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = ViewProductPage();
        break;
      case 1:
        widget = CartPage();
        break;
      case 2:
        widget = WishListPage();
        break;
      case 3:
        widget = UserProfile();
        break;
      default:
        widget = ViewProductPage();
        break;
    }
    return widget;
  }
}
