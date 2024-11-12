import 'dart:ffi';

import 'package:dotted_line/dotted_line.dart';
import 'package:fixnshop_admin/view/Expenses/expense_manage.dart';
import 'package:fixnshop_admin/view/Invoices/customer_list_finvhistory.dart';
import 'package:fixnshop_admin/view/Invoices/driver_list_finvhistory.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_due.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_due.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/rech_invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_due.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_manage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Management extends StatelessWidget {
  const Management({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Management'),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black,
          ),
        ],
      )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  Text('History ',
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
                  Get.to(() => InvoiceHistoryManage());
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
                          'Invoices History',
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
                  Get.to(() => RechargeHistoryManage());
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
                          'Recharges History',
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
                  Get.to(() => PurchaseHistoryManage());
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
                          'Purchases History',
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
                  Get.to(() => ExpenseManage());
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
                          'Expenses History',
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
                  Text('Payments ',
                      style: TextStyle(
                        color: Colors.green.shade900,
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
                  Get.to(() => InvoicePaymentManage());
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
                          'Invoice Payemnts',
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
                  Get.to(() => RechInvoicePaymentManage());
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
                          'Recharge Payments',
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
                  Get.to(() => PurchasePaymentManage());
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
                          'Purchase Payments',
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
                  Text('Dues ',
                      style: TextStyle(
                        color: Colors.red.shade900,
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
                  Get.to(() => InvoiceDue());
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
                          'Invoices Due',
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
                  Get.to(() => RechargeDue());
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
                          'Recharges Due',
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
                  Get.to(() => PurchaseDue());
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
                          'Purchases Due',
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
                  Text('Statements ',
                      style: TextStyle(
                        color: Colors.black,
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
                  Get.to(() => CustomerListFInvHistory());
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
                          'Customer Invoices',
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
                  Get.to(() => DriverListFInvHistory());
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
                          'Pending Delivery Invoices',
                          style: TextStyle(fontSize: 15),
                        ),
                        // OutlinedButton(onPressed: () {}, child: Text('Select'))
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => PurchasePaymentManage());
              //   },
              //   child: Card(
              //     // margin: ,
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Icon(Icons.history),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             'Purchase Payments',
              //             style: TextStyle(fontSize: 15),
              //           ),
              //           // OutlinedButton(onPressed: () {}, child: Text('Select'))
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
