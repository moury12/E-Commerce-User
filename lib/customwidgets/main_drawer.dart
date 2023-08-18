
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/pages/order_page.dart';
import 'package:ecommerce_user/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/authservice.dart';
import '../pages/cart_page.dart';
import '../pages/launcher_page.dart';
import '../pages/login_page.dart';
import '../providers/user_provider.dart';

class MainDrawer extends StatefulWidget {
 const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  void didChangeDependencies() {
    Provider.of<UserProvider>(context, listen: false).getUserInfo();

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      width: 250,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10))),
      child: ListView(
        children: [
          Container(child:userProvider.userModel?.imageUrl!=null ?CachedNetworkImage(fit: BoxFit.cover,
            height: 150,
            //width: 30,
            imageUrl: userProvider.userModel?.imageUrl ?? '',
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error),
          ):Container(),
            color: Theme.of(context).primaryColor,
            height: 150,

          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {
              Navigator.pushNamed(context, UserProfile.routeName);
            },
            leading:  Icon(Icons.person),
            title:  Text('My Profile'),
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {Navigator.pushNamed(context, CartPage.routeName);},
            leading:  Icon(Icons.shopping_cart),
            title:  Text('My Cart'),
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {
              Navigator.pushNamed(context, OrderPage.routeName);
            },
            leading:  Icon(Icons.monetization_on),
            title:  Text('My Orders'),
          ),
          if (AuthService.currentUser!.isAnonymous)
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              leading: const Icon(Icons.person),
              title: const Text('Login/Register'),
            ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            leading:  Icon(Icons.logout),
            title:  Text('Logout'),
          ),

        ],
      ),
    );
  }
}
