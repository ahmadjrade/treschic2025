// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/controller/topup_history_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/recharge_cart_model.dart';
import 'package:fixnshop_admin/model/topup_history_model.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/Recharge/add_recharge_card.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Topup_History extends StatelessWidget {
  int B_id;
  String B_Name;

  Topup_History({super.key, required this.B_id, required this.B_Name});
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  final TopupHistoryController topupHistoryController =
      Get.find<TopupHistoryController>();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  @override
  Widget build(BuildContext context) {
    if (topupHistoryController.topup_history.isEmpty) {
      topupHistoryController.fetch_topup_history();
    }
    Username = sharedPreferencesController.username;
    String Format2(Date) {
      String time8Hour = '';
      DateTime parsedDate = DateFormat.Hms().parse(Date);

      time8Hour = DateFormat('yyyy-MM-dd').format(parsedDate);
      return time8Hour;
    }

    String Format(time24Hour) {
      String time8Hour = '';
      DateTime parsedTime = DateFormat.Hms().parse(time24Hour);

      time8Hour = DateFormat('h:mm a').format(parsedTime);
      return time8Hour;
    }

    List<TopupHistoryModel> filteredProductDetails() {
      return topupHistoryController.topup_history
          .where((topup) =>
              topup.Balance_id == (B_id) && topup.Username == Username.value)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            '$B_Name Balance',
            style: TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          )),
          IconButton(
            color: Colors.blue.shade900,
            iconSize: 24.0,
            onPressed: () {
              topupHistoryController.isDataFetched = false;
              topupHistoryController.fetch_topup_history();
              // categoryController.g =false;
              // categoryController.fetchcategories();
            },
            icon: Icon(CupertinoIcons.refresh),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(
                () {
                  final List<TopupHistoryModel> filteredcarts =
                      filteredProductDetails();
                  if (topupHistoryController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (topupHistoryController.topup_history.isEmpty) {
                    return Center(child: Text('No Topup Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filteredcarts.length,
                      itemBuilder: (context, index) {
                        final TopupHistoryModel topup = filteredcarts[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            margin: EdgeInsets.all(2),

                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // topup.Cart_Image != null
                                  //     ? SizedBox(
                                  //         child: Image.network(
                                  //         topup.Cart_Image!,
                                  //         scale: 3,
                                  //       ))
                                  //     : Placeholder(),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '#' +
                                            topup.Topup_id.toString() +
                                            ' || ' +
                                            'Topup Ammount : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        addCommasToNumber(topup.Topup_Ammount)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.red.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Store: ' + topup.Username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        (topup.Date).toString() +
                                            ' - ' +
                                            Format(topup.Time),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            // controlAffinity: ListTileControlAffinity.leading,
                            // children: <Widget>[
                            //   Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 0.0),
                            //     child: Column(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceAround,
                            //       children: [
                            //         Visibility(
                            //           visible: topupHistoryController
                            //               .isadmin(Username.value),
                            //           child: IconButton(
                            //               color: Colors.red,
                            //               onPressed: () {
                            //                 showDialog(
                            //                   context: context,
                            //                   builder: (BuildContext context) {
                            //                     return AlertDialog(
                            //                       title: Text(
                            //                           'Update Item Quantity'),
                            //                       content: TextField(
                            //                         keyboardType:
                            //                             TextInputType.number,
                            //                         controller: New_Qty,
                            //                         decoration: InputDecoration(
                            //                             hintText:
                            //                                 'Enter New Quantity'),
                            //                       ),
                            //                       actions: <Widget>[
                            //                         TextButton(
                            //                           onPressed: () {
                            //                             Navigator.of(context)
                            //                                 .pop();
                            //                           },
                            //                           child: Text('Cancel'),
                            //                         ),
                            //                         TextButton(
                            //                           onPressed: () {
                            //                             if (New_Qty.text !=
                            //                                 '') {
                            //                               showDialog(
                            //                                   // The user CANNOT close this dialog  by pressing outsite it
                            //                                   barrierDismissible:
                            //                                       false,
                            //                                   context: context,
                            //                                   builder: (_) {
                            //                                     return Dialog(
                            //                                       // The background color
                            //                                       backgroundColor:
                            //                                           Colors
                            //                                               .white,
                            //                                       child:
                            //                                           Padding(
                            //                                         padding: const EdgeInsets
                            //                                             .symmetric(
                            //                                             vertical:
                            //                                                 20),
                            //                                         child:
                            //                                             Column(
                            //                                           mainAxisSize:
                            //                                               MainAxisSize
                            //                                                   .min,
                            //                                           children: [
                            //                                             // The loading indicator
                            //                                             CircularProgressIndicator(),
                            //                                             SizedBox(
                            //                                               height:
                            //                                                   15,
                            //                                             ),
                            //                                             // Some text
                            //                                             Text(
                            //                                                 'Loading')
                            //                                           ],
                            //                                         ),
                            //                                       ),
                            //                                     );
                            //                                   });
                            //                               topupHistoryController.UpdateProductQty(
                            //                                       topup.PD_id
                            //                                           .toString(),
                            //                                       New_Qty.text)
                            //                                   .then((value) => showToast(
                            //                                       topupHistoryController
                            //                                           .result2))
                            //                                   .then((value) =>
                            //                                       topupHistoryController
                            //                                               .isDataFetched =
                            //                                           false)
                            //                                   .then((value) =>
                            //                                       topupHistoryController
                            //                                           .fetchproductdetails())
                            //                                   .then((value) =>
                            //                                       Navigator.of(context)
                            //                                           .pop())
                            //                                   .then((value) =>
                            //                                       Navigator.of(context).pop());

                            //                               New_Qty.clear();
                            //                             } else {
                            //                               Get.snackbar('Error',
                            //                                   'Add New Quantity');
                            //                             }

                            //                             // Do something with the text, e.g., save it
                            //                             //  String enteredText = _textEditingController.text;
                            //                             //  print('Entered text: $enteredText');
                            //                             // Close the dialog
                            //                           },
                            //                           child: Text('OK'),
                            //                         ),
                            //                       ],
                            //                     );
                            //                   },
                            //                 );
                            //               },
                            //               icon: Icon(Icons.edit)),
                            //         ),
                            //         Text('Total Quantity Bought: ' +
                            //             topup.Product_Max_Quantity
                            //                 .toString()),
                            //         SizedBox(
                            //           height: 5,
                            //         ),
                            //         Text('Total Quantity Sold: ' +
                            //             topup.Product_Sold_Quantity
                            //                 .toString()),
                            //         SizedBox(
                            //           height: 20,
                            //         ),
                            //         // Text('id' + topup.PD_id.toString()),
                            //         // SizedBox(
                            //         //   height: 20,
                            //         // ),

                            //         // Text('Total Price of Treatment:  ${treatments.!}\$ '),
                            //       ],
                            //     ),
                            //   )
                            // ],
                            //  subtitle: Text(topup.Product_Brand),
                            // trailing: OutlinedButton(
                            //   onPressed: () {

                            //     // productController.SelectedPhone.value = topup;
                            //     //       // product_detailsController.selectedproduct_details.value =
                            //     //       //     null;

                            //               Get.to(() => Topup_History(Balance_id: topup.Balance_id.toString(), Product_Name: topup.Product_Name,Product_Color: topup.Product_Color,));
                            //   },
                            //   child: Text('Select')),
                            // // Add more properties as needed
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
