// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_line/dotted_line.dart';
import 'package:treschic/controller/homescreen_manage_controller.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:treschic/view/Brands/add_brand.dart';
import 'package:treschic/view/Category/add_category.dart';
import 'package:treschic/view/Category/category_list.dart';
import 'package:treschic/view/Colors/add_color.dart';
import 'package:treschic/view/Customers/add_customer.dart';
import 'package:treschic/view/Customers/customer_list.dart';
import 'package:treschic/view/Drivers/add_driver.dart';
import 'package:treschic/view/Expenses/expense_manage.dart';
import 'package:treschic/view/Invoices/invoice_due.dart';
import 'package:treschic/view/Invoices/invoice_history.dart';
import 'package:treschic/view/Invoices/invoice_history_manage.dart';
import 'package:treschic/view/Invoices/invoice_payment.dart';
import 'package:treschic/view/Invoices/invoice_payment_manage.dart';
import 'package:treschic/view/Invoices/new_invoice.dart';

import 'package:treschic/view/Product/product_list.dart';
import 'package:treschic/view/Purchase/purchase_due.dart';
import 'package:treschic/view/Purchase/purchase_payment_manage.dart';
import 'package:treschic/view/Sizes/add_size.dart';

import 'package:treschic/view/Suppliers/add_supplier.dart';
import 'package:treschic/view/Suppliers/supplier_list.dart';
import 'package:treschic/view/Transfer/stores_list_ftransfer.dart';
import 'package:treschic/view/Transfer/transfer_history.dart';
import 'package:treschic/view/Transfer/transfer_history_manage.dart';
import 'package:treschic/view/Expenses/buy_expenses.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ExtraSettings extends StatelessWidget {
  ExtraSettings({super.key});
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenWidth = mediaQuery.size.width;
    var screenHeight = mediaQuery.size.height;
    var padding = mediaQuery.padding;
    var safeWidth = screenWidth - padding.horizontal;
    var safeHeight = screenHeight - padding.vertical;
    return Scaffold(
      appBar: AppBar(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Extra Settings'),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black,
          ),
        ],
      )),
      // /  backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          homeController.selectedPageIndex.value = 0;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text('Variables ',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddBrand());
                      },
                      child: Row(
                        children: [
                          Card(
                            // margin: ,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.history),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Brands',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // OutlinedButton(onPressed: () {}, child: Text('Select'))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddCategory());
                      },
                      child: Card(
                        // margin: ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Categories',
                                style: TextStyle(fontSize: 15),
                              ),
                              // OutlinedButton(onPressed: () {}, child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddColor());
                      },
                      child: Card(
                        // margin: ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Colors',
                                style: TextStyle(fontSize: 15),
                              ),
                              // OutlinedButton(onPressed: () {}, child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddCustomer());
                      },
                      child: Card(
                        // margin: ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Customers',
                                style: TextStyle(fontSize: 15),
                              ),
                              // OutlinedButton(onPressed: () {}, child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddSupplier());
                      },
                      child: Card(
                        // margin: ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Suppliers',
                                style: TextStyle(fontSize: 15),
                              ),
                              // OutlinedButton(onPressed: () {}, child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddDriver());
                      },
                      child: Card(
                        // margin: ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Drivers',
                                style: TextStyle(fontSize: 15),
                              ),
                              // OutlinedButton(onPressed: () {}, child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AddSize());
                      },
                      child: Card(
                        // margin: ,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.history),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Sizes',
                                style: TextStyle(fontSize: 15),
                              ),
                              // OutlinedButton(onPressed: () {}, child: Text('Select'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 2.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGradient: [Colors.black, Colors.black],
                  dashRadius: 1.0,
                  dashGapLength: 1.0,
                  dashGapColor: Colors.transparent,
                  dashGapGradient: [Colors.white, Colors.white],
                  dashGapRadius: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text('Products ',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => BuyAccessories());
                  },
                  child: Card(
                    // margin: ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'New Product',
                            style: TextStyle(fontSize: 15),
                          ),
                          // OutlinedButton(onPressed: () {}, child: Text('Select'))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => CategoryList());
                  },
                  child: Card(
                    // margin: ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Product By Category',
                            style: TextStyle(fontSize: 15),
                          ),
                          // OutlinedButton(onPressed: () {}, child: Text('Select'))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => SupplierList());
                  },
                  child: Card(
                    // margin: ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Product Purchase ',
                            style: TextStyle(fontSize: 15),
                          ),
                          // OutlinedButton(onPressed: () {}, child: Text('Select'))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 2.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGradient: [Colors.black, Colors.black],
                  dashRadius: 1.0,
                  dashGapLength: 1.0,
                  dashGapColor: Colors.transparent,
                  dashGapGradient: [Colors.white, Colors.white],
                  dashGapRadius: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 2.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGradient: [Colors.black, Colors.black],
                  dashRadius: 1.0,
                  dashGapLength: 1.0,
                  dashGapColor: Colors.transparent,
                  dashGapGradient: [Colors.white, Colors.white],
                  dashGapRadius: 1.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text('Transfer Products ',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => StoresListFTransfer());
                  },
                  child: Card(
                    // margin: ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'New Transfer',
                            style: TextStyle(fontSize: 15),
                          ),
                          // OutlinedButton(onPressed: () {}, child: Text('Select'))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => TransferHistoryManage());
                  },
                  child: Card(
                    // margin: ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.history),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Transfer History',
                            style: TextStyle(fontSize: 15),
                          ),
                          // OutlinedButton(onPressed: () {}, child: Text('Select'))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 2.0,
                  dashLength: 4.0,
                  dashColor: Colors.black,
                  dashGradient: [Colors.black, Colors.black],
                  dashRadius: 1.0,
                  dashGapLength: 1.0,
                  dashGapColor: Colors.transparent,
                  dashGapGradient: [Colors.white, Colors.white],
                  dashGapRadius: 1.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
