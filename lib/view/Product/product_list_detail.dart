// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:treschic/controller/category_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/purchase_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/controller/sub_category_controller.dart';
import 'package:treschic/controller/transfer_controller.dart';
import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/product_detail_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/view/Product/add_product_detail.dart';
import 'package:treschic/view/Product/product_list_detail_other.dart';
import 'package:treschic/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProductListDetail extends StatelessWidget {
  String Product_id,
      Product_Name,
      Product_LPrice,
      Product_MPrice,
      Product_Code,
      isPur;
  ProductListDetail(
      {super.key,
      required this.Product_id,
      required this.Product_Name,
      required this.Product_LPrice,
      required this.Product_MPrice,
      required this.Product_Code,
      required this.isPur});
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  TextEditingController New_Qty = TextEditingController();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  final TransferController transferController = Get.find<TransferController>();
  final PurchaseController purchaseController = Get.put(PurchaseController());

  final InvoiceController invoiceController = Get.find<InvoiceController>();

  RxString Username = ''.obs;
  final RxString filter = ''.obs;
  final TextEditingController filterController = TextEditingController();
  // TextEditingController Product_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    // productDetailController.isDataFetched = false;
    // productDetailController.fetchproductdetails();
    print(Username.value);
    List<ProductDetailModel> filteredProductDetails() {
      final filterText = filter.value.toLowerCase();

      return productDetailController.product_detail
          .where((product_details) =>
              product_details.Product_id == int.tryParse(Product_id) &&
              product_details.Username == Username.value &&
              (product_details.Product_Color.toLowerCase()
                      .contains(filterText) ||
                  product_details.Product_Size.toLowerCase()
                      .contains(filterText) ||
                  product_details.Product_Store.toLowerCase()
                      .contains(filterText) ||
                  product_details.pdetail_code
                      .toLowerCase()
                      .contains(filterText)))
          .toList();
    }

    //  productDetailController.product_detail.clear();
    // productDetailController.isDataFetched = false;
    //  productDetailController.fetchproductdetails(Product_id);
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Product List Detail'),
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
                    Get.to(() => AddProductDetail(
                          Product_id: Product_id,
                          Product_Name: Product_Name,
                          Product_Code: Product_Code,
                          Product_LPrice: Product_LPrice,
                          Product_MPrice: Product_MPrice,
                        ));
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    productDetailController.isDataFetched = false;
                    productDetailController.fetchproductdetails();
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      // fixedSize:
                      //     Size(double.maxFinite, 20),
                      backgroundColor: Colors.green.shade100,
                      side: BorderSide(
                        width: 2.0,
                        color: Colors.green.shade900,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      Get.to(ProductListDetailOther(
                          Product_id: Product_id,
                          Product_Name: Product_Name,
                          Product_LPrice: Product_LPrice,
                          Product_MPrice: Product_MPrice,
                          Product_Code: Product_Code,
                          isPur: isPur));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'From Other Stores',
                          style: TextStyle(color: Colors.green.shade900),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.green.shade900,
                          //  'Details',
                          //   style: TextStyle(
                          //        color: Colors.red),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  //maxLength: 15,
                  initialValue: '#' + Product_id + ' ' + Product_Name,
                  readOnly: true,
                  //controller: Product_Name,
                  decoration: InputDecoration(
                    //helperText: '*',

                    //  hintText: '03123456',
                    labelText: "Product Name",
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
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //maxLength: 15,
                  initialValue: Product_Code,
                  readOnly: true,
                  //controller: Product_Name,
                  decoration: InputDecoration(
                    //helperText: '*',

                    //  hintText: '03123456',
                    labelText: "Product Code",
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
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        //   maxLength: 50,
                        //   initialValue: Product_Code,
                        keyboardType: TextInputType.number,
                        initialValue: Product_LPrice,
                        decoration: InputDecoration(
                          labelText: "Lowest Price ",
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
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        //   maxLength: 50,
                        //   initialValue: Product_Code,
                        keyboardType: TextInputType.number,
                        initialValue: Product_MPrice,
                        decoration: InputDecoration(
                          labelText: "Max Price ",
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
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: filterController,
                  decoration: InputDecoration(
                    labelText: "Filter by Code,Color,Size or Store",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  onChanged: (value) {
                    filter.value = value;
                  },
                ),
                SizedBox(height: 20),
                Obx(
                  () {
                    final List<ProductDetailModel> filteredproducts =
                        filteredProductDetails();
                    if (productDetailController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (filteredproducts.isEmpty) {
                      return Center(child: Text('No Quantity Yet ! Add Some'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredproducts.length,
                        itemBuilder: (context, index) {
                          final ProductDetailModel product =
                              filteredproducts[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.Product_Color +
                                                ' | ' +
                                                product.Product_Size,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            product.pdetail_code,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            product.Product_Store +
                                                ' Store ' +
                                                product.PD_id.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        product.Product_Quantity.toString() +
                                            ' PCS',
                                        style: TextStyle(
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
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
                                      Text('Bought: ' +
                                          product.Product_Max_Quantity
                                              .toString()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Sold: ' +
                                          product.Product_Sold_Quantity
                                              .toString()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('Transfered: ' +
                                          product.Product_Transfered_Qty
                                              .toString()),
                                    ],
                                  ),
                                  OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        // fixedSize:
                                        //     Size(double.maxFinite, 20),
                                        backgroundColor: Colors.green.shade100,
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
                                        print(isPur);
                                        if (isPur == '1') {
                                          invoiceController.fetchProduct(
                                              product.pdetail_code);
                                        } else if (isPur == '3') {
                                          transferController.fetchProduct(
                                              product.pdetail_code);
                                        } else {
                                          purchaseController.fetchProduct(
                                              product.pdetail_code);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.green.shade900,
                                            //  'Details',
                                            //   style: TextStyle(
                                            //        color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  Visibility(
                                    visible: productDetailController
                                        .isadmin(Username.value),
                                    child: IconButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Update Item Quantity'),
                                                content: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: New_Qty,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter New Quantity'),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (New_Qty.text != '') {
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
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          20),
                                                                  child: Column(
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
                                                        productDetailController.UpdateProductQty(
                                                                product.PD_id
                                                                    .toString(),
                                                                New_Qty.text)
                                                            .then((value) =>
                                                                showToast(
                                                                    productDetailController
                                                                        .result2))
                                                            .then((value) =>
                                                                productDetailController.isDataFetched =
                                                                    false)
                                                            .then((value) =>
                                                                productDetailController
                                                                    .fetchproductdetails())
                                                            .then((value) =>
                                                                Navigator.of(context)
                                                                    .pop())
                                                            .then((value) =>
                                                                Navigator.of(context).pop());

                                                        New_Qty.clear();
                                                      } else {
                                                        Get.snackbar('Error',
                                                            'Add New Quantity');
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
                                        icon: Icon(Icons.edit)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
