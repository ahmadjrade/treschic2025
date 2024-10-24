// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/purchase_controller.dart';
import 'package:fixnshop_admin/controller/repair_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/repair_product_model.dart';
import 'package:fixnshop_admin/view/Product/product_edit.dart';
import 'package:fixnshop_admin/view/Product/product_list_detail.dart';
import 'package:fixnshop_admin/view/Repairs/buy_repair_product.dart';
import 'package:fixnshop_admin/view/Repairs/repair_product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class RepairProductList extends StatelessWidget {
  int isPur, isCreated;
  RepairProductList({super.key, required this.isPur, required this.isCreated});
  final RepairProductController repairProductController =
      Get.find<RepairProductController>();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  final PurchaseController purchaseController = Get.put(PurchaseController());
  final HomeController homeController = Get.find<HomeController>();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RepairController repairController = Get.find<RepairController>();
  RxString Username = ''.obs;
  TextEditingController Product_Name = TextEditingController();

  Future<void> set() async {
    Product_Name.text = barcodeController.barcode3.value;
    repairProductController.searchProducts(Product_Name.text);
    repairProductController.repair_products.refresh();
  }

  bool isCr(int iscreated) {
    if (iscreated == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText));
      // Show a snackbar or any other feedback that the text has been copied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product Code copied to clipboard'),
        ),
      );
    }

    // repairProductController.fetchproducts();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Repair Product List'),
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
                      Get.to(() => BuyRepairProduct());

                      // categoryController.isDataFetched =false;
                      // categoryController.fetchcategories();
                    },
                    icon: Icon(CupertinoIcons.add),
                  ),
                  IconButton(
                    color: Colors.deepPurple,
                    iconSize: 24.0,
                    onPressed: () {
                      repairProductController.isDataFetched = false;
                      repairProductController.fetchproducts();
                      // categoryController.isDataFetched =false;
                      // categoryController.fetchcategories();
                    },
                    icon: Icon(CupertinoIcons.refresh),
                  ),
                ],
              ),
            ],
          )),
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          homeController.selectedPageIndex.value = 0;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      Product_Name.text = barcodeController.barcode3.value;
                      return TextField(
                        controller: Product_Name,
                        onChanged: (query) {
                          repairProductController.repair_products.refresh();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search by Name or Code',
                          prefixIcon: Icon(Icons.search),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.qr_code_scanner_rounded),
                      color: Colors.black,
                      onPressed: () {
                        barcodeController
                            .scanBarcodeSearch()
                            .then((value) => set());
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(
                () {
                  final List<RepairProductModel> filteredCategories =
                      repairProductController.searchProducts(Product_Name.text);
                  if (repairProductController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (repairProductController.repair_products.isEmpty) {
                    return Center(
                        child: Text('No Repair Products Yet ! Add Some '));
                  } else {
                    return ListView.builder(
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final RepairProductModel product =
                            filteredCategories[index];
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.shade300),
                          //  width: double.infinity,
                          //   height: 150.0,
                          //color: Colors.grey.shade200,
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          //     padding: EdgeInsets.all(35),
                          alignment: Alignment.center,
                          child: ListTile(
                            // leading: Column(
                            //   children: [
                            //     Expanded(
                            //       child: product.imageUrl != null
                            //           ? Image.network(product.imageUrl!)
                            //           : Placeholder(),
                            //     ),
                            //   ],
                            // ),
                            // leading: product.imageUrl != ''
                            //     ? CachedNetworkImage(
                            //         width: 50,
                            //         imageUrl: product.imageUrl!,
                            //         placeholder: (context, url) => Center(
                            //             child: CircularProgressIndicator()),
                            //         errorWidget: (context, url, error) =>
                            //             Icon(Icons.error),
                            //       )
                            //     : SizedBox(
                            //         width: 50,
                            //         child: Icon(Icons.image_not_supported_sharp)),
                            onLongPress: () {
                              copyToClipboard(product.Repair_p_code);
                            },
                            title: Text(
                              product.Repair_p_name + ' ' + product.Color
                              // +
                              // ' -- ' +
                              // product.Product_Code,
                              ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Product Code:  ' +
                                          product.Color +
                                          '\nCategory: ' +
                                          product.Cat_Name +
                                          ' || ' +
                                          product.Sub_Cat_Name +
                                          ' || ' +
                                          product.Brand_Name),
                                      //Text('Brand: ' + product.Product_Brand),

                                      Row(
                                        children: [
                                          Text(
                                            ' Price: ' +
                                                product.Repair_p_price
                                                    .toString() +
                                                '\$',
                                            style: TextStyle(
                                                color: Colors.green.shade900),
                                          ),
                                        ],
                                      ),

                                      Visibility(
                                        visible: repairProductController
                                            .isadmin(Username.value),
                                        child: Text(
                                          'Cost Price: ' +
                                              product.Repair_p_cost.toString() +
                                              '\$',
                                          style: TextStyle(
                                              color: Colors.blue.shade900),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                                style: ElevatedButton.styleFrom(
                                                  // fixedSize:
                                                  //     Size(double.maxFinite, 20),
                                                  backgroundColor:
                                                      Colors.red.shade900,
                                                  side: BorderSide(
                                                    width: 2.0,
                                                    color: Colors.red.shade900,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: SizedBox(
                                                            child:
                                                                BarcodeWidget(
                                                              barcode: Barcode
                                                                  .code128(),
                                                              data: product
                                                                  .Repair_p_code,
                                                            ),
                                                          ),
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
                                                                          fixedSize: Size(
                                                                              double.infinity,
                                                                              20),
                                                                          backgroundColor: Colors
                                                                              .red
                                                                              .shade900,
                                                                          side: BorderSide(
                                                                              width: 2.0,
                                                                              color: Colors.red.shade900),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(32.0),
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                          'Close',
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
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.qr_code,
                                                      color: Colors.white,
                                                      //  'Details',
                                                      //   style: TextStyle(
                                                      //        color: Colors.red),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                            visible: isCr(isCreated),
                                            child: Expanded(
                                              child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // fixedSize:
                                                    //     Size(double.maxFinite, 20),
                                                    backgroundColor:
                                                        Colors.red.shade900,
                                                    side: BorderSide(
                                                      width: 2.0,
                                                      color:
                                                          Colors.red.shade900,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (isPur == 1) {
                                                      repairController
                                                          .fetchProduct(product
                                                              .Repair_p_code);
                                                    } else {
                                                      purchaseController
                                                          .fetchProduct(product
                                                              .Repair_p_code);
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        //  'Details',
                                                        //   style: TextStyle(
                                                        //        color: Colors.red),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: OutlinedButton(
                                                style: ElevatedButton.styleFrom(
                                                  // fixedSize:
                                                  //     Size(double.maxFinite, 20),
                                                  backgroundColor:
                                                      Colors.red.shade900,
                                                  side: BorderSide(
                                                    width: 2.0,
                                                    color: Colors.red.shade900,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.to(() =>
                                                      RepairProductListDetail(
                                                        Repair_Product_id:
                                                            product.Repair_p_id
                                                                .toString(),
                                                        Repair_Product_Name:
                                                            product
                                                                .Repair_p_name,
                                                        Repair_Product_Color:
                                                            product.Color,
                                                        Repair_Product_Price:
                                                            product.Repair_p_price
                                                                .toString(),
                                                        Repair_Product_Code:
                                                            product
                                                                .Repair_p_code,
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color: Colors.white,
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
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                // product.imageUrl != ''
                                //     ? CachedNetworkImage(
                                //         width: 50,
                                //         imageUrl: product.imageUrl!,
                                //         placeholder: (context, url) => Center(
                                //             child: CircularProgressIndicator()),
                                //         errorWidget: (context, url, error) =>
                                //             Icon(Icons.error),
                                //       )
                                //     : SizedBox(
                                //         width: 50,
                                //         child: Icon(
                                //             Icons.image_not_supported_sharp)),
                              ],
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
      ),
    );
  }
}
