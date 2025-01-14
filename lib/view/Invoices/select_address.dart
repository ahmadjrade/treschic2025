import 'dart:ffi';

import 'package:treschic/controller/customer_address_controller.dart';
import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/model/customer_address_model.dart';
import 'package:treschic/view/Customers/customer_edit.dart';
import 'package:treschic/view/Invoices/new_invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectAddress extends StatelessWidget {
  String Cus_id,
      Cus_Name,
      Cus_Number,
      Cus_Due,
      Driver_id,
      Driver_Name,
      Driver_Number,
      isDel;

  SelectAddress(
      {super.key,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number,
      required this.Cus_Due,
      required this.Driver_id,
      required this.Driver_Name,
      required this.Driver_Number,
      required this.isDel});
  final CustomerController customerController = Get.find<CustomerController>();
  final CustomerAddressController customerAddressController =
      Get.find<CustomerAddressController>();

  @override
  Widget build(BuildContext context) {
    if (customerAddressController.address.isEmpty) {
      customerAddressController.fetch_addresses();
      // print(Cus_id);
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    List<CustomerAddressModel> filteredProductDetails() {
      return customerAddressController.address
          .where((address) => address.Cus_id.toString() == (Cus_id))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select Address'),
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
                      Get.to(CustomerEdit(
                          Cus_id: Cus_id,
                          Cus_Name: Cus_Name,
                          Cus_Number: Cus_Number));
                      // categoryController.isDataFetched =false;
                      // categoryController.fetchcategories();
                    },
                    icon: Icon(CupertinoIcons.add),
                  ),
                  IconButton(
                    color: Colors.blue.shade900,
                    iconSize: 24.0,
                    onPressed: () {
                      customerAddressController.isDataFetched = false;
                      customerAddressController.fetch_addresses();
                      // categoryController.isDataFetched =false;
                      // categoryController.fetchcategories();
                    },
                    icon: Icon(CupertinoIcons.refresh),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  final List<CustomerAddressModel> filteredAddress =
                      filteredProductDetails();
                  if (customerAddressController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (filteredAddress.isEmpty) {
                    return Center(child: Text('No Address Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredAddress.length,
                      itemBuilder: (context, index) {
                        final CustomerAddressModel address =
                            filteredAddress[index];
                        return Container(
                          //color: Colors.grey.shade200,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          //     padding: EdgeInsets.all(35),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //   color: Colors.grey.shade500,
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                // collapsedTextColor: Colors.black,
                                // textColor: Colors.black,
                                // backgroundColor: Colors.blue.shade900.shade100,
                                //   collapsedBackgroundColor: Colors.white,

                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Address: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Expanded(
                                          child: Text(
                                            address.Address,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Date Addedd: ' + address.Date_added,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                    OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                          //fixedSize: Size(200, 20),
                                          backgroundColor:
                                              Colors.green.shade100,
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
                                          // Get.to(() => SelectAddress(
                                          //     Cus_id: customer.Cus_id
                                          //         .toString(),
                                          //     Cus_Name:
                                          //         customer.Cus_Name,
                                          //     Cus_Number:
                                          //         customer.Cus_Number,
                                          //     Cus_Due:
                                          //         customer.Cus_Due_USD
                                          //             .toString(),
                                          //     isDel: '1',
                                          //     Driver_id: Driver_id,
                                          //     Driver_Name:
                                          //         Driver_Name,
                                          //     Driver_Number:
                                          //         Driver_Number));
                                          Get.to(() => NewInvoice(
                                              Cus_id: Cus_id,
                                              Cus_Name: Cus_Name,
                                              Cus_Number: Cus_Number,
                                              Cus_Due: Cus_Due.toString(),
                                              isDel: '1',
                                              Driver_id: Driver_id,
                                              Driver_Name: Driver_Name,
                                              Driver_Number: Driver_Number,
                                              Address: address.Address));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Select',
                                              style: TextStyle(
                                                  color: Colors.green.shade900),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_circle_right_rounded,
                                              color: Colors.green.shade900,
                                              size: 15,
                                              //  'Details',
                                              //   style: TextStyle(
                                              //        color: Colors.red),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
