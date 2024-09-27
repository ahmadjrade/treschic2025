// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/bulk_phone_purchase_controller.dart';
import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/purchase_controller.dart';
import 'package:fixnshop_admin/controller/purchase_history_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Phones/phone_model_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BulkPhonePurchase extends StatelessWidget {
  String Supp_id, Supp_Name, Supp_Number;
  BulkPhonePurchase(
      {super.key,
      required this.Supp_id,
      required this.Supp_Name,
      required this.Supp_Number});
  final BarcodeController barImeiController = Get.find<BarcodeController>();
  TextEditingController New_Price = TextEditingController();
  TextEditingController New_Qty = TextEditingController();
  TextEditingController New_IMEI = TextEditingController();
  List<String> capacity = [
    '32G',
    '64G',
    '128G',
    '256G',
    '512G',
    '1TB',
    '2TB',
  ];
  int SelectedCapacityIndex = 0;
  String SelectedCapacity = '';
  ColorModel? SelectedColor;
  int SelectedColorId = 0;
  String SelectedColorName = '';

  final PhoneModelController phoneModelController =
      Get.find<PhoneModelController>();
  final PurchaseHistoryController purchaseHistoryController =
      Get.find<PurchaseHistoryController>();
  TextEditingController Product_Imei = TextEditingController();
  final BulkPhonePurchaseController bulkPhonePurchaseController =
      Get.put(BulkPhonePurchaseController());
  final RateController rateController = Get.find<RateController>();
  final ColorController colorController = Get.find<ColorController>();

  double TP = 0;
  double CalPrice(qty, up) {
    return TP = qty * up;
  }

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  String CalculatedDueUsd = '';
  String CalDue(due, rate) {
    CalculatedDueUsd = '';
    CalculatedDueUsd = (due / rate).toString();
    return CalculatedDueUsd;
  }

  TextEditingController i = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // bulkPhonePurchaseController.reset();
    Future<void> refreshProducts() async {
      bulkPhonePurchaseController.phonepurchase_items.clear();

      phoneModelController.phone_model.clear();
      phoneModelController.isDataFetched = false;
      phoneModelController.fetchphonemodel();
    }

    Future<void> refreshRate() async {
      rateController.isDataFetched = false;
      rateController.fetchrate();
    }

    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText.toString()));
      // Show a snackbar or any other feedback that the text has been copied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Remaining LB copied to clipboard'),
        ),
      );
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bulk Phone Purchase',
            style: TextStyle(fontSize: 17),
          ),
          // IconButton(
          //   color: Colors.deepPurple,
          //   iconSize: 24.0,
          //   onPressed: () {
          //     Get.toNamed('/NewCat');
          //   },
          //   icon: Icon(CupertinoIcons.add),
          // ),

          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              Get.toNamed('/BuyAccessories');
              // productController.isDataFetched = false;
              // productController.fetchproducts();
              // categoryController.isDataFetched =false;
              // categoryController.fetchcategories();
            },
            icon: Icon(CupertinoIcons.add),
          ),
          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              refreshProducts();
              refreshRate();

              // Get.toNamed('/BuyAccessories');
              // productController.isDataFetched = false;
              // productController.fetchproducts();
              // categoryController.isDataFetched =false;
              // categoryController.fetchcategories();
            },
            icon: Icon(CupertinoIcons.refresh),
          ),
          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              bulkPhonePurchaseController.reset();
              // Get.toNamed('/BuyAccessories');
              // productController.isDataFetched = false;
              // productController.fetchproducts();
              // categoryController.isDataFetched =false;
              // categoryController.fetchcategories();
            },
            icon: Icon(CupertinoIcons.radiowaves_left),
          ),
        ],
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),

                    OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 50),
                          backgroundColor: Colors.blue.shade100,
                          side: BorderSide(
                              width: 2.0, color: Colors.blue.shade100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => PhoneModelList());
                        },
                        child: Text(
                          'Search Phone Models',
                          style: TextStyle(color: Colors.blue.shade900),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Column(children: [
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Purchase Phones',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: bulkPhonePurchaseController
                                .phonepurchase_items.length,
                            itemBuilder: (context, index) {
                              var phone = bulkPhonePurchaseController
                                  .phonepurchase_items[index];
                              return Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              bulkPhonePurchaseController
                                                  .phonepurchase_items
                                                  .removeAt(index);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                        Expanded(
                                          child: Text(
                                            phone.Phone_Name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Obx(() {
                                          return TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Update Phone Price'),
                                                      content: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller: New_Price,
                                                        decoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    'Enter Price'),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            if (New_Price
                                                                    .text !=
                                                                '') {
                                                              bulkPhonePurchaseController.UpdatePhonePrice(
                                                                  index,
                                                                  double.tryParse(
                                                                      New_Price
                                                                          .text)!.toString());
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              New_Price.clear();
                                                            } else {
                                                              Get.snackbar(
                                                                  'Error',
                                                                  'Add New Cost');
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
                                                // bulkPhonePurchaseController.UpdatePhonePrice(phone, 10);
                                              },
                                              child: Text(
                                                phone.Purchase_Price
                                                        .toString() +
                                                    '\$',
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade900),
                                              ));
                                        }),
                                        SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Obx(() {
                                          return Row(
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Update Phone IMEI'),
                                                          content: TextFormField(
                                                            maxLength: 15,
                                                            
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                New_IMEI,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Enter IMEI'),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                if (New_IMEI
                                                                        .text !=
                                                                    '') {
                                                                  if (New_IMEI
                                                                          .text
                                                                          .length ==
                                                                      15) {
                                                                    bulkPhonePurchaseController.UpdatePhoneImei(
                                                                        index,
                                                                        New_IMEI
                                                                            .text);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    New_IMEI
                                                                        .clear();
                                                                  } else {
                                                                    Get.snackbar(
                                                                        'Error',
                                                                        'IMEI MUST HAVE 15 NUMBERS');
                                                                  }
                                                                } else {
                                                                  Get.snackbar(
                                                                      'Error',
                                                                      'Add New IMEI');
                                                                }

                                                                // Do something with the text, e.g., save it
                                                                //  String enteredText = _textEditingController.text;
                                                                //  print('Entered text: $enteredText');
                                                                // Close the dialog
                                                              },
                                                              child: Text(
                                                                'OK',
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    // bulkPhonePurchaseController.UpdatePhonePrice(phone, 10);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'IMEI: ' +
                                                            phone.IMEI
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          );
                                        })
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Obx(() {
                                          return Row(
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Update Phone Color'),
                                                          content: Obx(
                                                            () => colorController
                                                                    .colors
                                                                    .isEmpty
                                                                ? Center(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        // Text('Fetching Rate! Please Wait'),
                                                                        CircularProgressIndicator(),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: DropdownButtonFormField<
                                                                          ColorModel>(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                "Color",
                                                                            labelStyle:
                                                                                TextStyle(
                                                                              color: Colors
                                                                                  .black,
                                                                            ),
                                                                            fillColor:
                                                                                Colors
                                                                                    .black,
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(15.0),
                                                                              borderSide:
                                                                                  BorderSide(
                                                                                color:
                                                                                    Colors.black,
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(15.0),
                                                                              borderSide:
                                                                                  BorderSide(
                                                                                color:
                                                                                    Colors.black,
                                                                                width:
                                                                                    2.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          iconDisabledColor:
                                                                              Colors
                                                                                  .blue
                                                                                  .shade100,
                                                                          iconEnabledColor:
                                                                              Colors
                                                                                  .blue
                                                                                  .shade100,
                                                                          //   value: colorController.colors.first,
                                                                          onChanged:
                                                                              (ColorModel?
                                                                                  value) {
                                                                            SelectedColor =
                                                                                value;
                                                                            SelectedColorId =
                                                                                (SelectedColor
                                                                                    ?.Color_id)!;
                                                                                     SelectedColorName =
                                                                                (SelectedColor
                                                                                    ?.Color)!;
                                                                            bulkPhonePurchaseController.UpdatePhoneColor(
                                                                                index,
                                                                                SelectedColorId,SelectedColorName
                                                                                    );
                                                                            Navigator.of(
                                                                                    context)
                                                                                .pop();
                                                                      
                                                                            print(
                                                                                SelectedColorId);
                                                                          },
                                                                          items: colorController
                                                                              .colors
                                                                              .map((color) =>
                                                                                  DropdownMenuItem<ColorModel>(
                                                                                    value: color,
                                                                                    child: Text(color.Color),
                                                                                  ))
                                                                              .toList(),
                                                                        ),
                                                                    ),
                                                                       IconButton(
                  color: Colors.black,
                  iconSize: 24.0,
                  icon: Icon(CupertinoIcons.add),
                  onPressed: () {
                    //customerController.searchCustomer(numberController);
                    Get.toNamed('/NewColor');
                  },
                ),
                                                                  ],
                                                                ),
                                                                  
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    // bulkPhonePurchaseController.UpdatePhonePrice(phone, 10);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.colorize),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        phone.ColorName
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Update Phone IMEI'),
                                                          content:
                                                              DropdownButtonFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Capacity ",
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              fillColor:
                                                                  Colors.black,
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                            ),
                                                            iconDisabledColor:
                                                                Colors.blue
                                                                    .shade100,
                                                            iconEnabledColor:
                                                                Colors.blue
                                                                    .shade100,
                                                            value:
                                                                SelectedCapacityIndex,
                                                            onChanged:
                                                                (newIndex) {
                                                              bulkPhonePurchaseController
                                                                  .UpdatePhoneCapacity(
                                                                      index,
                                                                      capacity[
                                                                          newIndex]);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();

                                                              //  selectedMonthIndex = newIndex!;
                                                              //  SelectMonth = newIndex + 1;
                                                            },
                                                            items: capacity
                                                                .asMap()
                                                                .entries
                                                                .map<
                                                                    DropdownMenuItem>(
                                                              (entry) {
                                                                int index =
                                                                    entry.key;
                                                                String
                                                                    monthName =
                                                                    entry.value;
                                                                return DropdownMenuItem(
                                                                  value: index,
                                                                  child: Text(
                                                                    monthName,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).toList(),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    // bulkPhonePurchaseController.UpdatePhonePrice(phone, 10);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.sd_storage),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        phone.Capacity
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          );
                                        })
                                      ],
                                    ),
                                    // Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Expanded(
                                    //         child: Padding(
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: 25),
                                    //           child: DropdownButtonFormField(
                                    //             decoration: InputDecoration(
                                    //               labelText: "Capacity ",
                                    //               labelStyle: TextStyle(
                                    //                 color: Colors.black,
                                    //               ),
                                    //               fillColor: Colors.black,
                                    //               focusedBorder:
                                    //                   OutlineInputBorder(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         15.0),
                                    //                 borderSide: BorderSide(
                                    //                   color: Colors.black,
                                    //                 ),
                                    //               ),
                                    //               enabledBorder:
                                    //                   OutlineInputBorder(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         15.0),
                                    //                 borderSide: BorderSide(
                                    //                   color: Colors.black,
                                    //                   width: 2.0,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             iconDisabledColor:
                                    //                 Colors.blue.shade100,
                                    //             iconEnabledColor:
                                    //                 Colors.blue.shade100,
                                    //             value: SelectedCapacityIndex,
                                    //             onChanged: (newIndex) {
                                    //               SelectedCapacity =
                                    //                   capacity[newIndex];
                                    //               SelectedCapacityIndex =
                                    //                   newIndex;
                                    //               print(SelectedCapacity);
                                    //               //  selectedMonthIndex = newIndex!;
                                    //               //  SelectMonth = newIndex + 1;
                                    //             },
                                    //             items: capacity
                                    //                 .asMap()
                                    //                 .entries
                                    //                 .map<DropdownMenuItem>(
                                    //               (entry) {
                                    //                 int index = entry.key;
                                    //                 String monthName =
                                    //                     entry.value;
                                    //                 return DropdownMenuItem(
                                    //                   value: index,
                                    //                   child: Text(
                                    //                     monthName,
                                    //                     style: TextStyle(
                                    //                       fontSize: 16,
                                    //                     ),
                                    //                   ),
                                    //                 );
                                    //               },
                                    //             ).toList(),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       Expanded(
                                    //         child: Padding(
                                    //           padding:
                                    //               const EdgeInsets.fromLTRB(
                                    //                   0, 0, 10, 0),
                                    //           child: Obx(
                                    //             () => colorController
                                    //                     .colors.isEmpty
                                    //                 ? Center(
                                    //                     child: Column(
                                    //                       children: [
                                    //                         // Text('Fetching Rate! Please Wait'),
                                    //                         CircularProgressIndicator(),
                                    //                       ],
                                    //                     ),
                                    //                   )
                                    //                 : DropdownButtonFormField<
                                    //                     ColorModel>(
                                    //                     decoration:
                                    //                         InputDecoration(
                                    //                       labelText: "Color",
                                    //                       labelStyle: TextStyle(
                                    //                         color: Colors.black,
                                    //                       ),
                                    //                       fillColor:
                                    //                           Colors.black,
                                    //                       focusedBorder:
                                    //                           OutlineInputBorder(
                                    //                         borderRadius:
                                    //                             BorderRadius
                                    //                                 .circular(
                                    //                                     15.0),
                                    //                         borderSide:
                                    //                             BorderSide(
                                    //                           color:
                                    //                               Colors.black,
                                    //                         ),
                                    //                       ),
                                    //                       enabledBorder:
                                    //                           OutlineInputBorder(
                                    //                         borderRadius:
                                    //                             BorderRadius
                                    //                                 .circular(
                                    //                                     15.0),
                                    //                         borderSide:
                                    //                             BorderSide(
                                    //                           color:
                                    //                               Colors.black,
                                    //                           width: 2.0,
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                     iconDisabledColor:
                                    //                         Colors
                                    //                             .blue.shade100,
                                    //                     iconEnabledColor: Colors
                                    //                         .blue.shade100,
                                    //                     //   value: colorController.colors.first,
                                    //                     onChanged: (ColorModel?
                                    //                         value) {
                                    //                       SelectedColor = value;
                                    //                       SelectedColorId =
                                    //                           (SelectedColor
                                    //                               ?.Color_id)!;
                                    //                       print(
                                    //                           SelectedColorId);
                                    //                     },
                                    //                     items: colorController
                                    //                         .colors
                                    //                         .map((color) =>
                                    //                             DropdownMenuItem<
                                    //                                 ColorModel>(
                                    //                               value: color,
                                    //                               child: Text(
                                    //                                   color
                                    //                                       .Color),
                                    //                             ))
                                    //                         .toList(),
                                    //                   ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       Padding(
                                    //         padding: const EdgeInsets.fromLTRB(
                                    //             00, 0, 0, 0),
                                    //         child: Row(
                                    //           children: [
                                    //             IconButton(
                                    //               color: Colors.black,
                                    //               iconSize: 24.0,
                                    //               icon:
                                    //                   Icon(CupertinoIcons.add),
                                    //               onPressed: () {
                                    //                 //customerController.searchCustomer(numberController);
                                    //                 Get.toNamed('/NewColor');
                                    //               },
                                    //             ),
                                    //             SizedBox(
                                    //               width: 20,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       )
                                    //     ]),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //                                                   //  Text('Imei: ${phone.IMEI}'),

                                    //     Obx(() {
                                    //       return Row(
                                    //         children: [
                                    //           IconButton(
                                    //               color: Colors.red,
                                    //               onPressed: () {
                                    //                 showDialog(
                                    //                   context: context,
                                    //                   builder: (BuildContext
                                    //                       context) {
                                    //                     return AlertDialog(
                                    //                       title: Text(
                                    //                           'Update Item Cost'),
                                    //                       content: TextField(
                                    //                         keyboardType:
                                    //                             TextInputType
                                    //                                 .number,
                                    //                         controller:
                                    //                             New_Price,
                                    //                         decoration:
                                    //                             InputDecoration(
                                    //                                 hintText:
                                    //                                     'Enter New Cost'),
                                    //                       ),
                                    //                       actions: <Widget>[
                                    //                         TextButton(
                                    //                           onPressed: () {
                                    //                             Navigator.of(
                                    //                                     context)
                                    //                                 .pop();
                                    //                           },
                                    //                           child: Text(
                                    //                               'Cancel'),
                                    //                         ),
                                    //                         TextButton(
                                    //                           onPressed: () {
                                    //                             if (New_Price
                                    //                                     .text !=
                                    //                                 '') {
                                    //                               bulkPhonePurchaseController.updateItemPrice(
                                    //                                   bulkPhonePurchaseController
                                    //                                           .phonepurchase_items[
                                    //                                       index],
                                    //                                   double.tryParse(
                                    //                                       New_Price
                                    //                                           .text)!);
                                    //                               Navigator.of(
                                    //                                       context)
                                    //                                   .pop();
                                    //                               New_Price
                                    //                                   .clear();
                                    //                             } else {
                                    //                               Get.snackbar(
                                    //                                   'Error',
                                    //                                   'Add New Cost');
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
                                    //               icon:
                                    //                   Icon(Icons.price_change)),
                                    //           Column(
                                    //             children: [
                                    //               Row(
                                    //                 children: [
                                    //                   Text(
                                    //                     ' UC: ',
                                    //                     style: TextStyle(
                                    //                         fontSize: 15,
                                    //                         color:
                                    //                             Colors.black),
                                    //                   ),
                                    //                   Text(
                                    //                     '${phone.Purchase_Price}\$ ',
                                    //                     style: TextStyle(
                                    //                         fontSize: 15,
                                    //                         color: Colors.green
                                    //                             .shade900),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               // Row(
                                    //               //   children: [
                                    //               //     Text(
                                    //               //       'TC: ',
                                    //               //       style: TextStyle(
                                    //               //           fontSize: 15,
                                    //               //           color:
                                    //               //               Colors.black),
                                    //               //     ),
                                    //               //     Text(
                                    //               //       CalPrice(
                                    //               //                   phone
                                    //               //                       .quantity
                                    //               //                       .value,
                                    //               //                   phone
                                    //               //                       .product_Cost)
                                    //               //               .toString() +
                                    //               //           '\$',
                                    //               //       style: TextStyle(
                                    //               //           fontSize: 15,
                                    //               //           color: Colors.green
                                    //               //               .shade900),
                                    //               //     )
                                    //               //   ],
                                    //               // ),
                                    //             ],
                                    //           ),
                                    //         ],
                                    //       );
                                    //     }),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 0,
                                    ),

                                    //                            Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    //         child: Obx(
                                    //           () => colorController.colors.isEmpty
                                    //               ? Center(
                                    //                   child: Column(
                                    //                     children: [
                                    //                       // Text('Fetching Rate! Please Wait'),
                                    //                       CircularProgressIndicator(),
                                    //                     ],
                                    //                   ),
                                    //                 )
                                    //               : DropdownButtonFormField<ColorModel>(
                                    //                   decoration: InputDecoration(
                                    //                     labelText: "Colors",
                                    //                     labelStyle: TextStyle(
                                    //                       color: Colors.black,
                                    //                     ),
                                    //                     fillColor: Colors.black,
                                    //                     focusedBorder: OutlineInputBorder(
                                    //                       borderRadius: BorderRadius.circular(15.0),
                                    //                       borderSide: BorderSide(
                                    //                         color: Colors.black,
                                    //                       ),
                                    //                     ),
                                    //                     enabledBorder: OutlineInputBorder(
                                    //                       borderRadius: BorderRadius.circular(15.0),
                                    //                       borderSide: BorderSide(
                                    //                         color: Colors.black,
                                    //                         width: 2.0,
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   iconDisabledColor: Colors.deepPurple.shade300,
                                    //                   iconEnabledColor: Colors.deepPurple.shade300,
                                    //                   //  value: categoryController.category.first,
                                    //                   onChanged: (ColorModel? value) {
                                    //                     SelectedColor = value;
                                    //                     SelectedColorId = (SelectedColor?.Color_id)!;
                                    //                     phone.Product_Imei = phone.Product_Imei + '-' + SelectedColorId.toString();
                                    //                   },
                                    //                   items: colorController.colors
                                    //                       .map((color) => DropdownMenuItem<ColorModel>(
                                    //                             value: color,
                                    //                             child: Text(color.Color),
                                    //                           ))
                                    //                       .toList(),
                                    //                 ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Padding(
                                    //       padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    //       child: IconButton(
                                    //         color: Colors.blueAccent,
                                    //         iconSize: 24.0,
                                    //         onPressed: () {
                                    //           Get.toNamed('/NewColor');
                                    //           // colorController.isDataFetched = false;
                                    //           // colorController.fetchcolors();
                                    //           // //Quantities.clear();
                                    //           //Quantities.add(Product_Quantity.text);
                                    //         //  print(Quantities);
                                    //         },
                                    //         icon: Icon(CupertinoIcons.add),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
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
                              labelText: 'Purchase Information',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Supplier Name: '),
                                        Text(
                                          Supp_Name,
                                          style: TextStyle(color: Colors.black),
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
                                        Text('Supplier Number: '),
                                        Text(
                                          Supp_Number,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                                            '${bulkPhonePurchaseController.totalQty.toString()}'),
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
                                        Text('Purchase Total: '),
                                        Text(
                                          addCommasToNumber(
                                                  bulkPhonePurchaseController
                                                      .totalUsd.value) +
                                              ' \$',
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
                                        Text('Purchase Total LL: '),
                                        Text(
                                          addCommasToNumber(
                                                  bulkPhonePurchaseController
                                                      .totalLb.value) +
                                              ' LB',
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
                                        Text('Purchase Due USD: '),
                                        GestureDetector(
                                          onLongPress: () {
                                            copyToClipboard(
                                                bulkPhonePurchaseController
                                                    .DueLB.value);
                                          },
                                          child: Text(
                                            addCommasToNumber(double.tryParse(
                                                    CalDue(
                                                        bulkPhonePurchaseController
                                                            .DueLB.value,
                                                        rateController.rateValue
                                                            .value))!) +
                                                ' \$',
                                            style: TextStyle(
                                                color: Colors.green.shade900),
                                          ),
                                        )
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
                                        Text('Purchase Due LB: '),
                                        GestureDetector(
                                          onLongPress: () {
                                            copyToClipboard(
                                                bulkPhonePurchaseController
                                                    .DueLB.value);
                                          },
                                          child: Text(
                                            addCommasToNumber(
                                                    bulkPhonePurchaseController
                                                        .DueLB.value) +
                                                ' \LB',
                                            style: TextStyle(
                                                color: Colors.green.shade900),
                                          ),
                                        )
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
                                        Text('Received USD: '),
                                        Expanded(
                                            child: TextField(
                                          // controller: i,
                                          keyboardType: TextInputType.number,
                                          onChanged: (Value) {
                                            if (Value == '') {
                                              //  Get.snackbar('123', '123');
                                              bulkPhonePurchaseController
                                                  .resetRecUsd();
                                            } else {
                                              bulkPhonePurchaseController
                                                      .ReceivedUSD.value =
                                                  double.tryParse(Value)!;
                                              bulkPhonePurchaseController
                                                  .calculateDueUSD();
                                              bulkPhonePurchaseController
                                                  .calculateDueLB();
                                            }
                                          },
                                        )),
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
                                        Text('Received LB: '),
                                        Expanded(
                                            child: TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            if (value == '') {
                                              //  Get.snackbar('123', '123');
                                              bulkPhonePurchaseController
                                                  .resetRecLb();
                                            } else {
                                              bulkPhonePurchaseController
                                                      .ReceivedLb.value =
                                                  double.tryParse(value)!;
                                              bulkPhonePurchaseController
                                                  .calculateDueLB();
                                              bulkPhonePurchaseController
                                                  .calculateDueUSD();
                                            }
                                          },
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
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
                          backgroundColor: Colors.blue.shade100,
                          side: BorderSide(
                              width: 2.0, color: Colors.blue.shade100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          if (bulkPhonePurchaseController
                              .phonepurchase_items.isNotEmpty) {
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
                            bulkPhonePurchaseController
                                .uploadPurchaseToDatabase(
                                    Supp_id.toString(), Supp_Name, Supp_Number)
                                .then((value) =>
                                    showToast(bulkPhonePurchaseController.result))
                                .then((value) => refreshProducts())
                                .then((value) => bulkPhonePurchaseController.reset())
                                .then((value) => bulkPhonePurchaseController.reset())
                                .then((value) => purchaseHistoryController.isDataFetched = false)
                                .then((value) => purchaseHistoryController.fetchpurchases())
                                .then((value) => Navigator.of(context).pop())
                                .then((value) => Navigator.of(context).pop());
                          } else {
                            //    showToast('Add Products');
                            Get.snackbar('No Products Added!', 'Add Products ');
                          }
                        },
                        child: Text(
                          'Insert Purchase',
                          style: TextStyle(color: Colors.blue.shade900),
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
