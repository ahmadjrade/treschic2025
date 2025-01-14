// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/controller/driver_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/model/customer_model.dart';
import 'package:treschic/model/driver_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/view/Drivers/add_driver.dart';
import 'package:treschic/view/Drivers/customer_list_delivery.dart';
import 'package:treschic/view/Invoices/new_invoice.dart';
import 'package:treschic/view/Purchase/new_purchase.dart';
import 'package:treschic/view/Product/product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

class DriversList extends StatelessWidget {
  DriversList({super.key});
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
          Text(
            'Drivers List',
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
              //   color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    Get.to(AddDriver());
                    // categoryController.isDataFetched =false;
                    // categoryController.fetchcategories();
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
                IconButton(
                  color: Colors.blue.shade900,
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
          ),
        ],
      )),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
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
                        driverController.drivers.refresh();
                      },
                      controller: Driver_Name,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Driver_Name.clear();
                            driverController.drivers.refresh();
                          },
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: 'Search By Name or Number',
                      ),
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          decoration: BoxDecoration(
                            //  color: Colors.green.shade100,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.delivery_dining_sharp),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        Driver.Driver_Name.toUpperCase() +
                                            ' | ' +
                                            Driver.Driver_Number
                                        // +
                                        // ' -- ' +
                                        // Driver.Product_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        //fixedSize: Size(200, 20),
                                        backgroundColor: Colors.blue.shade100,
                                        side: BorderSide(
                                          width: 2.0,
                                          color: Colors.blue.shade900,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        // productController.SelectedPhone.value = product;
                                        //       // subcategoryController.selectedSubCategory.value =
                                        // //       //     null;

                                        Get.to(() => CustomerListFDelivery(
                                              Driver_id:
                                                  Driver.Driver_id.toString(),
                                              Driver_Name: Driver.Driver_Name,
                                              Driver_Number:
                                                  Driver.Driver_Number,
                                            ));
                                      },
                                      child: Text(
                                        'Select',
                                        style: TextStyle(
                                            color: Colors.blue.shade900),
                                        // color: Colors.blue.shade900,
                                      )),
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
    );
  }
}
