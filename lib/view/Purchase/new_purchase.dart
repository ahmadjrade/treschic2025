// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/color_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/purchase_controller.dart';
import 'package:treschic/controller/purchase_history_controller.dart';
import 'package:treschic/controller/rate_controller.dart';
import 'package:treschic/controller/size_controller.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/size_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:treschic/view/Product/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:treschic/view/Sizes/add_size.dart';

class New_Purchase extends StatelessWidget {
  String Supp_id, Supp_Name, Supp_Number;
  New_Purchase(
      {super.key,
      required this.Supp_id,
      required this.Supp_Name,
      required this.Supp_Number});
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  TextEditingController New_Price = TextEditingController();
  TextEditingController New_Qty = TextEditingController();

  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  final PurchaseHistoryController purchaseHistoryController =
      Get.find<PurchaseHistoryController>();
  TextEditingController Product_Code = TextEditingController();
  final PurchaseController purchaseController = Get.put(PurchaseController());
  final RateController rateController = Get.find<RateController>();
  final ColorController colorController = Get.find<ColorController>();
  final SizeController sizeController = Get.find<SizeController>();

  ColorModel? SelectedColor;
  int SelectedColorId = 0;
  String SelectedColorName = '';

  SizeModel? SelectedSize;
  int SelectedSizeId = 0;
  String SelectedSizeName = '';

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

  bool isVisible = false;
  TextEditingController i = TextEditingController();

  @override
  Widget build(BuildContext context) {
    updateVisiblity(int isVis) {
      if (isVis == 1) {
        isVisible = true;
        print(isVisible);
      }
    }

    // purchaseController.reset();
    Future<void> refreshProducts() async {
      purchaseController.purchaseItems.clear();

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
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('New Purchase'),
          // IconButton(
          //   color: Colors.deepPurple,
          //   iconSize: 24.0,
          //   onPressed: () {
          //     Get.toNamed('/NewCat');
          //   },
          //   icon: Icon(CupertinoIcons.add),
          // ),
          Container(
            // height: 40,
            // width: 150,
            decoration: BoxDecoration(
              // color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // IconButton(
                //   color: Colors.blue.shade900,
                //   //iconSize: 17.0,
                //   onPressed: () {
                //     Get.toNamed('/BuyAccessories');
                //   },
                //   icon: Icon(CupertinoIcons.add),
                // ),
                IconButton(
                  color: Colors.blue.shade900,
                  //iconSize: 17.0,
                  onPressed: () {
                    refreshProducts();
                    refreshRate();
                  },
                  icon: Icon(CupertinoIcons.refresh),
                ),
                IconButton(
                  color: Colors.blue.shade900,
                  //  iconSize: 17.0,
                  onPressed: () {
                    purchaseController.reset();
                    purchaseController.reset();
                    purchaseController.reset();
                  },
                  icon: Icon(CupertinoIcons.clear),
                ),
              ],
            ),
          ),
        ],
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              //color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                //obscureText: true,
                                //  readOnly: isLoading,
                                controller: Product_Code,

                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Product_Code.clear();
                                      //customerController.customers.refresh();
                                    },
                                  ),
                                  prefixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        Get.to(() => ProductList(
                                              isPur: 0,
                                              from_home: 0,
                                            ));
                                      }),
                                  border: InputBorder.none,
                                  hintText: 'Product Code',
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade500,
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code,
                            size: 17,
                          ),
                          onPressed: () {
                            barcodeController.scanBarcodeInv();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade500,
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.done,
                            size: 17,
                          ),
                          onPressed: () {
                            purchaseController.fetchProduct(Product_Code.text);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return Column(children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Purchse Items',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      child: ListView.builder(
                        controller: purchaseController
                            .scrollController, // Attach ScrollController

                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: purchaseController.purchaseItems.length,
                        itemBuilder: (context, index) {
                          var product = purchaseController.purchaseItems[index];
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
                                      child: Text(
                                        product.Product_Name +
                                            '\n' +
                                            product.Product_Code,
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                                            purchaseController.purchaseItems.removeAt(index);
                                                                            Navigator.of(context).pop();
                                                                            purchaseController.calculateTotal();
                                                                            purchaseController.calculateTotalQty();
                                                                            purchaseController.calculateTotalLb();
                                                                            purchaseController.calculateDueUSD();
                                                                            purchaseController.calculateDueLB();
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
                                                    purchaseController
                                                        .DecreaseQty(index);
                                                  }
                                                },
                                                icon: Icon(Icons.remove)),
                                            Obx(() {
                                              return OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // fixedSize: Size(
                                                    //     double.maxFinite,
                                                    //     50),
                                                    backgroundColor:
                                                        Colors.white,
                                                    side: BorderSide(
                                                        width: 2.0,
                                                        color: Colors
                                                            .blue.shade900),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
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
                                                              child: Text(
                                                                  'Cancel'),
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
                                                                    purchaseController.UpdateQty(
                                                                        purchaseController.purchaseItems[
                                                                            index],
                                                                        int.tryParse(
                                                                            New_Qty.text)!);
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
                                                  child: Text(
                                                    '${product.quantity.value}',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ));
                                            }),
                                            IconButton(
                                                onPressed: () {
                                                  print(index);
                                                  purchaseController
                                                      .increaseQuantityByIndex(
                                                          index);
                                                },
                                                icon: Icon(Icons.add)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                        return Row(
                                          children: [
                                            Visibility(
                                                visible: true,
                                                child: OutlinedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // fixedSize: Size(
                                                      //     double.maxFinite, 50),
                                                      backgroundColor:
                                                          Colors.white,
                                                      side: BorderSide(
                                                          width: 2.0,
                                                          color: Colors
                                                              .red.shade900),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      purchaseController
                                                          .purchaseItems
                                                          .removeAt(index);
                                                      purchaseController
                                                          .update();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          color: Colors
                                                              .red.shade900,
                                                        ),
                                                      ],
                                                    ))),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            // Text(product.Product_Code),
                                            Expanded(
                                              child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // fixedSize: Size(
                                                    //     double.maxFinite, 50),
                                                    backgroundColor:
                                                        Colors.white,
                                                    side: BorderSide(
                                                        width: 2.0,
                                                        color: Colors
                                                            .blue.shade900),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (purchaseController
                                                            .purchaseItems[
                                                                index]
                                                            .ColorName_shrt ==
                                                        '') {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Update Product Color'),
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
                                                                            child:
                                                                                DropdownButtonFormField<ColorModel>(
                                                                              decoration: InputDecoration(
                                                                                labelText: "Color",
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
                                                                              iconDisabledColor: Colors.blue.shade100,
                                                                              iconEnabledColor: Colors.blue.shade100,
                                                                              //   value: colorController.colors.first,
                                                                              onChanged: (ColorModel? value) {
                                                                                SelectedColor = value;
                                                                                SelectedColorId = (SelectedColor?.Color_id)!;
                                                                                SelectedColorName = (SelectedColor?.Color)!;
                                                                                product.ColorName_shrt = (SelectedColor?.Color_name)!;
                                                                                purchaseController.UpdateProductColor(index, SelectedColorId, SelectedColorName);
                                                                                Navigator.of(context).pop();
                                                                                purchaseController.UpdateProductVis(index, 1);
                                                                                purchaseController.isShown = true.obs;

                                                                                updateVisiblity(product.isVis);
                                                                                print(SelectedColorId);
                                                                              },
                                                                              items: colorController.colors
                                                                                  .map((color) => DropdownMenuItem<ColorModel>(
                                                                                        value: color,
                                                                                        child: Text(color.Color),
                                                                                      ))
                                                                                  .toList(),
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            color:
                                                                                Colors.black,
                                                                            iconSize:
                                                                                24.0,
                                                                            icon:
                                                                                Icon(CupertinoIcons.add),
                                                                            onPressed:
                                                                                () {
                                                                              //customerController.searchCustomer(numberController);
                                                                              Get.toNamed('/NewColor');
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      showToast(
                                                          'Color already selected');
                                                    }

                                                    // bulkPhonePurchaseController.UpdatePhonePrice(product, 10);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.color_lens,
                                                        color: Colors
                                                            .blue.shade900,
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                        product.ColorName
                                                                .toString()
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue.shade900,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Obx(() {
                                              return Visibility(
                                                visible: purchaseController
                                                    .isShown.value,
                                                child: OutlinedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // fixedSize: Size(
                                                      //     double.maxFinite, 50),
                                                      backgroundColor:
                                                          Colors.white,
                                                      side: BorderSide(
                                                          width: 2.0,
                                                          color: Colors
                                                              .blue.shade900),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (purchaseController
                                                              .purchaseItems[
                                                                  index]
                                                              .Size_shrt ==
                                                          '') {
                                                        if (purchaseController
                                                                .purchaseItems[
                                                                    index]
                                                                .ColorName_shrt ==
                                                            '') {
                                                          Get.snackbar('Error',
                                                              'Select Color First');
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Update Product Size'),
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
                                                                              child: DropdownButtonFormField<SizeModel>(
                                                                                decoration: InputDecoration(
                                                                                  labelText: "Sizes",
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
                                                                                iconDisabledColor: Colors.blue.shade100,
                                                                                iconEnabledColor: Colors.blue.shade100,
                                                                                //   value: colorController.colors.first,
                                                                                onChanged: (SizeModel? value) {
                                                                                  SelectedSize = value;
                                                                                  SelectedSizeId = (SelectedSize?.Size_id)!;
                                                                                  SelectedSizeName = (SelectedSize?.Size)!;
                                                                                  product.Size_shrt = (SelectedSize?.Shortcut)!;
                                                                                  purchaseController.UpdateProductSize(index, SelectedSizeId, product.Size_shrt);

                                                                                  purchaseController.UpdateProductCode(index);
                                                                                  SelectedColorId = 0;
                                                                                  SelectedSizeId = 0;
                                                                                  SelectedColorName = '';
                                                                                  SelectedSizeName = '';

                                                                                  Navigator.of(context).pop();

                                                                                  print(SelectedColorId);
                                                                                },
                                                                                items: sizeController.sizes
                                                                                    .map((size) => DropdownMenuItem<SizeModel>(
                                                                                          value: size,
                                                                                          child: Text(size.Size),
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
                                                                                Get.to(AddSize());
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
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
                                                        }
                                                      } else {
                                                        showToast(
                                                            'Size already Selected');
                                                      }

                                                      // bulkPhonePurchaseController.UpdatePhonePrice(product, 10);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .format_size_rounded,
                                                          color: Colors
                                                              .blue.shade900,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          product.Size
                                                                  .toString()
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors.blue
                                                                  .shade900),
                                                        ),
                                                      ],
                                                    )),
                                              );
                                            })
                                          ],
                                        );
                                      }),
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
                                        '${purchaseController.totalQty.toString()}'),
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
                            //         Text('Purchase Total: '),
                            //         Text(
                            //           addCommasToNumber(purchaseController
                            //                   .totalUsd.value) +
                            //               ' \$',
                            //           style: TextStyle(
                            //               color: Colors.green.shade900),
                            //         ),
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
                            //         Text('Purchase Total LL: '),
                            //         Text(
                            //           addCommasToNumber(purchaseController
                            //                   .totalLb.value) +
                            //               ' LB',
                            //           style: TextStyle(
                            //               color: Colors.green.shade900),
                            //         ),
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
                            //         Text('Purchase Due USD: '),
                            //         GestureDetector(
                            //           onLongPress: () {
                            //             copyToClipboard(
                            //                 purchaseController.DueLB.value);
                            //           },
                            //           child: Text(
                            //             addCommasToNumber(double.tryParse(
                            //                     CalDue(
                            //                         purchaseController
                            //                             .DueLB.value,
                            //                         rateController
                            //                             .rateValue.value))!) +
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
                            //         Text('Purchase Due LB: '),
                            //         GestureDetector(
                            //           onLongPress: () {
                            //             copyToClipboard(
                            //                 purchaseController.DueLB.value);
                            //           },
                            //           child: Text(
                            //             addCommasToNumber(purchaseController
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
                            //               purchaseController.resetRecUsd();
                            //             } else {
                            //               purchaseController.ReceivedUSD.value =
                            //                   double.tryParse(Value)!;
                            //               purchaseController.calculateDueUSD();
                            //               purchaseController.calculateDueLB();
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
                            //               purchaseController.resetRecLb();
                            //             } else {
                            //               purchaseController.ReceivedLb.value =
                            //                   double.tryParse(value)!;
                            //               purchaseController.calculateDueLB();
                            //               purchaseController.calculateDueUSD();
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
                      backgroundColor: Colors.blue.shade100,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      if (purchaseController.purchaseItems.isNotEmpty) {
                        int? invalidIndex =
                            purchaseController.validatePurchaseItems();

                        if (invalidIndex != null) {
                          Get.snackbar(
                            'Error',
                            'Item at index ${invalidIndex + 1} is missing a color or size.',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 3),
                          );
                          // purchaseController.scrollToInvalidItem(invalidIndex);

                          return; // Stop further processing
                        } else {
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
                          purchaseController
                              .uploadPurchaseToDatabase(
                                  Supp_id.toString(), Supp_Name, Supp_Number)
                              .then((value) =>
                                  showToast(purchaseController.result))
                              .then((value) => refreshProducts())
                              .then((value) => purchaseController.reset())
                              .then((value) => purchaseController.reset())
                              .then((value) => purchaseHistoryController
                                  .isDataFetched = false)
                              .then((value) =>
                                  purchaseHistoryController.fetchpurchases())
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => Navigator.of(context).pop());
                        }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
