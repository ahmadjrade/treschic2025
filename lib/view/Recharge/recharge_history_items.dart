// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/recharge_detail_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/invoice_history_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/recharge_inv_history_model.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RechargeHistoryItems extends StatelessWidget {
  String Recharge_id,
      Customer_Name,
      Customer_Number,
      Invoice_Total_US,
      Invoice_Rec_US,
      Invoice_Due_US;
  RechargeHistoryItems(
      {super.key,
      required this.Recharge_id,
      required this.Customer_Name,
      required this.Customer_Number,
      required this.Invoice_Total_US,
      required this.Invoice_Rec_US,
      required this.Invoice_Due_US});

  final RechargeDetailController rechargeDetailController =
      Get.find<RechargeDetailController>();
  TextEditingController New_Qty = TextEditingController();
  final RxString filter = ''.obs;
  final TextEditingController filterController = TextEditingController();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  // TextEditingController Customer_Name = TextEditingController();
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    // rechargeDetailController.isDataFetched = false;
    // rechargeDetailController.fetchproductdetails();
    List<RechargeHistoryModel> filteredProductDetails() {
      final filterText = filter.value.toLowerCase();

      return rechargeDetailController.recharge_detail
          .where((invoice_detail) =>
              invoice_detail.Recharge_invoice_id == int.tryParse(Recharge_id) &&
              (invoice_detail.Card_Name.toLowerCase().contains(filterText)))
          .toList();
    }

    //  rechargeDetailController.product_detail.clear();
    // rechargeDetailController.isDataFetched = false;
    //  rechargeDetailController.fetchproductdetails(Recharge_id);
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Invoice #$Recharge_id Items',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                color: Colors.blue.shade900,
                iconSize: 24.0,
                onPressed: () {
                  // Get.to(() => AddProductDetail(
                  //       Recharge_id: Recharge_id,
                  //       Customer_Name: Customer_Name,
                  //       Invoice_Due_US: Invoice_Due_US,
                  //       Invoice_Total_US: Invoice_Total_US,
                  //       Invoice_Rec_US: Invoice_Rec_US,
                  //     ));
                },
                icon: Icon(CupertinoIcons.add),
              ),
              IconButton(
                color: Colors.blue.shade900,
                iconSize: 24.0,
                onPressed: () {
                  rechargeDetailController.isDataFetched = false;
                  rechargeDetailController.fetchrecdetails();
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.refresh),
              ),
            ],
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
              initialValue: Customer_Name + ' || ' + Customer_Number,
              readOnly: true,
              //controller: Customer_Name,
              decoration: InputDecoration(
                //helperText: '*',

                //  hintText: '03123456',
                labelText: "Customer",
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    //maxLength: 15,
                    initialValue: Invoice_Total_US + '\$',
                    readOnly: true,
                    //controller: Customer_Name,
                    decoration: InputDecoration(
                      //helperText: '*',

                      //  hintText: '03123456',
                      labelText: "Total",
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
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    //maxLength: 15,
                    initialValue: Invoice_Rec_US + '\$',
                    readOnly: true,
                    //controller: Customer_Name,
                    decoration: InputDecoration(
                      //helperText: '*',

                      //  hintText: '03123456',
                      labelText: "Received",
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
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    //maxLength: 15,
                    initialValue: Invoice_Due_US + '\$',
                    readOnly: true,
                    //controller: Customer_Name,
                    decoration: InputDecoration(
                      //helperText: '*',

                      //  hintText: '03123456',
                      labelText: "Due",
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
                labelText: "Filter by Name or Code",
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
            Expanded(
              child: Obx(
                () {
                  final List<RechargeHistoryModel> filtereditems =
                      filteredProductDetails();
                  if (rechargeDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (rechargeDetailController.recharge_detail.isEmpty) {
                    return Center(child: Text('No Items Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filtereditems.length,
                      itemBuilder: (context, index) {
                        final RechargeHistoryModel invoice =
                            filtereditems[index];
                        return Container(
                          decoration: BoxDecoration(
                            //   color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: ListTile(
                            // margin: EdgeInsets.all(5),
                            //   collapsedBackgroundColor: Colors.white,
                            title: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '#' +
                                                invoice.Rinvoice_detail_id
                                                    .toString() +
                                                ' || ' +
                                                invoice.Card_Name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            'Card Ammount: ' +
                                                addCommasToNumber(
                                                        invoice.Card_Amount)
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            invoice.Card_Qty.toString() +
                                                ' PCS',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                          ),
                                          Text(
                                            'UP: ' +
                                                addCommasToNumber(
                                                        invoice.Card_UP)
                                                    .toString() +
                                                'LL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Colors.green.shade900),
                                          ),
                                          Text(
                                            'TP: ' +
                                                addCommasToNumber(
                                                        invoice.Card_TP)
                                                    .toString() +
                                                'LL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Colors.green.shade900),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: rechargeDetailController
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
                                                      }
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
