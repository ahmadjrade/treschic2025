// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/view/buy_accessories.dart';
import 'package:fixnshop_admin/view/product_list.dart';
import 'package:fixnshop_admin/view/recharge_carts.dart';
import 'package:fixnshop_admin/view/recharge_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewRechargeInvoice extends StatelessWidget {
  NewRechargeInvoice(
      {super.key,});
  TextEditingController New_Price = TextEditingController();
  TextEditingController New_Qty = TextEditingController();

  
  final RechargeCartController rechargeCartController =
      Get.find<RechargeCartController>();

  // final InvoiceController invoiceController = Get.put(InvoiceController());
  final RateController rateController = Get.find<RateController>();

 

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  
  @override
  Widget build(BuildContext context) {
    //  invoiceController.reset();
   

    Future<void> refreshRate() async {
      rateController.isDataFetched = false;
      rateController.fetchrate();
    }

    

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('New Recharge Invoice'),
              // IconButton(
              //   color: Colors.deepPurple,
              //   iconSize: 24.0,
              //   onPressed: () {
              //     Get.toNamed('/NewCat');
              //   },
              //   icon: Icon(CupertinoIcons.add),
              // ),

              // IconButton(
              //   color: Colors.deepPurple,
              //   iconSize: 24.0,
              //   onPressed: () {
              //     Get.toNamed('/BuyAccessories');
              //     // productController.isDataFetched = false;
              //     // productController.fetchproducts();
              //     // categoryController.isDataFetched =false;
              //     // categoryController.fetchcategories();
              //   },
              //   icon: Icon(CupertinoIcons.add),
              // ),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                //  refreshProducts();
                  refreshRate();

                  // Get.toNamed('/BuyAccessories');
                  // productController.isDataFetched = false;
                  // productController.fetchproducts();
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.refresh),
              ),
              // IconButton(
              //   color: Colors.deepPurple,
              //   iconSize: 24.0,
              //   onPressed: () {
              //     invoiceController.reset();
              //     // Get.toNamed('/BuyAccessories');
              //     // productController.isDataFetched = false;
              //     // productController.fetchproducts();
              //     // categoryController.isDataFetched =false;
              //     // categoryController.fetchcategories();
              //   },
              //   icon: Icon(CupertinoIcons.radiowaves_left),
              // ),
            ],
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
              SizedBox(height: 20,),
                Column(
                  
                  children: [
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 50),
                          backgroundColor: Colors.deepPurple.shade300,
                          side: BorderSide(
                              width: 2.0, color: Colors.deepPurple.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      onPressed: () {
                           Get.to(() => RechargeTypes());
                    }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Get Cards',style: TextStyle(color: Colors.white),),
                        SizedBox(width: 15,),
                        Icon(Icons.arrow_circle_right,color: Colors.white)
                      ],
                    )),
                    SizedBox(
                      height: 15,
                    ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: TextFormField(
                    //       controller: Product_Code,
                    //       onChanged: (value) {},
                    //       decoration: InputDecoration(
                    //         labelText: "Product Code ",
                    //         labelStyle: TextStyle(
                    //           color: Colors.black,
                    //         ),
                    //         fillColor: Colors.black,
                    //         focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(15.0),
                    //           borderSide: BorderSide(
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(15.0),
                    //           borderSide: BorderSide(
                    //             color: Colors.black,
                    //             width: 2.0,
                    //           ),
                    //         ),
                    //       ),
                    //     )),
                    //     IconButton(
                    //       icon: Icon(Icons.search),
                    //       color: Colors.black,
                    //       onPressed: () {
                    //         Get.to(() => ProductList(
                    //               isPur: 1,
                    //             ));
                    //       },
                    //     ),
                    //     IconButton(
                    //       icon: Icon(Icons.check),
                    //       color: Colors.black,
                    //       onPressed: () {
                    //         invoiceController.fetchProduct(Product_Code.text);
                    //       },
                    //     ),

                    //     // Expanded(
                    //     //   child: Padding(
                    //     //     padding: EdgeInsets.symmetric(horizontal: 25),
                    //     //     child: TextFormField(
                    //     //       controller: Product_Code,
                    //     //       decoration: InputDecoration(
                    //     //         labelText: "Product Code ",
                    //     //         labelStyle: TextStyle(
                    //     //           color: Colors.black,
                    //     //         ),
                    //     //         fillColor: Colors.black,
                    //     //         focusedBorder: OutlineInputBorder(
                    //     //           borderRadius: BorderRadius.circular(15.0),
                    //     //           borderSide: BorderSide(
                    //     //             color: Colors.black,
                    //     //           ),
                    //     //         ),
                    //     //         enabledBorder: OutlineInputBorder(
                    //     //           borderRadius: BorderRadius.circular(15.0),
                    //     //           borderSide: BorderSide(
                    //     //             color: Colors.black,
                    //     //             width: 2.0,
                    //     //           ),
                    //     //         ),
                    //     //       ),
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //     SizedBox(
                    //       width: 5,
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //       child: IconButton(
                    //         icon: Icon(Icons.qr_code_scanner_rounded),
                    //         color: Colors.black,
                    //         onPressed: () {
                    //           barcodeController.scanBarcodeInv();
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Column(children: [
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Recharge Cards',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rechargeCartController.InvoiceCards.length,
                            itemBuilder: (context, index) {
                              var card =
                                  rechargeCartController.InvoiceCards[index];
                              return Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        card != null && card.Cart_Image != null
                                  ? CachedNetworkImage(
                                      width: 50,

                                      imageUrl: card.Cart_Image!,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Placeholder(),
                                  SizedBox(width: 10,),
                                        Expanded(
                                          child: Text(
                                            card.Cart_Name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),

                                        Obx(() { return Row(
                                          children: [

                                            Row(
                                              children: [
                                                IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          rechargeCartController.DecreaseQty(rechargeCartController
                                                                .InvoiceCards[
                                                            index]) ;
                                        
                                      },
                                      ),
                                      SizedBox(width: 25,),
                                      Text(card.quantity.toString()),
                                              ],
                                            ),
                                      SizedBox(width: 25,),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          rechargeCartController.IncreaseQty(rechargeCartController
                                                                .InvoiceCards[
                                                            index]) ;
                                        
                                      },
                                      ),
                                                
                                            
                                          ],
                                        );})
                                    

                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                      ],
                                    ),
                                  
                                
                              ));
                            },
                          ),
                        ),
                      ]);
                    }),

                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Container(
                          width: double.infinity,
                          //     height: double.maxFinite,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Invoice Information',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               
                                Obx(() {
                                  if (rateController.isLoading.value) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return
                                        //Text('${rateController.rateValue.value}');
                                        Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Rate: '),
                                            Text(
                                                '${rateController.rateValue.value}'),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Item Count: '),
                                        Text(
                                            '${rechargeCartController.totalQty.toString()}'),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Invoice Total: '),
                                        Text(
                                          addCommasToNumber(rechargeCartController
                                                  .totalLb.value) +
                                              ' \LL',
                                          style: TextStyle(
                                              color: Colors.green.shade900),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Invoice Total US: '),
                                        Text(
                                          addCommasToNumber(rechargeCartController
                                                  .totalLb.value * rateController.rateValue.value) +
                                              ' \$',
                                          style: TextStyle(
                                              color: Colors.green.shade900),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Card(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text('Invoice Due USD: '),
                                //         GestureDetector(
                                         
                                //           child: Text(
                                //             addCommasToNumber(double.tryParse(
                                //                     CalDue(
                                //                         invoiceController
                                //                             .DueLB.value,
                                //                         rateController.rateValue
                                //                             .value))!) +
                                //                 ' \$',
                                //             style: TextStyle(
                                //                 color: Colors.green.shade900),
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Card(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text('Invoice Due LB: '),
                                //         GestureDetector(
                                //           onLongPress: () {
                                //             copyToClipboard(
                                //                 invoiceController.DueLB.value);
                                //           },
                                //           child: Text(
                                //             addCommasToNumber(invoiceController
                                //                     .DueLB.value) +
                                //                 ' \LB',
                                //             style: TextStyle(
                                //                 color: Colors.green.shade900),
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Card(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text('Received USD: '),
                                //         Expanded(
                                //             child: TextField(
                                //           // controller: i,
                                //           keyboardType: TextInputType.number,
                                //           onChanged: (Value) {
                                //             if (Value == '') {
                                //               //  Get.snackbar('123', '123');
                                //               invoiceController.resetRecUsd();
                                //             } else {
                                //               invoiceController
                                //                       .ReceivedUSD.value =
                                //                   double.tryParse(Value)!;
                                //               invoiceController
                                //                   .calculateDueUSD();
                                //               invoiceController
                                //                   .calculateDueLB();
                                //             }
                                //           },
                                //         )),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // Card(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Text('Received LB: '),
                                //         Expanded(
                                //             child: TextField(
                                //           keyboardType: TextInputType.number,
                                //           onChanged: (value) {
                                //             if (value == '') {
                                //               //  Get.snackbar('123', '123');
                                //               invoiceController.resetRecLb();
                                //             } else {
                                //               invoiceController
                                //                       .ReceivedLb.value =
                                //                   double.tryParse(value)!;
                                //               invoiceController
                                //                   .calculateDueLB();
                                //               invoiceController
                                //                   .calculateDueUSD();
                                //             }
                                //           },
                                //         )),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ));
                    }),

                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 50),
                          backgroundColor: Colors.deepPurple.shade300,
                          side: BorderSide(
                              width: 2.0, color: Colors.deepPurple.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          if (rechargeCartController.InvoiceCards.isNotEmpty) {
                            showDialog(
                                // The user CANNOT close this dialog  by pressing outsite it
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    // The background color
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // The loading indicator
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // Some text
                                          Text('Loading')
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            // invoiceController
                            //     .uploadInvoiceToDatabase(
                            //         Cus_id.toString(), Cus_Name, Cus_Number)
                            //     .then((value) =>
                            //         showToast(invoiceController.result))
                            //     .then((value) => refreshProducts())
                            //     .then((value) => invoiceHistoryController
                            //         .isDataFetched = false)
                            //     .then((value) =>
                            //         invoiceHistoryController.fetchinvoices())
                            //     .then((value) => invoiceController.reset())
                            //     .then((value) => invoiceController.reset())
                            //     .then((value) => Navigator.of(context).pop())
                            //     .then((value) => Navigator.of(context).pop());
                          } else {
                            //    showToast('Add Products');
                            Get.snackbar('No Products Added!', 'Add Products ');
                          }
                        },
                        child: Text(
                          'Insert Invoice',
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    // SizedBox(
                    //   height: 40,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
