import 'package:ecommerce_user/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
enum SdkType { TESTBOX, LIVE }
class OrderSuccessFullPage extends StatefulWidget {
  static const String routeName='/orderSuccessFull';
  OrderSuccessFullPage({Key? key }) : super(key: key);

  @override
  State<OrderSuccessFullPage> createState() => _OrderSuccessFullPageState();
}

class _OrderSuccessFullPageState extends State<OrderSuccessFullPage> {
  var _key = GlobalKey<FormState>();

  dynamic formData = {};

  SdkType _radioSelected = SdkType.TESTBOX;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Order Has been placed!',  style: GoogleFonts.adamina(fontSize: 20,
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: Text('Please complete payment process!',  style: GoogleFonts.adamina(fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.normal),
            ),
          ),
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: "demotest",
                        keyboardType: TextInputType.text,
                        style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                        decoration: InputDecoration(
                          hintStyle:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                          hintText: "demotest",
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0, color: Colors.transparent),),
                          enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

                            borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade200),),
                          prefixIcon: Icon(IconlyLight.unlock,color: Colors.deepPurple.shade700,size: 20,),
                        ),
                        validator: (value) {
                          if (value != null)
                            return "Please input store id";
                          else
                            return null;
                        },
                        onSaved: (value) {
                          formData['store_id'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: "qwerty",
                        keyboardType: TextInputType.text,
                        style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                        decoration: InputDecoration(
                          hintStyle:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                          hintText: "demotest",
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0, color: Colors.transparent),),
                          enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

                            borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade200),),
                          prefixIcon: Icon(IconlyLight.unlock,color: Colors.deepPurple.shade700,size: 20,),
                        ),
                        validator: (value) {
                          if (value != null)
                            return "Please input store password";
                          else
                            return null;
                        },
                        onSaved: (value) {
                          formData['store_password'] = value;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: SdkType.TESTBOX,
                          groupValue: _radioSelected,
                          activeColor: Colors.deepPurpleAccent,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as SdkType;
                            });
                          },
                        ),
                        Text("TEXTBOX",style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade300,fontWeight: FontWeight.bold)),
                        Radio(
                          value: SdkType.LIVE,
                          groupValue: _radioSelected,
                          activeColor: Colors.deepPurpleAccent,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as SdkType;
                            });
                          },
                        ),
                        Text('LIVE',style: GoogleFonts.adamina(fontSize: 12,color: Colors.deepPurple.shade300,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                        decoration: InputDecoration(
                          hintStyle:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                          hintText: "phone number",
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0, color: Colors.transparent),),
                          enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

                            borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade200),),
                          prefixIcon: Icon(IconlyLight.call,color: Colors.deepPurple.shade700,size: 20,),
                        ),
                        onSaved: (value) {
                          formData['phone'] = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: "10",
                        // keyboardType: TextInputType.number,
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                        decoration: InputDecoration(
                          hintStyle:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                          hintText: "payment amount",
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0, color: Colors.transparent),),
                          enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

                            borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade200),),
                          prefixIcon: Icon(Icons.monetization_on_outlined,color: Colors.deepPurple.shade700,size: 20,),
                        ),
                        validator: (value) {
                          if (value != null)
                            return "Please input amount";
                          else
                            return null;
                        },
                        onSaved: (value) {
                          formData['amount'] = double.parse(value!);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                        decoration: InputDecoration(
                          hintStyle:GoogleFonts.adamina(fontSize: 12,color: Colors.black54) ,
                          hintText: "Enter multicard",
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(width: 0, color: Colors.transparent),),
                          enabledBorder: OutlineInputBorder(          borderRadius: BorderRadius.circular(50),

                            borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade200),),
                          prefixIcon: Icon(IconlyLight.wallet,color: Colors.deepPurple.shade700,size: 20,),
                        ),
                        onSaved: (value) {
                          formData['multicard'] = value;
                        },
                      ),
                    ),  InkWell(hoverColor: Colors.grey.withOpacity(1),
                      onTap:() {
                        if (_key.currentState != null) {
                          _key.currentState?.save();
                          print(_radioSelected);
                          sslCommerzGeneralCall();
                          // sslCommerzCustomizedCall();
                        }
                      },
                      child: FittedBox(
                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0)
                                  .copyWith(top: 10, bottom: 10),
                              child: Text('Pay now',
                                  style: GoogleFonts.monda(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              gradient: LinearGradient(colors: [
                                Colors.deepPurple.shade200,
                                Colors.lightBlue.shade200,
                              ]),
                            )),
                      ),
                    )
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),),
    );
  }

  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: _radioSelected == SdkType.TESTBOX
            ? SSLCSdkType.TESTBOX
            : SSLCSdkType.LIVE,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: formData['amount'],
        tran_id: "1231123131212",
      ),
    );
    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction is Failed....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "SDK Closed by User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
            msg:
            "Transaction is ${result.status} and Amount is ${result.amount}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sslCommerzCustomizedCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.LIVE,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: formData['amount'],
        tran_id: "1231321321321312",
      ),
    );

    sslcommerz
        .addEMITransactionInitializer(
        sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
            emi_options: 1, emi_max_list_options: 9, emi_selected_inst: 0))
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: 5,
            shipmentDetails: ShipmentDetails(
                shipAddress1: "Ship address 1",
                shipCity: "Faridpur",
                shipCountry: "Bangladesh",
                shipName: "Ship name 1",
                shipPostCode: "7860")))
        .addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "Chattogram",
        customerName: "Abu Sayed Chowdhury",
        customerEmail: "sayem227@gmail.com",
        customerAddress1: "Anderkilla",
        customerCity: "Chattogram",
        customerPostCode: "200",
        customerCountry: "Bangladesh",
        customerPhone: formData['phone'],
      ),
    )
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
        productName: "Water Filter",
        productCategory: "Widgets",
        general: General(
        general: "General Purpose",
        productProfile: "Product Profile",
    ),
    )
    )
        .addAdditionalInitializer(
      sslcAdditionalInitializer: SSLCAdditionalInitializer(
        valueA: "value a ",
        valueB: "value b",
        valueC: "value c",
        valueD: "value d",
      ),
    );

    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
            msg: "Transaction is Failed....",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
          msg: "Transaction is ${result.status} and Amount is ${result.amount}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

