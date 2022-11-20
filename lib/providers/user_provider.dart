
import 'package:ecommerce_user/auth/authservice.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
   UserModel? userModel;
  Future<void> addUser(UserModel userModel) {
    return DbHelper.addUser(userModel);
  }
  getUserInfo(){
DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
  if(snapshot.exists){
    userModel=UserModel.fromMap(snapshot.data()!);
    notifyListeners();
  }
});
  }
  Future<bool> doesUserExist(String uid) => DbHelper.doesUserExist(uid);
  Future<void>updateUserField( String felid, dynamic value){
    return DbHelper.updateUserField(AuthService.currentUser!.uid, {felid:value});
  }
}
