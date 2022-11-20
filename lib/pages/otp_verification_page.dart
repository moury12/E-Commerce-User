import 'package:ecommerce_user/auth/authservice.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerification extends StatefulWidget {
  static const String routeName = 'otp';
  const OtpVerification({Key? key}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  late String phone;
  final textEditingController = TextEditingController();
  bool isFirst = true;
  String vid = '';
  @override
  void didChangeDependencies() {
    if (isFirst) {
      phone = ModalRoute.of(context)!.settings.arguments as String;
      _sendVerificationCode();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Verify Phone Number',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'An OTP code is sent to your mobile number. Enter the OTP Code below',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              phone,
              textAlign: TextAlign.center,
              //style: Theme.of(context).textTheme.headline5,
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PinCodeTextField(

              appContext: context,
              length: 6,
              obscureText: false,
              obscuringCharacter: '*',
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                inactiveColor: Colors.purple.shade100,
                selectedColor: Colors.white,
               activeColor: Colors.pink.shade100,
                selectedFillColor: Colors.deepPurpleAccent.shade100,
                inactiveFillColor: Colors.white
              ),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v){
                debugPrint('Completed');
              },
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                });
              },
              beforeTextPaste: (text){
                debugPrint('Allowing to Paste $text');
                return true;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                _verify();
              },
              child: const Text('SEND'),
            ),
          )
        ],
      ),
    );
  }

  void _sendVerificationCode() async{
    CircularProgressIndicator();
    await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential){
      print('Verification Completed');
    }, verificationFailed: (FirebaseAuthException e){
      showMsg(context, 'Verification Failed');
    }, codeSent: (String verficationId ,int? resendToken){
      vid =verficationId;
      showMsg(context, 'Code Sent');
    }, codeAutoRetrievalTimeout: (String verficationId){

    });
    EasyLoading.dismiss();
  }

  void _verify() {
EasyLoading.show(status: 'Verifying, Please wait');
PhoneAuthCredential credential =PhoneAuthProvider.credential(verificationId: vid, smsCode: textEditingController.text);
AuthService.currentUser!.linkWithCredential(credential).then((value) { Provider.of<UserProvider>(context,listen:  false).updateUserField(userFieldPhone, phone).then((value){
 EasyLoading.dismiss();
 showMsg(context, 'Phone Verification successful');
 Navigator.pop(context);
});}).catchError((error){
  print(error.toString());
});

  }
  @override
  void dispose() {
   textEditingController.dispose();
    super.dispose();
  }
}
