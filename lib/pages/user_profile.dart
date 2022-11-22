import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/pages/otp_verification_page.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address_model.dart';
import '../utils/widget_function1.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = '/profile';
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: userProvider.userModel == null
          ? Center(child: Text('Failed to load user data'),)
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: _headerSection(context, userProvider),
                ),
                Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    title: Text(
                      userProvider.userModel!.phone ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),  subtitle: const Text('Phone'),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialogOtp(context:context, title: 'Mobile No', onSubmit: (value){
Navigator.pushNamed(context, OtpVerification.routeName,arguments: value);
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    title: Text(
                      userProvider.userModel!.age ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),  subtitle: const Text('Age'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      userProvider.userModel!.gender ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),  subtitle: const Text('Gender'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),  subtitle: const Text('Current Address'),
                    title: Text(
                      userProvider.userModel!.addressModel?.addressLine1 ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(context: context, title: 'Address Line-1', onSubmit:(value){
                          userProvider.updateUserField('$userFieldAddressModel.$addressFieldAddressLine1', value);
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),  subtitle: const Text('City'),
                    title: Text(
                      userProvider.userModel!.addressModel?.addressLine2 ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () {   showSingleTextInputDialog(context: context, title: 'Address Line-2', onSubmit:(value){
                        userProvider.updateUserField('$userFieldAddressModel.$addressFieldAddressLine2', value);
                      });},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ), Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),  subtitle: const Text('City'),
                    title: Text(
                      userProvider.userModel!.addressModel?.city ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),  Card(
                  color: Colors.cyan,
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),  subtitle: const Text('Zip Code'),
                    title: Text(
                      userProvider.userModel!.addressModel?.zipcode ?? 'Not set yet',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () {   showSingleTextInputDialog(context: context, title: 'Zip-Code', onSubmit:(value){
                        userProvider.updateUserField('$userFieldAddressModel.$addressFieldZipcode', value);
                      });},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Container _headerSection(BuildContext context, UserProvider userProvider) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.pinkAccent.shade100),
      child: SingleChildScrollView(  scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: userProvider.userModel!.imageUrl == null
                      ? ClipOval(
                        child: Image.asset(
                            'assets/s.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                      )
                      : ClipOval(
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.none,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            imageUrl: userProvider.userModel!
                                .imageUrl!,
                            placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userProvider.userModel!.displayName ?? 'No Display Name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),userProvider.userModel!.displayName==null ?
                    IconButton(onPressed: (){
                      showSingleTextInputDialog(context: context, title: "User Name", onSubmit: (value){
                        userProvider.updateUserField(userFieldDisplayName, value);
                      });
                    },  icon: Icon(Icons.edit,size:15,))
                  :Text('')],
                ),

                Text(
                  userProvider.userModel!.email ?? 'No email',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
