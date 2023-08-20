
import 'package:ecommerce_user/pages/Dashboard.dart';
import 'package:ecommerce_user/pages/launcher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/authservice.dart';
import 'login_page.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (AuthService.currentUser != null) {
        Navigator.pushReplacementNamed(context, DashBoard.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/app1.jpg',fit: BoxFit.cover,height: double.infinity,),
          Positioned( bottom: 100,left: 20,
              child: FittedBox(child: Text('Enjoy the\nTastiest cake\nNear you',style: GoogleFonts.adamina(color: Colors.white, fontSize: 32,fontWeight: FontWeight.w700),))),
          Positioned(bottom: 40,right: 20,
            child: FloatingActionButton.extended(backgroundColor: Colors.deepPurple.shade900,
              onPressed: (){
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
