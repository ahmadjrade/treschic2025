// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Phones/phones_list.dart';
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewInvoice extends StatelessWidget {
  String Cus_id, Cus_Name, Cus_Number;
  NewInvoice(
      {super.key,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number});
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  TextEditingController New_Price = TextEditingController();
  TextEditingController New_Qty = TextEditingController();

  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  final InvoiceDetailController invoiceDetailController =
      Get.find<InvoiceDetailController>();

  TextEditingController Product_Code = TextEditingController();
  // final InvoiceController invoiceController = Get.put(InvoiceController());
  final RateController rateController = Get.find<RateController>();
  final InvoiceController invoiceController = Get.find<InvoiceController>();
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
    //  invoiceController.reset();
    Future<void> refreshProducts() async {
      invoiceController.invoiceItems.clear();

      productDetailController.product_detail.clear();
      productDetailController.isDataFetched = false;
      productDetailController.fetchproductdetails();
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('New Invoice'),
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
                  invoiceController.reset();
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

                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: Product_Code,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            labelText: "Product Code ",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                        )),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                             Get.to(() => ProductList(
                                    isPur: 1,
                                  ));
                          },
                          onDoubleTap: () {
                            Get.to(() => PhonesList(
                                  ));
                             
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            //onPressed: () {
                             
                           // },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          color: Colors.black,
                          onPressed: () {
                            invoiceController.fetchProduct(Product_Code.text);
                          },
                          
                        ),

                        // Expanded(
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 25),
                        //     child: TextFormField(
                        //       controller: Product_Code,
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
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: IconButton(
                            icon: Icon(Icons.qr_code_scanner_rounded),
                            color: Colors.black,
                            onPressed: () {
                              barcodeController.scanBarcodeInv();
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Column(children: [
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Invoice Items',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: invoiceController.invoiceItems.length,
                            itemBuilder: (context, index) {
                              var product =
                                  invoiceController.invoiceItems[index];
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
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                product.Product_Name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              SizedBox(width: 5,),
                                              Text(product.Product_Color)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${product.Product_Code}'),
                                        Obx(() {
                                          return Row(
                                            children: [
                                              IconButton(
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Update Item Price'),
                                                          content: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                New_Price,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Enter New Price'),
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
                                                                if (New_Price
                                                                        .text !=
                                                                    '') {
                                                                  invoiceController.updateItemPrice(
                                                                      invoiceController
                                                                              .invoiceItems[
                                                                          index],
                                                                      double.tryParse(
                                                                          New_Price
                                                                              .text)!);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  New_Price
                                                                      .clear();
                                                                } else {
                                                                  Get.snackbar(
                                                                      'Error',
                                                                      'Add New Price');
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
                                                  icon:
                                                      Icon(Icons.price_change)),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        ' UP: ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        '${product.product_MPrice}\$ ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'TP: ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        CalPrice(
                                                                    product
                                                                        .quantity
                                                                        .value,
                                                                    product
                                                                        .product_MPrice)
                                                                .toString() +
                                                            '\$',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.green
                                                                .shade900),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (product.quantity.value ==
                                                      1) {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Remove Item?'),
                                                            // content: setupAlertDialoadContainer(),

                                                            actions: [
                                                              Center(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: OutlinedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            fixedSize:
                                                                                Size(double.infinity, 20),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            side:
                                                                                BorderSide(width: 2.0, color: Colors.red),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(32.0),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Text(
                                                                            'No',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Expanded(
                                                                      child: OutlinedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            fixedSize:
                                                                                Size(double.infinity, 20),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            side:
                                                                                BorderSide(width: 2.0, color: Colors.green),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(32.0),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            invoiceController.invoiceItems.removeAt(index);
                                                                            Navigator.of(context).pop();
                                                                            invoiceController.calculateTotal();
                                                                            invoiceController.calculateTotalQty();
                                                                            invoiceController.calculateTotalLb();
                                                                            invoiceController.calculateDueUSD();
                                                                            invoiceController.calculateDueLB();
                                                                            // _showeditAlertDialog(
                                                                            //     context,
                                                                            //     product_info[index]
                                                                            //         .Product_info_id);
                                                                            // Navigator.of(context).pop();
                                                                          },
                                                                          child: Text(
                                                                            'Yes',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    invoiceController.DecreaseQty(
                                                        invoiceController
                                                                .invoiceItems[
                                                            index]);
                                                  }
                                                },
                                                icon: Icon(Icons.remove)),
                                            Obx(() {
                                              return Text(
                                                  '${product.quantity.value}');
                                            }),
                                            IconButton(
                                                onPressed: () {
                                                  if (product.quantity.value ==
                                                      product
                                                          .Product_Quantity) {
                                                    Get.snackbar('Error',
                                                        'Max Quantity Reached');
                                                  } else {
                                                    invoiceController.IncreaseQty(
                                                        invoiceController
                                                                .invoiceItems[
                                                            index]);
                                                  }
                                                },
                                                icon: Icon(Icons.add)),
                                            IconButton(
                                                color: Colors.red,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Update Item Quantity'),
                                                        content: TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: New_Qty,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Enter New Quantity'),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (New_Qty
                                                                      .text !=
                                                                  '') {
                                                                if (int.tryParse(
                                                                        New_Qty
                                                                            .text)! ==
                                                                    0) {
                                                                  Get.snackbar(
                                                                      'Error',
                                                                      'Quantity Can\'t Be 0');
                                                                } else {
                                                                  invoiceController.UpdateQty(
                                                                      invoiceController
                                                                              .invoiceItems[
                                                                          index],
                                                                      double.tryParse(
                                                                          New_Qty
                                                                              .text)!);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  New_Qty
                                                                      .clear();
                                                                }
                                                              } else {
                                                                Get.snackbar(
                                                                    'Error',
                                                                    'Add New Price');
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
                                                icon: Icon(Icons
                                                    .production_quantity_limits)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Max Quantity: '),
                                            Text('${product.Product_Quantity}'),
                                          ],
                                        )
                                      ],
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
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Customer Name: '),
                                        Text(
                                          Cus_Name,
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
                                        Text('Customer Number: '),
                                        Text(
                                          Cus_Number,
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
                                            '${invoiceController.totalQty.toString()}'),
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
                                          addCommasToNumber(invoiceController
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
                                        Text('Invoice Total LL: '),
                                        Text(
                                          addCommasToNumber(invoiceController
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
                                        Text('Invoice Due USD: '),
                                        GestureDetector(
                                          onLongPress: () {
                                            copyToClipboard(
                                                invoiceController.DueLB.value);
                                          },
                                          child: Text(
                                            addCommasToNumber(double.tryParse(
                                                    CalDue(
                                                        invoiceController
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
                                        Text('Invoice Due LB: '),
                                        GestureDetector(
                                          onLongPress: () {
                                            copyToClipboard(
                                                invoiceController.DueLB.value);
                                          },
                                          child: Text(
                                            addCommasToNumber(invoiceController
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
                                              invoiceController.resetRecUsd();
                                            } else {
                                              invoiceController
                                                      .ReceivedUSD.value =
                                                  double.tryParse(Value)!;
                                              invoiceController
                                                  .calculateDueUSD();
                                              invoiceController
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
                                              invoiceController.resetRecLb();
                                            } else {
                                              invoiceController
                                                      .ReceivedLb.value =
                                                  double.tryParse(value)!;
                                              invoiceController
                                                  .calculateDueLB();
                                              invoiceController
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
                          backgroundColor: Colors.deepPurple.shade300,
                          side: BorderSide(
                              width: 2.0, color: Colors.deepPurple.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          if (invoiceController.invoiceItems.isNotEmpty) {
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
                            invoiceController
                                .uploadInvoiceToDatabase(
                                    Cus_id.toString(), Cus_Name, Cus_Number)
                                .then((value) =>
                                    showToast(invoiceController.result))
                                .then((value) => refreshProducts())
                                .then((value) => invoiceHistoryController
                                    .isDataFetched = false)
                                .then((value) =>
                                    invoiceHistoryController.fetchinvoices())
                                    .then((value) => invoiceDetailController
                                    .isDataFetched = false)
                                .then((value) =>
                                    invoiceDetailController.fetchinvoicesdetails())
                                .then((value) => invoiceController.reset())
                                .then((value) => invoiceController.reset())
                                .then((value) => Navigator.of(context).pop())
                                .then((value) => Navigator.of(context).pop());
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
