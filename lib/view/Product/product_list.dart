// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/homescreen_manage_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/purchase_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/controller/transfer_controller.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/view/Product/product_edit.dart';
import 'package:treschic/view/Product/product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class ProductList extends StatefulWidget {
  int isPur, from_home;
  ProductList({super.key, required this.isPur, required this.from_home});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductController productController = Get.find<ProductController>();

  final BarcodeController barcodeController = Get.find<BarcodeController>();

  final PurchaseController purchaseController = Get.put(PurchaseController());

  final HomeController homeController = Get.find<HomeController>();

  final TransferController transferController = Get.find<TransferController>();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  final InvoiceController invoiceController = Get.find<InvoiceController>();

  RxString Username = ''.obs;

  TextEditingController Product_Name = TextEditingController();

  Future<void> set() async {
    Product_Name.text = barcodeController.barcode3.value;
    productController.searchProducts(Product_Name.text);
    productController.products.refresh();
  }

  TextEditingController scannedBarcode = TextEditingController();

  void _onBarcodeScanned(String barcode) {
    productController.searchProducts(barcode);
    productController.products.refresh();

    print("Barcode scanned: $barcode");
    // Add your desired function here to handle the scanned barcode
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

    bool checkpurchase() {
      if (widget.isPur == 0) {
        return true;
      } else {
        return false;
      }
    }

    // productController.fetchproducts();
    return Scaffold(
      //backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          // backgroundColor: Colors.grey.shade100,
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Product List'),
          // IconButton(
          //   color: Colors.blue.shade900,
          //   iconSize: 24.0,
          //   onPressed: () {
          //     Get.toNamed('/NewCat');
          //   },
          //   icon: Icon(CupertinoIcons.add),
          // ),
          Container(
            decoration: BoxDecoration(
              // color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    Get.toNamed('/BuyAccessories');
                    // categoryController.isDataFetched =false;
                    // categoryController.fetchcategories();
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    productController.isDataFetched = false;
                    productController.fetchproducts();
                    // categoryController.isDataFetched =false;
                    // categoryController.fetchcategories();
                  },
                  icon: Icon(CupertinoIcons.refresh),
                ),
              ],
            ),
          ),
        ],
      )),
      body: BarcodeKeyboardListener(
        onBarcodeScanned: (barcode) {
          // Update the text field with the scanned barcode
          Product_Name.text = barcode;

          // Trigger search function with the scanned barcode
          productController.searchProducts(barcode);
        },
        child: PopScope(
          canPop: true,
          onPopInvoked: (result) {
            if (widget.from_home == 1) {
              homeController.selectedPageIndex.value = 0;
              barcodeController.barcode3.value = '';
            } else {
              //  Navigator.of(context).pop();
              barcodeController.barcode3.value = '';
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        Product_Name.text = barcodeController.barcode3.value;

                        return Container(
                            decoration: BoxDecoration(
                              //   color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                //   obscureText: true,
                                //  readOnly: isLoading,
                                onChanged: (value) {
                                  productController.products.refresh();
                                },
                                controller: Product_Name,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Product_Name.clear();
                                      productController.products.refresh();
                                    },
                                  ),
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  hintText: 'Search By Name or Code',
                                ),
                              ),
                            ));
                      }),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey.shade500,
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.qr_code),
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
                    final List<ProductModel> filteredCategories =
                        productController.searchProducts(Product_Name.text);
                    if (productController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (productController.products.isEmpty) {
                      return Center(child: Text('No Products Yet ! Add Some '));
                    } else {
                      return ListView.builder(
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final ProductModel product =
                              filteredCategories[index];
                          return Container(
                            decoration: BoxDecoration(
                              // color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                                copyToClipboard(product.Product_Code);
                              },
                              title: Text(
                                '#' +
                                    product.Product_id.toString() +
                                    ' ' +
                                    product.Product_Name +
                                    ' ' // +
                                // ' -- ' +
                                // product.Product_Code,
                                ,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Product Code:  ' +
                                            product.Product_Code),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text('Category: ' +
                                                  product.Product_Cat +
                                                  ' || ' +
                                                  product.PRoduct_Sub_Cat +
                                                  ' || ' +
                                                  product.Product_Brand),
                                            ),
                                          ],
                                        ),

                                        //Text('Brand: ' + product.Product_Brand),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Max Price: ' +
                                                  product.product_MPrice
                                                      .toString() +
                                                  '\$',
                                              style: TextStyle(
                                                  color: Colors.green.shade900),
                                            ),
                                            Text(
                                              ' Lowest Price: ' +
                                                  product.Product_LPrice
                                                      .toString() +
                                                  '\$',
                                              style: TextStyle(
                                                  color: Colors.red.shade900),
                                            ),
                                          ],
                                        ),

                                        Visibility(
                                          visible: productController
                                              .isadmin(Username.value),
                                          child: Text(
                                            'Cost Price: ' +
                                                product.product_Cost
                                                    .toString() +
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // fixedSize:
                                                    //     Size(double.maxFinite, 20),
                                                    backgroundColor:
                                                        Colors.red.shade100,
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
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
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
                                                                    .Product_Code,
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
                                                                            fixedSize:
                                                                                Size(double.infinity, 20),
                                                                            backgroundColor:
                                                                                Colors.red.shade900,
                                                                            side:
                                                                                BorderSide(width: 2.0, color: Colors.red.shade900),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(32.0),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.qr_code,
                                                        color:
                                                            Colors.red.shade900,
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
                                              visible: checkpurchase(),
                                              child: Expanded(
                                                child: OutlinedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // fixedSize:
                                                      //     Size(double.maxFinite, 20),
                                                      backgroundColor:
                                                          Colors.green.shade100,
                                                      side: BorderSide(
                                                        width: 2.0,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      purchaseController
                                                          .fetchProduct(product
                                                              .Product_Code);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.add,
                                                          color: Colors
                                                              .green.shade900,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // fixedSize:
                                                    //     Size(double.maxFinite, 20),
                                                    backgroundColor:
                                                        Colors.blue.shade100,
                                                    side: BorderSide(
                                                      width: 2.0,
                                                      color:
                                                          Colors.blue.shade900,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(
                                                        () => ProductListDetail(
                                                              Product_id: product
                                                                      .Product_id
                                                                  .toString(),
                                                              Product_Name: product
                                                                  .Product_Name,
                                                              Product_LPrice:
                                                                  product.Product_LPrice
                                                                      .toString(),
                                                              Product_MPrice: product
                                                                  .product_MPrice
                                                                  .toString(),
                                                              Product_Code: product
                                                                  .Product_Code,
                                                              isPur: widget
                                                                  .isPur
                                                                  .toString(),
                                                            ));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_circle_right_rounded,
                                                        color: Colors
                                                            .blue.shade900,
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
      ),
    );
  }
}
