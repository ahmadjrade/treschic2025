// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/category_controller.dart';
import '../controller/supplier_controller.dart';
import '../model/category_model.dart';
import '../model/supplier_model.dart';

class BuyTools extends StatelessWidget {
  BuyTools({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();
  final SupplierController supplierController = Get.find<SupplierController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Buy Tools'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                categoryController.isDataFetched = false;
                categoryController.fetchcategories();
                supplierController.isDataFetched = false;
                supplierController.fetchsuppliers();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Obx(
                    () => categoryController.category.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                // Text('Fetching Rate! Please Wait'),
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<CategoryModel>(
                            decoration: InputDecoration(
                              labelText: "Categories",
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
                            iconDisabledColor: Colors.deepPurple.shade300,
                            iconEnabledColor: Colors.deepPurple.shade300,
                            //  value: categoryController.category.first,
                            onChanged: (CategoryModel? value) {},
                            items: categoryController.category
                                .map((color) => DropdownMenuItem<CategoryModel>(
                                      value: color,
                                      child: Text(color.Cat_Name),
                                    ))
                                .toList(),
                          ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Tool Name ",
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
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              keyboardType: TextInputType.number,
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Quantity ",
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
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Obx(
                    () => categoryController.category.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                // Text('Fetching Rate! Please Wait'),
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<SupplierModel>(
                            decoration: InputDecoration(
                              labelText: "Supplier",
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
                            iconDisabledColor: Colors.deepPurple.shade300,
                            iconEnabledColor: Colors.deepPurple.shade300,
                            //   value: supplierController.suppliers.first,
                            onChanged: (SupplierModel? value) {},
                            items: supplierController.suppliers
                                .map((supplier) =>
                                    DropdownMenuItem<SupplierModel>(
                                      value: supplier,
                                      child: Text(supplier.Supplier_Name),
                                    ))
                                .toList(),
                          ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    //controller: Product_Name,
                    decoration: InputDecoration(
                      labelText: "Product Code ",
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
                  width: 25,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Icon(
                    Icons.qr_code_scanner_sharp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    //controller: Product_Name,
                    decoration: InputDecoration(
                      labelText: "Price",
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

                //Checkbox(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
