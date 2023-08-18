import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/models/user_model.dart';
import 'package:ecommerce_user/pages/otp_verification_page.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:ecommerce_user/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(resizeToAvoidBottomInset: false,
backgroundColor: Colors.white,
      body: userProvider.userModel == null
          ? Center(child: Text('Failed to load user data'),)
          :Column(
            children: [
              Stack(clipBehavior: Clip.none,
        children: [
              Container(
                child: Image.asset('assets/profile.jpg'),
              ),
              Positioned(top: 130,bottom: -50,
                  left: 0,right: 0,
                  child: _headerSection(context, userProvider)),
          Positioned(top: 80,bottom: 30,left: 130,

            child: Padding(
              padding: const EdgeInsets.all(8),
              child: userProvider.userModel!.imageUrl == null
                  ? ClipOval(
                child: Image.asset(
                  'assets/s.png',
                  height:80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              )
                  : ClipOval(
                child: CachedNetworkImage(
                  filterQuality: FilterQuality.none,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: userProvider.userModel!
                      .imageUrl!,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      ),
              ListTile(
                leading: Icon(IconlyLight.call,color: Colors.deepPurple.shade200,),
                subtitle: Text(
                  userProvider.userModel!.phone ??'Not set yet',
                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                ),  title:  Text('Phone',
                  style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900)),
                trailing: IconButton(
                  onPressed:()  {
                    showSingleTextInputDialogOtp(
                        context: context,
                        title: 'Mobile No',
                        onSubmit: (value) {
                          Navigator.pushNamed(
                              context, OtpVerification.routeName,
                              arguments: value);
                        });
                  },


                  icon:  Icon(
                    IconlyBold.edit,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(IconlyLight.calendar,color: Colors.deepPurple.shade200,),
                subtitle: Text(
                  userProvider.userModel!.age ??'Not set yet',
                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                ),  title:  Text('Age',
                  style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900)),
                trailing: IconButton(
                  onPressed:()  {
                    showSingleTextInputDialog(context: context, title: 'Age', onSubmit:(value){
                      userProvider.updateUserField('$userFieldAge', value);
                    });
                  },


                  icon:  Icon(
                    IconlyBold.edit,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(IconlyLight.profile,color: Colors.deepPurple.shade200,),
                subtitle: Text(
                  userProvider.userModel!.gender  ??'Not set yet',
                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                ),  title:  Text('Gender',
                  style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900)),
                trailing: IconButton(
                  onPressed:()  {
    showSingleTextInputDialog(context: context, title: 'Gender', onSubmit:(value){
    userProvider.updateUserField('$userFieldGender', value);
    });

                  },


                  icon:  Icon(
                    IconlyBold.edit,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(IconlyLight.location,color: Colors.deepPurple.shade200,),
                subtitle: Text(
                  userProvider.userModel!.addressModel?.addressLine1  ??'Not set yet',
                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                ),  title:  Text('Current Address',
                  style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900)),
                trailing: IconButton(
                  onPressed:()  { showSingleTextInputDialog(context: context, title: 'Address Line-1', onSubmit:(value){
        userProvider.updateUserField('$userFieldAddressModel.$addressFieldAddressLine1', value);
       });
                  },


                  icon:  Icon(
                    IconlyBold.edit,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(IconlyLight.graph,color: Colors.deepPurple.shade200,),
                subtitle: Text(
                  userProvider.userModel!.addressModel?.zipcode ??'Not set yet',
                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                ),  title:  Text('Postal Code',
                  style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900)),
                trailing: IconButton(
                  onPressed:()  {
    showSingleTextInputDialog(context: context, title: 'Zip-Code', onSubmit:(value){
                       userProvider.updateUserField('$userFieldAddressModel.$addressFieldZipcode', value);
                      });
                  },


                  icon:  Icon(
                    IconlyBold.edit,
                    color: Colors.deepPurple.shade200,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(IconlyBold.location,color: Colors.deepPurple.shade200,),
                subtitle: Text(
                  userProvider.userModel!.addressModel?.city ??'Not set yet',
                  style: TextStyle(color: Colors.grey,fontSize: 12,),
                ),  title:  Text('City',
                  style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900)),
                trailing: IconButton(
                  onPressed:()  {
    showSingleTextInputDialog(context: context, title: 'City', onSubmit:(value){
                       userProvider.updateUserField('$userFieldAddressModel.$addressFieldCity', value);
                      });
                  },


                  icon:  Icon(
                    IconlyBold.edit,
                    color: Colors.deepPurple.shade200,
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            FittedBox(
              child: Row(
                children: [
                  Text(
                    userProvider.userModel!.displayName ?? 'No Display Name',
              style: GoogleFonts.adamina(fontSize: 12,color: Colors.black54, fontWeight: FontWeight.w900),maxLines: 1,textAlign: TextAlign.center,
                  ),userProvider.userModel!.displayName==null ?
                  IconButton(onPressed: (){
                    showSingleTextInputDialog(context: context, title: "User Name", onSubmit: (value){
                      userProvider.updateUserField(userFieldDisplayName, value);
                    });
                  },  icon: Icon(Icons.edit,size:15,))
                :Text('')],
              ),
            ),
SizedBox(height: 5,),
            Text(
              userProvider.userModel!.email ?? 'No email',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

}
