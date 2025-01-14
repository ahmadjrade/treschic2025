// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/supplier_controller.dart';
import 'package:treschic/model/customer_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/model/supplier_model.dart';
import 'package:treschic/view/Invoices/new_invoice.dart';
import 'package:treschic/view/Purchase/new_purchase.dart';
import 'package:treschic/view/Product/product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SupplierList extends StatelessWidget {
  SupplierList({super.key});
  final SupplierController supplierController = Get.find<SupplierController>();

  TextEditingController Supplier_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Supplier List'),
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
              //color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    Get.toNamed('/NewSupplier');
                    // categoryController.isDataFetched =false;
                    // categoryController.fetchcategories();
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
                IconButton(
                  color: Colors.blue.shade900,
                  iconSize: 24.0,
                  onPressed: () {
                    supplierController.isDataFetched = false;
                    supplierController.fetchsuppliers();
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.grey.shade500,
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    //obscureText: true,
                    //  readOnly: isLoading,
                    controller: Supplier_Name,
                    onChanged: (query) {
                      supplierController.suppliers.refresh();
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Supplier_Name.clear();
                          supplierController.suppliers.refresh();
                        },
                      ),
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
                  final List<SupplierModel> filteredsuppliers =
                      supplierController.searchProducts(Supplier_Name.text);
                  if (supplierController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: filteredsuppliers.length,
                      itemBuilder: (context, index) {
                        final SupplierModel supplier = filteredsuppliers[index];
                        return Container(
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          alignment: Alignment.center,
                          child: ListTile(
                            title: Column(
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
                                              supplier.Supplier_Name
                                                      .toUpperCase() +
                                                  ' | ' +
                                                  supplier.Supplier_Number
                                              // +
                                              // ' -- ' +
                                              // customer.Product_Code,
                                              ,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
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
                                                    Colors.green.shade100,
                                                side: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.green.shade900,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                Get.to(() => New_Purchase(
                                                      Supp_id:
                                                          supplier.Supplier_id
                                                              .toString(),
                                                      Supp_Name: supplier
                                                          .Supplier_Name,
                                                      Supp_Number: supplier
                                                          .Supplier_Number,
                                                    ));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Select',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green.shade900),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_circle_right_rounded,
                                                    color:
                                                        Colors.green.shade900,
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
