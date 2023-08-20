import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
showMsg(BuildContext context, String msg) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength:
      Toast.LENGTH_SHORT, // Duration for which the toast should be visible
      gravity: ToastGravity.BOTTOM, // Toast position
      backgroundColor: Colors.black54, // Background color of the toast
      textColor: Colors.white,
      fontSize: 20, // Text color of the toast
    );

String getFormattedDate(DateTime dt, {String pattern = 'dd MMMM yyyy'}) {
  return DateFormat(pattern).format(dt);
}

Future<bool> isConnectedToInternet() async {
  final result = await Connectivity().checkConnectivity();
  return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}
String calculatePriceAfterDiscount(num price, num discount) {
  final discountAmount = (price * discount) / 100;
  return (price - discountAmount).toStringAsFixed(0);
}
String get generatedId=>'MO_${getFormattedDate(DateTime.now(),pattern: 'yyyyMMdd_HH:mm')}';