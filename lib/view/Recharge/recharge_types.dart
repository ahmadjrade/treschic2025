// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/cart_types_model.dart';
import 'package:fixnshop_admin/view/Recharge/add_recharge_type.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_carts.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class RechargeTypes extends StatelessWidget {
  RechargeTypes({super.key});
  final CartTypesController cartTypesController =
      Get.find<CartTypesController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  TextEditingController Type_Name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    // cartTypesController.fetchcarts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Card Types'),
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
                  Get.to(AddRechargeType());
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.add),
              ),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  cartTypesController.isDataFetched = false;
                  cartTypesController.fetch_cart_types();
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
          //               cartTypesController.carts.refresh();
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
                final List<CartTypeModel> filteredcarts =
                    cartTypesController.searchTypes(Type_Name.text);
                if (cartTypesController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (cartTypesController.carts.isEmpty) {
                  return Center(child: Text('No Carts Yet ! Add Some '));
                } else {
                  return ListView.builder(
                    itemCount: filteredcarts.length,
                    itemBuilder: (context, index) {
                      final CartTypeModel cart = filteredcarts[index];
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
                              Get.to(() => RechargeCarts(
                                            Type_id: cart.Type_id,
                                            Type_Name: cart.Type_Name,
                                          ));
                            },
                            leading:
                                cart.Type_Image == null || cart.Type_Image == ''
                                    ? SizedBox(
                                        width: 75,
                                        child: Column(
                                          children: [
                                            Text('No Image'),
                                            Icon(
                                              Icons.error,
                                            ),
                                          ],
                                        ))
                                    : CachedNetworkImage(
                                        width: 75,
                                        imageUrl: cart.Type_Image!,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                            // onLongPress: () {
                            //   copyToClipboard(cart.cart_Code);
                            // },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cart.Type_Name
                                  // +
                                  // ' -- ' +
                                  // cart.cart_Code,
                                  ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                      //fixedSize: Size(200, 20),
                                      backgroundColor:
                                          Colors.deepPurpleAccent.shade200,
                                      side: BorderSide(
                                        width: 2.0,
                                        color: Colors.deepPurpleAccent.shade200,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => RechargeCarts(
                                            Type_id: cart.Type_id,
                                            Type_Name: cart.Type_Name,
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //   'Select',
                                        //   style: TextStyle(color: Colors.white),
                                        // ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        Icon(Icons.arrow_circle_right_rounded,
                                            color: Colors.white
                                            //  'Details',
                                            //   style: TextStyle(
                                            //        color: Colors.red),
                                            ),
                                      ],
                                    )),
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
                            //     //       visible: !cartTypesController
                            //     //           .isadmin(Username.value),
                            //     //       child: OutlinedButton(
                            //     //           onPressed: () {
                            //     //             // cartTypesController.SelectedPhone.value = cart;
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
                            //     //                             cart.t,
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
                            //     //       visible: !cartTypesController
                            //     //           .isadmin(Username.value),
                            //     //       child: OutlinedButton(
                            //     //           onPressed: () {
                            //     //             // cartTypesController.SelectedPhone.value = cart;
                            //     //             //       // subcategoryController.selectedSubCategory.value =
                            //     //             //       //     null;
                            //     //             invoiceController.fetchcart(
                            //     //                 cart.cart_Code);
                            //     //           },
                            //     //           child: Icon(
                            //     //             Icons.add,
                            //     //             size: 20,
                            //     //           )),
                            //     //     ),
                            //     //     OutlinedButton(
                            //     //         onPressed: () {
                            //     //           // cartTypesController.SelectedPhone.value = cart;
                            //     //           //       // subcategoryController.selectedSubCategory.value =
                            //     //           //       //     null;

                            //     //           Get.to(() => RechargeDetail(
                            //     //                 cart_id:
                            //     //                     cart.cart_id.toString(),
                            //     //                 Type_Name:
                            //     //                     cart.Type_Name,
                            //     //                 cart_Color:
                            //     //                     cart.cart_Color,
                            //     //                 cart_LPrice: cart
                            //     //                     .cart_LPrice.toString(),
                            //     //                 cart_MPrice: cart
                            //     //                     .cart_MPrice
                            //     //                     .toString(),
                            //     //                 cart_Code:
                            //     //                     cart.cart_Code,
                            //     //               ));
                            //     //         },
                            //     //         child: Icon(
                            //     //           Icons.arrow_right,
                            //     //           size: 20,
                            //     //         )),
                            //     //     Visibility(
                            //     //       visible: cartTypesController
                            //     //           .isadmin(Username.value),
                            //     //       child: OutlinedButton(
                            //     //           onPressed: () {
                            //     //             // cartTypesController.SelectedPhone.value = cart;
                            //     //             //       // subcategoryController.selectedSubCategory.value =
                            //     //             //       //     null;

                            //     //             Get.to(() => cartEdit(
                            //     //                   cart_id: cart.cart_id,
                            //     //                   Type_Name:
                            //     //                       cart.Type_Name,
                            //     //                   P_Color:
                            //     //                       (cart.cart_Color),
                            //     //                   P_Code: cart.cart_Code,
                            //     //                   MPrice: cart.cart_MPrice
                            //     //                       .toString(),
                            //     //                   LPrice: cart.cart_LPrice
                            //     //                       .toString(),
                            //     //                   Cost_Price: cart.cart_Cost
                            //     //                       .toString(),
                            //     //                   SubCategory:
                            //     //                       cart.cart_Sub_Cat_id,
                            //     //                   Category:
                            //     //                       cart.cart_Cat_id,
                            //     //                   Brand: cart.cart_Brand,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.maxFinite, 50),
                        backgroundColor: Colors.green.shade900,
                        side: BorderSide(
                            width: 2.0, color: Colors.deepPurple.shade900),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                onPressed: ()  {
                                  Navigator.of(context).pop();
            
              }, child: Text('Done',style: TextStyle(color: Colors.white),)),
          ),
            SizedBox(height: 30,),
        ],
      ),
    );
  }
}
