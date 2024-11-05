// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/driver_controller.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/driver_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_by_driver.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_by_customer.dart';
import 'package:fixnshop_admin/view/Invoices/new_invoice.dart';
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

class DriverListFInvHistory extends StatelessWidget {
  DriverListFInvHistory({super.key});
  final DriverController driverController = Get.find<DriverController>();
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  final HomeController homeController = Get.find<HomeController>();

  TextEditingController Driver_Name = TextEditingController();
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
                'drivers List | Invoices',
                style: TextStyle(fontSize: 17),
              ),
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
                      Get.toNamed('/NewCustomer');
                      // categoryController.isDataFetched =false;
                      // categoryController.fetchcategories();
                    },
                    icon: Icon(CupertinoIcons.add),
                  ),
                  IconButton(
                    color: Colors.deepPurple,
                    iconSize: 24.0,
                    onPressed: () {
                      driverController.isDataFetched = false;
                      driverController.fetch_drivers();
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
          homeController.selectedPageIndex.value = 0;

          //  Navigator.of(context).pop();
          barcodeController.barcode3.value = '';
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: Driver_Name,
                keyboardType: TextInputType.text,
                onChanged: (query) {
                  driverController.drivers.refresh();
                },
                decoration: InputDecoration(
                  labelText: 'Search by Name | Number',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(
                () {
                  final List<DriverModel> filteredDriver =
                      driverController.searchDrivers(Driver_Name.text);
                  if (driverController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: filteredDriver.length,
                      itemBuilder: (context, index) {
                        final DriverModel driver = filteredDriver[index];
                        return Container(
                          //  width: double.infinity,
                          //   height: 150.0,
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          //     padding: EdgeInsets.all(35),
                          alignment: Alignment.center,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.perm_contact_cal,
                                                color: Colors.blue.shade900,
                                                size: 13,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                driver.Driver_Name
                                                        .toUpperCase() +
                                                    ' || '
                                                // +
                                                // ' -- ' +
                                                // driver.Product_Code,
                                                ,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                driver.Driver_Number
                                                // +
                                                // ' -- ' +
                                                // driver.Product_Code,
                                                ,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.attach_money,
                                            color: Colors.red.shade900,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Due US: ' +
                                                addCommasToNumber(
                                                        driver.Driver_Due_usd)
                                                    .toString() +
                                                '\$'
                                            // +
                                            // ' -- ' +
                                            // driver.Product_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                //Text(driver.Cus_Due_USD.toString()),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: ElevatedButton.styleFrom(
                                            //fixedSize: Size(200, 20),
                                            backgroundColor:
                                                Colors.blue.shade100,
                                            side: BorderSide(
                                              width: 2.0,
                                              color: Colors.blue.shade100,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Get.to(() => CustomerEdit(
                                            //       Cus_id: driver.Cus_id
                                            //           .toString(),
                                            //       Driver_Number: driver.Driver_Number,
                                            //       Cus_Number:
                                            //           driver.Cus_Number,
                                            //     ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue.shade900),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.edit,
                                                color: Colors.blue.shade900,
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
                                          style: ElevatedButton.styleFrom(
                                            //fixedSize: Size(200, 20),
                                            backgroundColor:
                                                Colors.green.shade100,
                                            side: BorderSide(
                                              width: 2.0,
                                              color: Colors.green.shade100,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.to(() => InvoiceHistoryByDriver(
                                                  Driver_id: driver.Driver_id
                                                      .toString(),
                                                  Driver_Number:
                                                      driver.Driver_Number,
                                                  Driver_Name:
                                                      driver.Driver_Name,
                                                ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Select',
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade900),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_circle_right_rounded,
                                                color: Colors.green.shade900,
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
