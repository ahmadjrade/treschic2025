// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/credit_balance_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/platform_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/cart_types_model.dart';
import 'package:fixnshop_admin/model/recharge_balance_model.dart';
import 'package:fixnshop_admin/view/Recharge/add_recharge_balance.dart';
import 'package:fixnshop_admin/view/Recharge/add_recharge_type.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_carts.dart';
import 'package:fixnshop_admin/view/Recharge/topup_history.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

class RechargeBalance extends StatelessWidget {
  RechargeBalance({super.key});
  final RechargeBalanceController rechargeBalanceController =
      Get.find<RechargeBalanceController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
       final PlatformController platformController =
      Get.find<PlatformController>();
  RxString Username = ''.obs;
  TextEditingController Type_Name = TextEditingController();
  TextEditingController New_Balance = TextEditingController();
  TextEditingController Edit_Balance = TextEditingController();

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    // rechargeBalanceController.fetchcarts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Recharge Balances'),
          // IconButton(
          //   color: Colors.deepPurple,
          //   iconSize: 24.0,
          //   onPressed: () {
          //     Get.toNamed('/NewCat');
          //   },
          //   icon: Icon(CupertinoIcons.add),
          // ),
          Row(
            children: [
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  Get.to(AddRechargeBalance());
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.add),
              ),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  rechargeBalanceController.isDataFetched = false;
                  rechargeBalanceController.fetch_cart_types();
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.refresh),
              ),
            ],
          ),
        ],
      )),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Obx(() {
          //           Type_Name.text = barcodeController.barcode3.value;
          //           return TextField(
          //             controller: Type_Name,
          //             onChanged: (query) {
          //               rechargeBalanceController.carts.refresh();
          //             },
          //             decoration: InputDecoration(
          //               labelText: 'Search by Name or Code',
          //               prefixIcon: Icon(Icons.search),
          //             ),
          //           );
          //         }),
          //       ),
          //       SizedBox(
          //         width: 15,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          //         child: IconButton(
          //           icon: Icon(Icons.qr_code_scanner_rounded),
          //           color: Colors.black,
          //           onPressed: () {
          //             barcodeController
          //                 .scanBarcodeSearch()
          //                 .then((value) => set());
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
              () {
                final List<RechargeBalanceModel> filteredcarts =
                    rechargeBalanceController.searchTypes(Username.value);
                if (rechargeBalanceController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (rechargeBalanceController.balance.isEmpty) {
                  return Center(
                      child: Text('No Recharge Balances Yet ! Add Some '));
                } else {
                  return ListView.builder(
                    itemCount: filteredcarts.length,
                    itemBuilder: (context, index) {
                      final RechargeBalanceModel balance = filteredcarts[index];
                      return Container(
                        //  width: double.infinity,
                        //   height: 150.0,
                        color: Colors.grey.shade200,
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        //     padding: EdgeInsets.all(35),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            onTap: () {
                              // Get.to(() => RechargeCarts(
                              //       Type_id: balance.t,
                              //       Type_Name: balance.Type_Name,
                              //     ));
                            },
                            // leading:
                            //     balance.Type_Image == null || balance.Type_Image == ''
                            //         ? SizedBox(
                            //             width: 75,
                            //             child: Column(
                            //               children: [
                            //                 Text('No Image'),
                            //                 Icon(
                            //                   Icons.error,
                            //                 ),
                            //               ],
                            //             ))
                            //         : CachedNetworkImage(
                            //             width: 75,
                            //             imageUrl: balance.Type_Image!,
                            //             placeholder: (context, url) => Center(
                            //                 child: CircularProgressIndicator()),
                            //             errorWidget: (context, url, error) =>
                            //                 Icon(Icons.error),
                            //           ),
                            // onLongPress: () {
                            //   copyToClipboard(balance.cart_Code);
                            // },
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Edit ' +
                                                        balance.Credit_Type +
                                                        ' Balance'),
                                                    content: TextField(
                                                      keyboardType: platformController.CheckPlatform() ?
                                                          TextInputType.number : TextInputType.text,
                                                      controller: Edit_Balance,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Edit Ammount'),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Edit_Balance.clear();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (Edit_Balance
                                                                  .text !=
                                                              '') {
                                                            showDialog(
                                                                // The user CANNOT close this dialog  by pressing outsite it
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder: (_) {
                                                                  return Dialog(
                                                                    // The background color
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              20),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          // The loading indicator
                                                                          CircularProgressIndicator(),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          // Some text
                                                                          Text(
                                                                              'Loading')
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                            rechargeBalanceController.EditRechargeBalance(
                                                                    balance.Credit_id
                                                                        .toString(),
                                                                    Edit_Balance
                                                                        .text)
                                                                .then((value) =>
                                                                    showToast(rechargeBalanceController
                                                                        .result2))
                                                                .then((value) =>
                                                                    rechargeBalanceController.isDataFetched =
                                                                        false)
                                                                .then((value) =>
                                                                    rechargeBalanceController
                                                                        .fetch_cart_types())
                                                                .then((value) =>
                                                                    Navigator.of(context)
                                                                        .pop())
                                                                .then((value) =>
                                                                    Navigator.of(context).pop());

                                                            Edit_Balance
                                                                .clear();
                                                          } else {
                                                            Get.snackbar(
                                                                'Error',
                                                                'Add Ammount');
                                                          }

                                                          // Do something with the text, e.g., save it
                                                          //  String enteredText = _textEditingController.text;
                                                          //  print('Entered text: $enteredText');
                                                          // Close the dialog
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.red,
                                            )),
                                        Text(
                                          balance.Credit_Type
                                          // +
                                          // ' -- ' +
                                          // balance.cart_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      addCommasToNumber(balance.Credit_Balance)
                                          .toString()
                                      // +
                                      // ' -- ' +
                                      // balance.cart_Code,
                                      ,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.green.shade900),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            //fixedSize: Size(200, 20),
                                            backgroundColor:
                                                Colors.red.shade900,
                                            side: BorderSide(
                                              width: 2.0,
                                              color: Colors.red.shade900,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.to(() => Topup_History(
                                                  B_id: balance.Credit_id,
                                                  B_Name: balance.Credit_Type,
                                                ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'History',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.history,
                                                  color: Colors.white
                                                  //  'Details',
                                                  //   style: TextStyle(
                                                  //        color: Colors.red),
                                                  ),
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            //fixedSize: Size(200, 20),
                                            backgroundColor:
                                                Colors.green.shade900,
                                            side: BorderSide(
                                              width: 2.0,
                                              color: Colors.green.shade900,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Update ' +
                                                      balance.Credit_Type +
                                                      ' Balance'),
                                                  content: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: New_Balance,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            'Enter added ammount'),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        New_Balance.clear();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (New_Balance.text !=
                                                            '') {
                                                          showDialog(
                                                              // The user CANNOT close this dialog  by pressing outsite it
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder: (_) {
                                                                return Dialog(
                                                                  // The background color
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        // The loading indicator
                                                                        CircularProgressIndicator(),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        // Some text
                                                                        Text(
                                                                            'Loading')
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                          rechargeBalanceController.UpdateRechargeBalance(
                                                                  balance.Credit_id
                                                                      .toString(),
                                                                  New_Balance
                                                                      .text)
                                                              .then((value) =>
                                                                  showToast(
                                                                      rechargeBalanceController
                                                                          .result2))
                                                              .then((value) =>
                                                                  rechargeBalanceController.isDataFetched =
                                                                      false)
                                                              .then((value) =>
                                                                  rechargeBalanceController
                                                                      .fetch_cart_types())
                                                              .then((value) =>
                                                                  Navigator.of(context)
                                                                      .pop())
                                                              .then((value) =>
                                                                  Navigator.of(context).pop());

                                                          New_Balance.clear();
                                                        } else {
                                                          Get.snackbar('Error',
                                                              'Add Ammount');
                                                        }

                                                        // Do something with the text, e.g., save it
                                                        //  String enteredText = _textEditingController.text;
                                                        //  print('Entered text: $enteredText');
                                                        // Close the dialog
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            // Get.to(() => RechargeCarts(
                                            //       Type_id: balance.Type_id,
                                            //       Type_Name: balance.Type_Name,
                                            //     ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Top Up',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                  Icons
                                                      .arrow_circle_right_rounded,
                                                  color: Colors.white
                                                  //  'Details',
                                                  //   style: TextStyle(
                                                  //        color: Colors.red),
                                                  ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // trailing: Column(
                            //   children: [
                            //     OutlinedButton(
                            //       onPressed: () {},
                            //       child: Row(
                            //         children: [
                            //           Text('Select'),
                            //           Icon(Icons.arrow_forward_ios)
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // subtitle: Row(
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           SizedBox(
                            //             height: 10,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     // Column(
                            //     //   children: [
                            //     //     Visibility(
                            //     //       visible: !rechargeBalanceController
                            //     //           .isadmin(Username.value),
                            //     //       child: OutlinedButton(
                            //     //           onPressed: () {
                            //     //             // rechargeBalanceController.SelectedPhone.value = balance;
                            //     //             //       // subcategoryController.selectedSubCategory.value =
                            //     //             //       //     null;
                            //     //             showDialog(
                            //     //                 barrierDismissible: false,
                            //     //                 context: context,
                            //     //                 builder: (BuildContext context) {
                            //     //                   return AlertDialog(
                            //     //                     title: SizedBox(
                            //     //                       child: BarcodeWidget(
                            //     //                         barcode:
                            //     //                             Barcode.code128(),
                            //     //                         data:
                            //     //                             balance.t,
                            //     //                       ),
                            //     //                     ),
                            //     //                     // content: setupAlertDialoadContainer(),

                            //     //                     actions: [
                            //     //                       Center(
                            //     //                         child: Row(
                            //     //                           mainAxisAlignment:
                            //     //                               MainAxisAlignment
                            //     //                                   .spaceBetween,
                            //     //                           children: [
                            //     //                             Expanded(
                            //     //                               child:
                            //     //                                   OutlinedButton(
                            //     //                                       style: ElevatedButton
                            //     //                                           .styleFrom(
                            //     //                                         fixedSize: Size(
                            //     //                                             double
                            //     //                                                 .infinity,
                            //     //                                             20),
                            //     //                                         backgroundColor:
                            //     //                                             Colors
                            //     //                                                 .red,
                            //     //                                         side: BorderSide(
                            //     //                                             width:
                            //     //                                                 2.0,
                            //     //                                             color:
                            //     //                                                 Colors.red),
                            //     //                                         shape:
                            //     //                                             RoundedRectangleBorder(
                            //     //                                           borderRadius:
                            //     //                                               BorderRadius.circular(32.0),
                            //     //                                         ),
                            //     //                                       ),
                            //     //                                       onPressed:
                            //     //                                           () {
                            //     //                                         Navigator.of(
                            //     //                                                 context)
                            //     //                                             .pop();
                            //     //                                       },
                            //     //                                       child: Text(
                            //     //                                         'Close',
                            //     //                                         style: TextStyle(
                            //     //                                             color:
                            //     //                                                 Colors.white),
                            //     //                                       )),
                            //     //                             ),
                            //     //                           ],
                            //     //                         ),
                            //     //                       )
                            //     //                     ],
                            //     //                   );
                            //     //                 });
                            //     //           },
                            //     //           child: Icon(
                            //     //             Icons.qr_code,
                            //     //             size: 20,
                            //     //           )),
                            //     //     ),
                            //     //     Visibility(
                            //     //       visible: !rechargeBalanceController
                            //     //           .isadmin(Username.value),
                            //     //       child: OutlinedButton(
                            //     //           onPressed: () {
                            //     //             // rechargeBalanceController.SelectedPhone.value = balance;
                            //     //             //       // subcategoryController.selectedSubCategory.value =
                            //     //             //       //     null;
                            //     //             invoiceController.fetchcart(
                            //     //                 balance.cart_Code);
                            //     //           },
                            //     //           child: Icon(
                            //     //             Icons.add,
                            //     //             size: 20,
                            //     //           )),
                            //     //     ),
                            //     //     OutlinedButton(
                            //     //         onPressed: () {
                            //     //           // rechargeBalanceController.SelectedPhone.value = balance;
                            //     //           //       // subcategoryController.selectedSubCategory.value =
                            //     //           //       //     null;

                            //     //           Get.to(() => RechargeDetail(
                            //     //                 cart_id:
                            //     //                     balance.cart_id.toString(),
                            //     //                 Type_Name:
                            //     //                     balance.Type_Name,
                            //     //                 cart_Color:
                            //     //                     balance.cart_Color,
                            //     //                 cart_LPrice: balance
                            //     //                     .cart_LPrice.toString(),
                            //     //                 cart_MPrice: balance
                            //     //                     .cart_MPrice
                            //     //                     .toString(),
                            //     //                 cart_Code:
                            //     //                     balance.cart_Code,
                            //     //               ));
                            //     //         },
                            //     //         child: Icon(
                            //     //           Icons.arrow_right,
                            //     //           size: 20,
                            //     //         )),
                            //     //     Visibility(
                            //     //       visible: rechargeBalanceController
                            //     //           .isadmin(Username.value),
                            //     //       child: OutlinedButton(
                            //     //           onPressed: () {
                            //     //             // rechargeBalanceController.SelectedPhone.value = balance;
                            //     //             //       // subcategoryController.selectedSubCategory.value =
                            //     //             //       //     null;

                            //     //             Get.to(() => cartEdit(
                            //     //                   cart_id: balance.cart_id,
                            //     //                   Type_Name:
                            //     //                       balance.Type_Name,
                            //     //                   P_Color:
                            //     //                       (balance.cart_Color),
                            //     //                   P_Code: balance.cart_Code,
                            //     //                   MPrice: balance.cart_MPrice
                            //     //                       .toString(),
                            //     //                   LPrice: balance.cart_LPrice
                            //     //                       .toString(),
                            //     //                   Cost_Price: balance.cart_Cost
                            //     //                       .toString(),
                            //     //                   SubCategory:
                            //     //                       balance.cart_Sub_Cat_id,
                            //     //                   Category:
                            //     //                       balance.cart_Cat_id,
                            //     //                   Brand: balance.cart_Brand,
                            //     //                 ));
                            //     //           },
                            //     //           child: Icon(
                            //     //             Icons.edit,
                            //     //             size: 20,
                            //     //           )),
                            //     //     ),
                            //     //   ],
                            //     // ),
                            //   ],
                            // ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
