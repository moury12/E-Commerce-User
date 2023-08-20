import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';

const String collectionUser = 'Users';

const String userFieldId = 'userId';
const String userFieldDisplayName = 'displayName';
const String userFieldAddressModel = 'addressModel';
const String userFieldCreationTime = 'CreationTime';
const String userFieldGender = 'userToken';
const String userFieldAge = 'age';
const String userFieldPhone = 'phone';
const String userFieldEmail = 'email';
const String userFieldImageUrl = 'imageUrl';

class UserModel {
  String userId;
  String? displayName;
  AddressModel? addressModel;
  Timestamp? userCreationTime;
  String? token;
  String? age;
  String? phone;
  String email;
  String? imageUrl;

  UserModel(
      {required this.userId,
      this.displayName,
      this.addressModel,
      this.userCreationTime,
      this.token,
      this.age,
      this.phone,
      this.imageUrl,
      required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userFieldId: userId,
      userFieldDisplayName: displayName,
      userFieldAddressModel: addressModel?.toMap(),
      userFieldCreationTime: userCreationTime,
      userFieldGender: token,
      userFieldAge: age,
      userFieldPhone: phone,
      userFieldEmail: email,
      userFieldImageUrl: imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map[userFieldId],
        displayName: map[userFieldDisplayName],
        addressModel: map[userFieldAddressModel] == null
            ? null
            : AddressModel.fromMap(map[userFieldAddressModel]),
        userCreationTime: map[userFieldCreationTime],
        token: map[userFieldGender],
        age: map[userFieldAge],
        phone: map[userFieldPhone],
        email: map[userFieldEmail],
        imageUrl: map[userFieldImageUrl],
      );
}
