
import 'package:ecommerce_user/pages/user_profile.dart';
import 'package:flutter/material.dart';

import '../auth/authservice.dart';
import '../pages/launcher_page.dart';
import '../pages/login_page.dart';

class MainDrawer extends StatelessWidget {
 const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10))),
      child: ListView(
        children: [
          Container(
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
            onTap: () {},
            leading:  Icon(Icons.shopping_cart),
            title:  Text('My Cart'),
          ),
          if(!AuthService.currentUser!.isAnonymous)ListTile(
            onTap: () {},
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
