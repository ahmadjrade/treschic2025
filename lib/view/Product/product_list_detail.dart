// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProductListDetail extends StatelessWidget {
  String Product_id,
      Product_Name,
      Product_Color,
      Product_LPrice,
      Product_MPrice,
      Product_Code;
  ProductListDetail(
      {super.key,
      required this.Product_id,
      required this.Product_Name,
      required this.Product_Color,
      required this.Product_LPrice,
      required this.Product_MPrice,
      required this.Product_Code});
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  TextEditingController New_Qty = TextEditingController();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
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
    List<ProductDetailModel> filteredProductDetails() {
      return productDetailController.product_detail
          .where((product_details) =>
              product_details.Product_id == int.tryParse(Product_id))
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
          IconButton(
            color: Colors.deepPurple,
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
            color: Colors.deepPurple,
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
            TextFormField(
              //maxLength: 15,
              initialValue: Product_Color,
              readOnly: true,
              //controller: Product_Name,
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
            Expanded(
              child: Obx(
                () {
                  final List<ProductDetailModel> filteredproducts =
                      filteredProductDetails();
                  if (productDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (filteredproducts.isEmpty) {
                    return Center(child: Text('No Quantity Yet ! Add Some'));
                  } else {
                    return ListView.builder(
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
                                    Text(
                                      product.Product_Store + ' Store',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
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
                                                      productDetailController
                                                              .UpdateProductQty(
                                                                  product.PD_id
                                                                      .toString(),
                                                                  New_Qty.text)
                                                          .then((value) =>
                                                              showToast(
                                                                  productDetailController
                                                                      .result2))
                                                          .then((value) =>
                                                              productDetailController
                                                                      .isDataFetched =
                                                                  false)
                                                          .then((value) =>
                                                              productDetailController
                                                                  .fetchproductdetails())
                                                          .then((value) =>
                                                              Navigator.of(context).pop())
                                                          .then((value) => Navigator.of(context).pop());

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
                          // collapsedTextColor: Colors.black,
                          // textColor: Colors.black,
                          // backgroundColor: Colors.deepPurple.shade100,
                          //   collapsedBackgroundColor: Colors.white,
                          // trailing:
                          // title:

                          //  subtitle: Text(product.Product_Brand),
                          // trailing: OutlinedButton(
                          //   onPressed: () {

                          //     // productController.SelectedPhone.value = product;
                          //     //       // product_detailsController.selectedproduct_details.value =
                          //     //       //     null;

                          //               Get.to(() => ProductListDetail(Product_id: product.Product_id.toString(), Product_Name: product.Product_Name,Product_Color: product.Product_Color,));
                          //   },
                          //   child: Text('Select')),
                          // // Add more properties as needed
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
