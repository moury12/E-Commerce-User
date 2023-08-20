
import 'package:ecommerce_user/pages/Dashboard.dart';
import 'package:ecommerce_user/pages/cart_page.dart';
import 'package:ecommerce_user/pages/checkout_page.dart';
import 'package:ecommerce_user/pages/launcher_page.dart';
import 'package:ecommerce_user/pages/launcher_screen.dart';
import 'package:ecommerce_user/pages/orderSuccessfull_page.dart';
import 'package:ecommerce_user/pages/otp_verification_page.dart';
import 'package:ecommerce_user/pages/user_profile.dart';
import 'package:ecommerce_user/providers/notification_provider.dart';
import 'package:ecommerce_user/providers/order_provider.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/providers/wishList_provide.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'pages/product_details_page.dart';
import 'pages/wish_list_page.dart';
import 'pages/view_product_page.dart';
import 'providers/product_provider.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.data}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.subscribeToTopic('promo');
  await FirebaseMessaging.instance.subscribeToTopic('newproduct');
  print('FCM TOKEN $fcmToken');
  DateTime dateTime = DateTime.now();
  String formattedDate = getFormattedDate(dateTime);
  print(formattedDate);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider( providers: [
    ChangeNotifierProvider(create: (context)=>UserProvider()),
  ChangeNotifierProvider(create: (context)=>ProductProvider()),
  ChangeNotifierProvider(create: (context)=>OrderProvider()),
    ChangeNotifierProvider(create: (context)=>CartProvider()),
    ChangeNotifierProvider(create: (context)=>WishListProvider()),
    ChangeNotifierProvider(create: (context)=>NotificationProvider()),
  ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
@override
  void initState() {
  WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
WidgetsBinding.instance.removeObserver(this);
super.dispose();
  }
 //  @override
 //  void didChangeAppLifecycleState(AppLifecycleState state) {
 // switch(state){
 //   case AppLifecycleState.paused:
 //     break;
 //     case AppLifecycleState.inactive:
 //       AuthService.currentUser!.isAnonymous?
 //    AuthService.logout():
 //           null;
 //     break;
 //     case AppLifecycleState.resumed:
 //     break;
 //     case AppLifecycleState.detached:
 //     break;
 // }
 //    super.didChangeAppLifecycleState(state);
 //  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lavender bakery',
      theme: ThemeData(
textTheme: GoogleFonts.nanumMyeongjoTextTheme(),
        primarySwatch: Colors.deepPurple,
      ),
      builder: EasyLoading.init(),
initialRoute: LauncherPage.routeName,
      routes:{

        LauncherPage.routeName: (_) => const LauncherPage(),
        LauncherScreen.routeName:(context) => LauncherScreen(),
        DashBoard.routeName:(context) => DashBoard(),
        LoginPage.routeName: (_) => const LoginPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        WishListPage.routeName: (_) => const WishListPage(),
        UserProfile.routeName:(_)=> const UserProfile(),
        OtpVerification.routeName:(_)=> const OtpVerification(),
        CartPage.routeName:(_)=>  CartPage(),
        CheckOutPage.routeName:(_)=> const CheckOutPage(),
        OrderSuccessFullPage.routeName:(_)=> OrderSuccessFullPage(),
      },
    );
  }
}

