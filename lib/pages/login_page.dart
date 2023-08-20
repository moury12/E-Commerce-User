import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../auth/authservice.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../providers/notification_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = '';
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
        body: Stack(
      children: [
        Image.asset(
          'assets/app1.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
                child: Text(
              'LOGIN',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ))),
        Positioned(
            top: 250,
            left: 20,
            right: 20,
            child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          suffixIcon: Icon(Icons.email),
                          labelText: '   Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Provide a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          suffixIcon: Icon(Icons.key),
                          labelText: '   Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Provide a valid Password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
               SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _signInWithGoogle,
                      child: Container(
                        height: 40,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.network(
                                'https://altogethergroup.com.au/static/img/google-g-logo.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'Sign in with google',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.5,
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white70,
                            border: Border.all(color: Colors.white, width: 1)),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        loginAsGuest();
                      },
                      child: Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Login as guest',
                            style: GoogleFonts.monda(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.deepPurple.shade200,
                              Colors.lightBlue.shade200,
                            ]),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 1)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_errMsg,
                      style: TextStyle(
                          color: Colors.red.shade100,
                          fontWeight: FontWeight.bold,
                          fontSize: 7)),
                ),
              ]),
            )),
        Positioned(
          top: 350,
          left: 30,
          child: TextButton(
            onPressed: () {
              AuthService.forgotPassword();
              showMsg(context,
                  'A Password reset link has been sent to your email address');
            },
            child: Text(
              'Forget Password?',
              style: GoogleFonts.actor(
                  color: Colors.deepPurple.shade100,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 6,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _authenticate(true);
                  },
                  label: Text(
                    'login',
                    style: GoogleFonts.monda(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  backgroundColor: Colors.deepPurple.shade200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _authenticate(false);
                  },
                  label: Text(
                    'Register',
                    style: GoogleFonts.monda(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  backgroundColor: Colors.deepPurple.shade200,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate(bool tag) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        UserCredential credential;
        if (tag) {
          credential = await AuthService.login(email, password);
        } else {
          //reg for anonymous user
          if (AuthService.currentUser != null) {
            final credential =
                EmailAuthProvider.credential(email: email, password: password);
            await registerAnonymousUser(credential);
          } else {
            final fcmToken = await FirebaseMessaging.instance.getToken();

            //normal reg
            credential = await AuthService.register(email, password);
            final userModel = UserModel(
              token: fcmToken,
              userId: credential.user!.uid,
              email: credential.user!.email!,
              userCreationTime:
                  Timestamp.fromDate(credential.user!.metadata.creationTime!),

            );
            await userProvider.addUser(userModel);
            final notificationModel = NotificationModel(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                type: NotificationType.user,
                message: 'a new user${userModel.email} has joined',
                userModel: userModel);
            await Provider.of<NotificationProvider>(context, listen: false)
                .addNotification(notificationModel);
          }
        }
        EasyLoading.dismiss();
        if (mounted) {
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _signInWithGoogle() async {
    if (AuthService.currentUser != null) {
      final idToken = await AuthService.currentUser!.getIdToken();
      final credential = GoogleAuthProvider.credential(idToken: idToken);
    } else {
      try {
        final credential = await AuthService.signInWithGoogle();
        final userExist =
            await userProvider.doesUserExist(credential.user!.uid);
        if (!userExist) {
          EasyLoading.show(status: 'redirecting...');
          final userModel = UserModel(
              userId: credential.user!.uid,
              email: credential.user!.email!,
              displayName: credential.user!.displayName,
              imageUrl: credential.user!.photoURL,
              userCreationTime: Timestamp.fromDate(DateTime.now()));
          await userProvider.addUser(userModel);
          EasyLoading.dismiss();
        }
        if (mounted) {
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      } catch (error) {
        EasyLoading.dismiss();
        rethrow;
      }
    }
  }

  void loginAsGuest() {
    EasyLoading.show(status: 'Please wait');
    AuthService.loginAsGuest().then((value) {
      EasyLoading.dismiss();
      Navigator.pushReplacementNamed(context, LauncherPage.routeName);
    }).catchError((error) {
      EasyLoading.dismiss();
    });
  }

  Future<void> registerAnonymousUser(AuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
      if (userCredential!.user != null) {
        final userModel = UserModel(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          userCreationTime:
              Timestamp.fromDate(userCredential.user!.metadata.creationTime!),
        );
        await userProvider.addUser(userModel);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }
}
