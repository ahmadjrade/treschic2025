// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/driver_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/driver_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Drivers/add_driver.dart';
import 'package:fixnshop_admin/view/Drivers/customer_list_delivery.dart';
import 'package:fixnshop_admin/view/Invoices/new_invoice.dart';
import 'package:fixnshop_admin/view/Purchase/new_purchase.dart';
import 'package:fixnshop_admin/view/Product/product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

class DriversList  extends StatelessWidget {
  DriversList ({super.key});
  final DriverController driverController = Get.find<DriverController>();

  TextEditingController Driver_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Driver List'),
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
                  Get.to(AddDriver());
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.add),
                         ),IconButton(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: Driver_Name,
              keyboardType: TextInputType.number,
              onChanged: (query) {
                driverController.drivers.refresh();
              },
              decoration: InputDecoration(
                labelText: 'Search by Name / Number',
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
                final List<DriverModel> filteredDrivers =
                    driverController.searchDrivers(Driver_Name.text);
                if (driverController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: filteredDrivers.length,
                    itemBuilder: (context, index) {
                      final DriverModel Driver = filteredDrivers[index];
                      return Container(
                        //  width: double.infinity,
                        //   height: 150.0,
                        color: Colors.grey.shade200,
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        //     padding: EdgeInsets.all(35),
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.perm_contact_cal,
                                color: Colors.blue.shade900,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Driver.Driver_Name.toUpperCase()
                                // +
                                // ' -- ' +
                                // Driver.Product_Code,
                                ,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.green.shade900,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    Driver.Driver_Number
                                    // +
                                    // ' -- ' +
                                    // Driver.Product_Code,
                                    ,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: OutlinedButton(
                              onPressed: () {
                                // productController.SelectedPhone.value = product;
                                //       // subcategoryController.selectedSubCategory.value =
                                // //       //     null;

                                Get.to(() => CustomerListFDelivery(
                                      Driver_id: Driver.Driver_id.toString(),
                                      Driver_Name: Driver.Driver_Name,
                                      Driver_Number: Driver.Driver_Number,
                                    ));
                              },
                              child: Icon(
                                Icons.arrow_right,
                                color: Colors.blue.shade900,
                              )),
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
    );
  }
}
