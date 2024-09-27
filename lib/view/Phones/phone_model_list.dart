// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/bulk_phone_purchase_controller.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/purchase_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/phonemodels_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Phones/add_phone_model.dart';
import 'package:fixnshop_admin/view/Product/product_edit.dart';
import 'package:fixnshop_admin/view/Product/product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class PhoneModelList extends StatelessWidget {
  PhoneModelList({super.key});
  final PhoneModelController phoneModelController = Get.find<PhoneModelController>();
   final BarcodeController barcodeController = Get.find<BarcodeController>();
  // final PurchaseController purchaseController = Get.put(PurchaseController());
  // final HomeController homeController = Get.find<HomeController>();
   final BulkPhonePurchaseController bulkPhonePurchaseController = Get.find<BulkPhonePurchaseController>();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final InvoiceController invoiceController = Get.find<InvoiceController>();
  RxString Username = ''.obs;
  TextEditingController Phone_Name = TextEditingController();

  Future<void> set() async {
    // Phone_Name.text = barcodeController.barcode3.value;
    // phoneModelController.searchProducts(Phone_Name.text);
    // phoneModelController.products.refresh();
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

    // phoneModelController.fetchproducts();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Phones Model List'),
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
                      Get.to(PhoneModelAdd());
                      // categoryController.isDataFetched =false;
                      // categoryController.fetchcategories();
                    },
                    icon: Icon(CupertinoIcons.add),
                  ),
                  IconButton(
                    color: Colors.deepPurple,
                    iconSize: 24.0,
                    onPressed: () {
                      phoneModelController.isDataFetched = false;
                      phoneModelController.fetchphonemodel();
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
        onPopInvoked: (result) {
          
            //  Navigator.of(context).pop();
            barcodeController.barcode3.value = '';
          
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      Phone_Name.text = barcodeController.barcode3.value;

                      return TextField(
                        controller: Phone_Name,
                        onChanged: (query) {
                          phoneModelController.phone_model.refresh();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search Phones by Name',
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
                  final List<PhoneModelsModel> filteredCategories =
                      phoneModelController.searchProducts(Phone_Name.text);
                  if (phoneModelController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (phoneModelController.phone_model.isEmpty) {
                    return Center(child: Text('No Phone Models Yet ! Add Some '));
                  } else {
                    return ListView.builder(
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final PhoneModelsModel phone = filteredCategories[index];
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
                            onLongPress: () {
                              // copyToClipboard(phone.Product_Code);
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  phone.Phone_Name 
                                  // +
                                  // ' -- ' +
                                  // phone.Product_Code,
                                  ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            // fixedSize:
                                            //     Size(double.maxFinite, 20),
                                            backgroundColor:
                                                Colors.green.shade100,
                                            side: BorderSide(
                                              width: 2.0,
                                              color:
                                                  Colors.green.shade900,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                                bulkPhonePurchaseController.FetchPhone(phone.Phone_Name);
                                              // purchaseController
                                              //     .fetchProduct(phone
                                              //         .Product_Code);
                                            
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color:
                                                    Colors.green.shade900,
                                                //  'Details',
                                                //   style: TextStyle(
                                                //        color: Colors.red),
                                              ),
                                            ],
                                          )),
                              ],
                            ),
                            
                        ));
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
