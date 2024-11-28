// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Customers/customer_edit.dart';
import 'package:fixnshop_admin/view/Invoices/new_invoice.dart';
import 'package:fixnshop_admin/view/Invoices/select_address.dart';
import 'package:fixnshop_admin/view/Phones/buy_phone.dart';
import 'package:fixnshop_admin/view/Product/product_list_detail.dart';
import 'package:fixnshop_admin/view/Repairs/insert_repair.dart';
import 'package:fixnshop_admin/view/home_screen.dart';
import 'package:fixnshop_admin/view/home_screen_manage.dart';
import 'package:fixnshop_admin/view/Recharge/new_recharge_invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerListFDelivery extends StatelessWidget {
  String Driver_id, Driver_Name, Driver_Number;
  CustomerListFDelivery(
      {super.key,
      required this.Driver_id,
      required this.Driver_Name,
      required this.Driver_Number});
  final CustomerController customerController = Get.find<CustomerController>();
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  final HomeController homeController = Get.find<HomeController>();

  TextEditingController Customer_Number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // productController.fetchproducts();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customers List | Delivery',
                style: TextStyle(fontSize: 17),
              ),
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
                        Get.toNamed('/NewCustomer');
                        // categoryController.isDataFetched =false;
                        // categoryController.fetchcategories();
                      },
                      icon: Icon(CupertinoIcons.add),
                    ),
                    IconButton(
                      color: Colors.blue.shade900,
                      iconSize: 24.0,
                      onPressed: () {
                        customerController.isDataFetched = false;
                        customerController.fetchcustomers();
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
      body: PopScope(
        canPop: true,
        onPopInvoked: (result) {
          homeController.selectedPageIndex.value = 0;

          //  Navigator.of(context).pop();
          barcodeController.barcode3.value = '';
        },
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade500,
                    border: Border.all(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      //obscureText: true,
                      //  readOnly: isLoading,
                      controller: Customer_Number,
                      onChanged: (query) {
                        customerController.customers.refresh();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: 'Search By Name or Number',
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Obx(
                  () {
                    final List<CustomerModel> filteredCustomers =
                        customerController.searchProducts(Customer_Number.text);
                    if (customerController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final CustomerModel customer =
                              filteredCustomers[index];
                          return Container(
                            decoration: BoxDecoration(
                              // color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            alignment: Alignment.center,
                            child: ListTile(
                              // margin: EdgeInsets.all(5),
                              title: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  customer.Cus_Name
                                                          .toUpperCase() +
                                                      ' | ' +
                                                      customer.Cus_Number
                                                  // +
                                                  // ' -- ' +
                                                  // customer.Product_Code,
                                                  ,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Due: ' +
                                                  addCommasToNumber(
                                                          customer.Cus_Due_USD)
                                                      .toString() +
                                                  '\$'
                                              // +
                                              // ' -- ' +
                                              // customer.Product_Code,
                                              ,
                                              style: TextStyle(
                                                  color: Colors.red.shade900,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    //fixedSize: Size(200, 20),
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
                                                    Get.to(() => CustomerEdit(
                                                          Cus_id:
                                                              customer.Cus_id
                                                                  .toString(),
                                                          Cus_Name:
                                                              customer.Cus_Name,
                                                          Cus_Number: customer
                                                              .Cus_Number,
                                                        ));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue.shade900),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors
                                                            .blue.shade900,
                                                        size: 15,
                                                        //  'Details',
                                                        //   style: TextStyle(
                                                        //        color: Colors.red),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    //fixedSize: Size(200, 20),
                                                    backgroundColor:
                                                        Colors.green.shade100,
                                                    side: BorderSide(
                                                      width: 2.0,
                                                      color:
                                                          Colors.green.shade900,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(() => SelectAddress(
                                                        Cus_id: customer.Cus_id
                                                            .toString(),
                                                        Cus_Name:
                                                            customer.Cus_Name,
                                                        Cus_Number:
                                                            customer.Cus_Number,
                                                        Cus_Due:
                                                            customer.Cus_Due_USD
                                                                .toString(),
                                                        isDel: '1',
                                                        Driver_id: Driver_id,
                                                        Driver_Name:
                                                            Driver_Name,
                                                        Driver_Number:
                                                            Driver_Number));
                                                    //      Get.to(() => NewInvoice(
                                                    // Cus_id: customer.Cus_id
                                                    //     .toString(),
                                                    // Cus_Name:
                                                    //     customer.Cus_Name,
                                                    // Cus_Number:
                                                    //     customer.Cus_Number,
                                                    // Cus_Due:
                                                    //     customer.Cus_Due_USD
                                                    //         .toString(),
                                                    // isDel: '1',
                                                    // Driver_id: Driver_id,
                                                    // Driver_Name:
                                                    //     Driver_Name,
                                                    // Driver_Number:
                                                    //     Driver_Number));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Select',
                                                        style: TextStyle(
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_circle_right_rounded,
                                                        color: Colors
                                                            .green.shade900,
                                                        size: 15,
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
