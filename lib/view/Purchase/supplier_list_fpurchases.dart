// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/supplier_controller.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/supplier_model.dart';
import 'package:fixnshop_admin/view/Invoices/new_invoice.dart';
import 'package:fixnshop_admin/view/Phones/bulk_phone_purchase.dart';
import 'package:fixnshop_admin/view/Purchase/new_purchase.dart';
import 'package:fixnshop_admin/view/Product/product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class supplierListFPurchases extends StatelessWidget {
  supplierListFPurchases({super.key});
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
                  Get.toNamed('/NewSupplier');
                  // categoryController.isDataFetched =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.add),
                         ),IconButton(
            color: Colors.deepPurple,
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
          
        ],
      )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: Supplier_Name,
              keyboardType: TextInputType.number,
              onChanged: (query) {
                supplierController.suppliers.refresh();
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
                                supplier.Supplier_Name.toUpperCase()
                                // +
                                // ' -- ' +
                                // supplier.Product_Code,
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
                                    supplier.Supplier_Number
                                    // +
                                    // ' -- ' +
                                    // supplier.Product_Code,
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

                                Get.to(() => BulkPhonePurchase(
                                      Supp_id: supplier.Supplier_id.toString(),
                                      Supp_Name: supplier.Supplier_Name,
                                      Supp_Number: supplier.Supplier_Number,
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
