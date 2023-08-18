import 'package:ecommerce_user/pages/view_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Dashboard.dart';

class LauncherScreen extends StatelessWidget {
  static const String routeName = '/first';

  const LauncherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/app1.jpg',fit: BoxFit.cover,height: double.infinity,),
          Positioned( bottom: 100,left: 20,
              child: FittedBox(child: Text('Enjoy the\nTastiest cake\nNear you',style: GoogleFonts.adamina(color: Colors.white, fontSize: 32,fontWeight: FontWeight.w700),))),
          Positioned(bottom: 40,right: 20,
            child: FloatingActionButton.extended(backgroundColor: Colors.deepPurple.shade900,
              onPressed: (){
              Navigator.pushReplacementNamed(context, DashBoard.routeName);
              },label: Row(
              children: [
                Text('Get Started',style: GoogleFonts.adamina()),
                Icon(IconlyLight.arrowRight)
              ],
            ),heroTag: 12,),
          )
        ],
      ),
    );
  }
}
