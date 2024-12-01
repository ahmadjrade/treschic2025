// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/repair_product_detail_model.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RepairProductListDetail extends StatelessWidget {
  String Repair_Product_id,
      Repair_Product_Name,
      Repair_Product_Color,
      Repair_Product_Price,
      Repair_Product_Code;
  RepairProductListDetail(
      {super.key,
      required this.Repair_Product_id,
      required this.Repair_Product_Name,
      required this.Repair_Product_Color,
      required this.Repair_Product_Price,
      required this.Repair_Product_Code});
  final RepairProductDetailController repairProductDetailController =
      Get.find<RepairProductDetailController>();
  TextEditingController New_Qty = TextEditingController();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  // TextEditingController Repair_Product_Name = TextEditingController();
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
    List<RepairProductDetailModel> filteredProductDetails() {
      return repairProductDetailController.repair_product_detail
          .where((product_details) =>
              product_details.R_product_id == int.tryParse(Repair_Product_id))
          .toList();
    }

    //  productDetailController.product_detail.clear();
    // productDetailController.isDataFetched = false;
    //  productDetailController.fetchproductdetails(Repair_Product_id);
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Repair Product List Detail',
            style: TextStyle(fontSize: 17),
          ),
          Container(
            decoration: BoxDecoration(
              // color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // IconButton(
                //   color: Colors.blue.shade900,
                //   iconSize: 24.0,
                //   onPressed: () {
                //     // Get.to(() => AddProductDetail(
                //     //       Repair_Product_id: Repair_Product_id,
                //     //       Repair_Product_Name: Repair_Product_Name,
                //     //       Repair_Product_Code: Repair_Product_Code,
                //     //       Product_LPrice: Product_LPrice,
                //     //       Repair_Product_Price: Repair_Product_Price,
                //     //     ));
                //   },
                //   icon: Icon(CupertinoIcons.add),
                // ),
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    repairProductDetailController.isDataFetched = false;
                    repairProductDetailController.fetchproductdetails();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            TextFormField(
              //maxLength: 15,
              initialValue: Repair_Product_Name,
              readOnly: true,
              //controller: Repair_Product_Name,
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
              initialValue: Repair_Product_Code,
              readOnly: true,
              //controller: Repair_Product_Name,
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
            TextFormField(
              //maxLength: 15,
              initialValue: Repair_Product_Color,
              readOnly: true,
              //controller: Repair_Product_Name,
              decoration: InputDecoration(
                //helperText: '*',

                //  hintText: '03123456',
                labelText: "Product Color",
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
                    //   initialValue: Repair_Product_Code,
                    keyboardType: TextInputType.number,
                    initialValue: Repair_Product_Price,
                    decoration: InputDecoration(
                      labelText: "Price ",
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
            Expanded(
              child: Obx(
                () {
                  final List<RepairProductDetailModel> filteredproducts =
                      filteredProductDetails();
                  if (repairProductDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (filteredproducts.isEmpty) {
                    return Center(child: Text('No Quantity Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filteredproducts.length,
                      itemBuilder: (context, index) {
                        final RepairProductDetailModel product =
                            filteredproducts[index];
                        return Container(
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            textColor: Colors.black,
                            //   collapsedBackgroundColor: Colors.white,

                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.Product_Store,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      product.R_product_quantity.toString() +
                                          ' PCS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Bought: ' +
                                      product.R_product_max_quantity.toString(),
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Sold: ' +
                                      product.R_product_sold_quantity
                                          .toString(),
                                  style: TextStyle(fontSize: 13),
                                ),
                                Visibility(
                                  visible: repairProductDetailController
                                      .isadmin(Username.value),
                                  child: IconButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Update Item Quantity'),
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
                                                    Navigator.of(context).pop();
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
                                                                  Colors.white,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
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
                                                      // productDetailController.UpdateProductQty(
                                                      //         product.PD_id
                                                      //             .toString(),
                                                      //         New_Qty.text)
                                                      //     .then((value) => showToast(
                                                      //         productDetailController
                                                      //             .result2))
                                                      //     .then((value) =>
                                                      //         productDetailController
                                                      //                 .isDataFetched =
                                                      //             false)
                                                      //     .then((value) =>
                                                      //         productDetailController
                                                      //             .fetchproductdetails())
                                                      //     .then((value) =>
                                                      //         Navigator.of(context)
                                                      //             .pop())
                                                      //     .then((value) =>
                                                      //         Navigator.of(context).pop());

                                                      // New_Qty.clear();
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

                            //  subtitle: Text(product.Product_Brand),
                            // trailing: OutlinedButton(
                            //   onPressed: () {

                            //     // productController.SelectedPhone.value = product;
                            //     //       // product_detailsController.selectedproduct_details.value =
                            //     //       //     null;

                            //               Get.to(() => RepairProductListDetail(Repair_Product_id: product.Repair_Product_id.toString(), Repair_Product_Name: product.Repair_Product_Name,Repair_Product_Color: product.Repair_Product_Color,));
                            //   },
                            //   child: Text('Select')),
                            // // Add more properties as needed
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
