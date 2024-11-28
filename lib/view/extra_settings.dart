// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_line/dotted_line.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Brands/add_brand.dart';
import 'package:fixnshop_admin/view/Category/add_category.dart';
import 'package:fixnshop_admin/view/Category/category_list.dart';
import 'package:fixnshop_admin/view/Colors/add_color.dart';
import 'package:fixnshop_admin/view/Customers/add_customer.dart';
import 'package:fixnshop_admin/view/Customers/customer_list.dart';
import 'package:fixnshop_admin/view/Drivers/add_driver.dart';
import 'package:fixnshop_admin/view/Expenses/expense_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_due.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_payment.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Invoices/new_invoice.dart';
import 'package:fixnshop_admin/view/Phones/add_phone_model.dart';
import 'package:fixnshop_admin/view/Phones/buy_phone.dart';
import 'package:fixnshop_admin/view/Phones/customer_list_fphones.dart';
import 'package:fixnshop_admin/view/Phones/phones_list.dart';
import 'package:fixnshop_admin/view/Phones/supplier_list_fphones.dart';
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_due.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/customer_list_frecharge.dart';
import 'package:fixnshop_admin/view/Recharge/rech_invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_balances.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_due.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_manage.dart';
import 'package:fixnshop_admin/view/Repairs/buy_repair_product.dart';
import 'package:fixnshop_admin/view/Repairs/repair_manage.dart';
import 'package:fixnshop_admin/view/Repairs/repair_product_list.dart';
import 'package:fixnshop_admin/view/Suppliers/add_supplier.dart';
import 'package:fixnshop_admin/view/Suppliers/supplier_list.dart';
import 'package:fixnshop_admin/view/Transfer/stores_list_ftransfer.dart';
import 'package:fixnshop_admin/view/Transfer/transfer_history.dart';
import 'package:fixnshop_admin/view/Transfer/transfer_history_manage.dart';
import 'package:fixnshop_admin/view/Expenses/buy_expenses.dart';
import 'package:fixnshop_admin/view/Recharge/new_recharge_invoice.dart';
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
                    Text('Phones ',
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
                    Get.to(() => SupplierListFPhone());
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
                            'Supplier Purchase',
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
                    Get.to(() => CustomerListFPhones());
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
                            'Customer Purchase',
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
                    Get.to(() => PhonesList(
                          isTransfer: false,
                        ));
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
                            'Phones List',
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
                    Get.to(() => PhoneModelAdd());
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
                            'Phone Models',
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text('Repair Products ',
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
                    Get.to(() => BuyRepairProduct());
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
                            'New Repair Product',
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
                    Get.to(() => RepairProductList(
                          isPur: 1,
                          isCreated: 0,
                        ));
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
                            'Repair Products',
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
                    Get.to(() => RepairManage());
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
                            'Repairs Management',
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
          ),
        ),
      ),
    );
  }
}
