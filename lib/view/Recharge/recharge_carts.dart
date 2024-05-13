// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/recharge_cart_model.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/Recharge/add_recharge_card.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RechargeCarts extends StatelessWidget {
  int Type_id;
  String Type_Name;

  RechargeCarts({super.key, required this.Type_id, required this.Type_Name});
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  final RechargeCartController rechargeCartController =
      Get.find<RechargeCartController>();

  //TextEditingController New_Qty = TextEditingController();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  // TextEditingController Product_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    // Future<void> showToast(result) async {
    //   final snackBar2 = SnackBar(
    //     content: Text(result),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    // }

    // rechargeCartController.isDataFetched = false;
    // rechargeCartController.fetchproductdetails();
    List<RechargeCartModel> filteredProductDetails() {
      return rechargeCartController.recharge_carts
          .where((carts) => carts.Card_Type == (Type_id))
          .toList();
    }

    //  rechargeCartController.product_detail.clear();
    // rechargeCartController.isDataFetched = false;
    //  rechargeCartController.fetchproductdetails(Type_id);
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            '$Type_Name Recharge Cards',
            overflow: TextOverflow.ellipsis,
          )),
          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              Get.to(() => AddRechargeCard(
                    Type_id: Type_id,
                  ));
            },
            icon: Icon(CupertinoIcons.add),
          ),
          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              rechargeCartController.isDataFetched = false;
              rechargeCartController.fetch_recharge_carts();
              // categoryController.isDataFetched =false;
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
                  final List<RechargeCartModel> filteredcarts =
                      filteredProductDetails();
                  if (rechargeCartController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (rechargeCartController.recharge_carts.isEmpty) {
                    return Center(child: Text('No Carts Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filteredcarts.length,
                      itemBuilder: (context, index) {
                        final RechargeCartModel carts = filteredcarts[index];
                        return Container(
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          //     padding: EdgeInsets.all(35),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                onTap: () {
                                  rechargeCartController
                                      .fetchcards(carts.Card_Name);
                                },
                                // collapsedTextColor: Colors.black,
                                // textColor: Colors.black,
                                // backgroundColor: Colors.deepPurple.shade100,
                                //   collapsedBackgroundColor: Colors.white,
                                leading: carts.Card_Image == null ||
                                        carts.Card_Image == ''
                                    ? SizedBox(
                                        width: 100,
                                        child: Column(
                                          children: [
                                            Text('No Image'),
                                            Icon(
                                              Icons.error,
                                            ),
                                          ],
                                        ))
                                    : CachedNetworkImage(
                                        width: 100,
                                        imageUrl: carts.Card_Image!,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // carts.Cart_Image != null
                                    //     ? SizedBox(
                                    //         child: Image.network(
                                    //         carts.Cart_Image!,
                                    //         scale: 3,
                                    //       ))
                                    //     : Placeholder(),

                                    Text(
                                      carts.Card_Name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  addCommasToNumber(carts.Card_Price)
                                          .toString() +
                                      ' LL',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.green.shade900),
                                )

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
                                //           visible: rechargeCartController
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
                                //                               rechargeCartController.UpdateProductQty(
                                //                                       carts.PD_id
                                //                                           .toString(),
                                //                                       New_Qty.text)
                                //                                   .then((value) => showToast(
                                //                                       rechargeCartController
                                //                                           .result2))
                                //                                   .then((value) =>
                                //                                       rechargeCartController
                                //                                               .isDataFetched =
                                //                                           false)
                                //                                   .then((value) =>
                                //                                       rechargeCartController
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
                                //             carts.Product_Max_Quantity
                                //                 .toString()),
                                //         SizedBox(
                                //           height: 5,
                                //         ),
                                //         Text('Total Quantity Sold: ' +
                                //             carts.Product_Sold_Quantity
                                //                 .toString()),
                                //         SizedBox(
                                //           height: 20,
                                //         ),
                                //         // Text('id' + carts.PD_id.toString()),
                                //         // SizedBox(
                                //         //   height: 20,
                                //         // ),

                                //         // Text('Total Price of Treatment:  ${treatments.!}\$ '),
                                //       ],
                                //     ),
                                //   )
                                // ],
                                //  subtitle: Text(carts.Product_Brand),
                                // trailing: OutlinedButton(
                                //   onPressed: () {

                                //     // productController.SelectedPhone.value = carts;
                                //     //       // product_detailsController.selectedproduct_details.value =
                                //     //       //     null;

                                //               Get.to(() => RechargeCarts(Type_id: carts.Type_id.toString(), Product_Name: carts.Product_Name,Product_Color: carts.Product_Color,));
                                //   },
                                //   child: Text('Select')),
                                // // Add more properties as needed
                                ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Card(
              color: Colors.grey.shade300,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Carts:'),
                        Text(rechargeCartController.totalQty.toString()),
                        Text('Total:'),
                        Text(addCommasToNumber(
                                    rechargeCartController.totalLb.value)
                                .toString() +
                            ' LL'),
                      ],
                    );
                  })),
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
