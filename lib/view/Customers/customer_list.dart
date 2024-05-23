// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Invoices/new_invoice.dart';
import 'package:fixnshop_admin/view/Product/product_list_detail.dart';
import 'package:fixnshop_admin/view/home_screen.dart';
import 'package:fixnshop_admin/view/home_screen_manage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerList extends StatelessWidget {
  CustomerList({super.key});
  final CustomerController customerController = Get.find<CustomerController>();
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }
    final HomeController homeController = Get.find<HomeController>();

  TextEditingController Customer_Number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // productController.fetchproducts();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Customer List'),
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
                  customerController.isDataFetched = false;
                  customerController.fetchcustomers();
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
        canPop: false,
        onPopInvoked: (didPop) {
          homeController.selectedPageIndex.value = 0;

        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: Customer_Number,
                keyboardType: TextInputType.number,
                onChanged: (query) {
                  customerController.customers.refresh();
                },
                decoration: InputDecoration(
                  labelText: 'Search by Number',
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
                  final List<CustomerModel> filteredCustomers =
                      customerController.searchProducts(Customer_Number.text);
                  if (customerController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final CustomerModel customer = filteredCustomers[index];
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
                                  customer.Cus_Name.toUpperCase()
                                  // +
                                  // ' -- ' +
                                  // customer.Product_Code,
                                  ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          customer.Cus_Number
                                          // +
                                          // ' -- ' +
                                          // customer.Product_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.attach_money_sharp,
                                      color: Colors.red.shade900,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Due US: ' +
                                          addCommasToNumber(customer.Cus_Due_USD)
                                              .toString() +
                                          ' \$'
                                      // +
                                      // ' -- ' +
                                      // customer.Product_Code,
                                      ,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                //Text(customer.Cus_Due_USD.toString()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.attach_money_sharp,
                                      color: Colors.red.shade900,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Due LB: ' +
                                          addCommasToNumber(customer.Cus_Due_LB)
                                              .toString() +
                                          'LL'
                                      // +
                                      // ' -- ' +
                                      // customer.Product_Code,
                                      ,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
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
        
                                  Get.to(() => NewInvoice(
                                        Cus_id: customer.Cus_id.toString(),
                                        Cus_Name: customer.Cus_Name,
                                        Cus_Number: customer.Cus_Number,
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
      ),
    );
  }
}
