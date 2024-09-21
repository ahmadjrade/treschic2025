// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Brands/add_brand.dart';
import 'package:fixnshop_admin/view/Category/add_category.dart';
import 'package:fixnshop_admin/view/Category/category_list.dart';
import 'package:fixnshop_admin/view/Colors/add_color.dart';
import 'package:fixnshop_admin/view/Customers/add_customer.dart';
import 'package:fixnshop_admin/view/Customers/customer_list.dart';
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
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_due.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/customer_list_frecharge.dart';
import 'package:fixnshop_admin/view/Recharge/rech_invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_balances.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_due.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_manage.dart';
import 'package:fixnshop_admin/view/Suppliers/add_supplier.dart';
import 'package:fixnshop_admin/view/Suppliers/supplier_list.dart';
import 'package:fixnshop_admin/view/buy_expenses.dart';
import 'package:fixnshop_admin/view/Recharge/new_recharge_invoice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class StocksScreen extends StatelessWidget {
  StocksScreen({super.key});
  final HomeController homeController = Get.find<HomeController>();

  static const List Variables = [
    'Customers',
    'Brands',
    'New/Used Phone',
    'Accessories',
    'Tools',
    'Expenses',
    'Suppliers',
    'Categories',
    'Phone Model',
    'New Color',
    'Product Details',
    'Products',
    'Phones',
    'Suppliers',
    'Repair Product',
  ];

  static const List Pathes = [
    '/NewCustomer',
    '/NewBrand',
    '/BuyPhone',
    '/BuyAccessories',
    '/BuyTools',
    '/BuyExpenses',
    '/NewSupplier',
    '/NewCat',
    '/NewPhoneModel',
    '/NewColor',
    '/NewProductDetail',
    '/Products',
    '/Phones',
    '/Suppliers',
    '/BuyRepairProducts'
  ];
  static const List btnName = [
    'Add',
    'Add',
    'Buy',
    'Buy',
    'Buy',
    'Buy',
    'Add',
    'Add',
    'Add',
    'Add',
    'Add',
    'See',
    'See',
    'See',
    'Buy'
  ];
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
        title: Text('Management'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          homeController.selectedPageIndex.value = 0;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Variables',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => AddBrand());
                              },
                              icon: Icon(
                                Icons.branding_watermark,
                                color: Colors.blue.shade700,
                              )),
                          Text('Brands')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => AddCategory());
                              },
                              icon: Icon(
                                Icons.category,
                                color: Colors.blue.shade700,
                              )),
                          Text('Categories')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => AddColor());
                              },
                              icon: Icon(
                                FontAwesomeIcons.paintbrush,
                                color: Colors.blue.shade700,
                              )),
                          Text('Colors')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'People',labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => AddCustomer());
                              },
                              icon: Icon(
                                Icons.people,
                                color: Colors.blue.shade700,
                              )),
                          Text('Customers')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => AddSupplier());
                              },
                              icon: Icon(
                                Icons.public_rounded,
                                color: Colors.blue.shade700,
                              )),
                          Text('Suppliers')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                // Get.to(() => AddColor());
                              },
                              icon: Icon(
                                Icons.drive_eta_rounded,
                                color: Colors.blue.shade700,
                              )),
                          Text('Drivers')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),SizedBox(height: 20,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Products',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => BuyAccessories());
                              },
                              icon: Icon(
                                Icons.production_quantity_limits,
                                color: Colors.blue.shade700,
                              )),
                          Text('Buy')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => CategoryList());
                              },
                              icon: Icon(
                                Icons.category,
                                color: Colors.blue.shade700,
                              )),
                          Text('View By Category')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => ProductList(isPur: 0,
                                from_home: 0,));
                              },
                              icon: Icon(
                                Icons.all_inbox,
                                color: Colors.blue.shade700,
                              )),
                          Text('View all')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Phones'
                    ,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
          
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => CustomerListFPhones(                                ));
                              },
                              icon: Icon(
                                FontAwesomeIcons.mobile,
                                color: Colors.blue.shade700,
                              )),
                          Text('Buy Phone')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => PhonesList());
                              },
                              icon: Icon(
                                Icons.list,
                                color: Colors.blue.shade700,
                              )),
                          Text('Phones List')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => PhoneModelAdd());
                              },
                              icon: Icon(
                                FontAwesomeIcons.mobileButton ,
                                color: Colors.blue.shade700,
                              )),
                          Text('New Model')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => RechInvoicePaymentManage());
                      //         },
                      //         icon: Icon(
                      //         Icons.monetization_on,
                      //           color: Colors.blue.shade700,
                      //         )),
                      //     Text('Payments')
                      //   ],
                      // ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Invoices',labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => CustomerList(
                                  from_home: 0,
                                ));
                              },
                              icon: Icon(
                                FontAwesomeIcons.fileInvoiceDollar,
                                color: Colors.blue.shade700,
                              )),
                          Text('New')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => InvoiceHistoryManage());
                              },
                              icon: Icon(
                                Icons.history,
                                color: Colors.blue.shade700,
                              )),
                          Text('History')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => InvoiceDue());
                              },
                              icon: Icon(
                                FontAwesomeIcons.moneyCheckDollar,
                                color: Colors.blue.shade700,
                              )),
                          Text('Dues')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => InvoicePaymentManage());
                              },
                              icon: Icon(
                              Icons.monetization_on,
                                color: Colors.blue.shade700,
                              )),
                          Text('Payments')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),SizedBox(height: 20,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Purchases'
                    ,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
          
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => SupplierList(                                ));
                              },
                              icon: Icon(
                                FontAwesomeIcons.fileInvoiceDollar,
                                color: Colors.blue.shade700,
                              )),
                          Text('New')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => PurchaseHistoryManage());
                              },
                              icon: Icon(
                                Icons.history,
                                color: Colors.blue.shade700,
                              )),
                          Text('History')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => PurchaseDue());
                              },
                              icon: Icon(
                                FontAwesomeIcons.moneyCheckDollar,
                                color: Colors.blue.shade700,
                              )),
                          Text('Dues')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => PurchasePaymentManage());
                              },
                              icon: Icon(
                              Icons.monetization_on,
                                color: Colors.blue.shade700,
                              )),
                          Text('Payments')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Recharge Invoices'
                    ,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
          
          
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => CustomerListFrecharge(                                ));
                              },
                              icon: Icon(
                                FontAwesomeIcons.fileInvoiceDollar,
                                color: Colors.blue.shade700,
                              )),
                          Text('New')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => RechargeHistoryManage());
                              },
                              icon: Icon(
                                Icons.history,
                                color: Colors.blue.shade700,
                              )),
                          Text('History')
                        ],
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => RechargeDue());
                              },
                              icon: Icon(
                                FontAwesomeIcons.moneyCheckDollar,
                                color: Colors.blue.shade700,
                              )),
                          Text('Dues')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => RechInvoicePaymentManage());
                              },
                              icon: Icon(
                              Icons.monetization_on,
                                color: Colors.blue.shade700,
                              )),
                          Text('Payments')
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         onPressed: () {
                      //           Get.to(() => AddCustomer());
                      //         },
                      //         icon: Icon(
                      //           FontAwesomeIcons.person,
                      //           color: Colors.red.shade700,
                      //         )),
                      //     Text('Customers')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),

               
              SizedBox(height: 10,),
              // GridView.builder(
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: 15,
              //   gridDelegate:
              //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: EdgeInsets.all(15),
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(25),
              //           color: Colors.deepPurple.shade300,
              //         ),
              //         height: safeHeight * 0.8,
              //         width: safeWidth * 0.8,
              //         // color: Colors.deepPurple.shade300,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text(Variables[index]),
              //             SizedBox(
              //               height: safeHeight / 100,
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //               child: OutlinedButton(
              //                   style: ElevatedButton.styleFrom(
              //                     fixedSize: Size(double.maxFinite, 20),
              //                     backgroundColor: Colors.white,
              //                     side: BorderSide(width: 2.0, color: Colors.white),
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(32.0),
              //                     ),
              //                   ),
              //                   onPressed: () {
              //                     String name = Pathes[index];
              //                     Get.toNamed('$name');
              //                   },
              //                   child: Text(
              //                     btnName[index],
              //                     style: TextStyle(fontSize: 15),
              //                   )),
              //             )
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
