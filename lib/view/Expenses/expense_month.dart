// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/expenses_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/purchase_payment_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/expenses_model.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/invoice_payment_model.dart';
import 'package:fixnshop_admin/model/purchase_payment_model.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseMonth extends StatelessWidget {
  ExpenseMonth({super.key});

  final ExpensesController expensesController = Get.find<ExpensesController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    expensesController.CalTotalMonth();
    // expensesController.reset();

    expensesController.CalTotalMonth();
    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText));
      // Show a snackbar or any other feedback that the text has been copied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone IMEI copied to clipboard'),
        ),
      );
    }

    String Format2(Date) {
      String time8Hour = '';
      DateTime parsedDate = DateFormat.Hms().parse(Date);

      // Format the parsed time into 8-hour time with AM/PM
      time8Hour = DateFormat('yyyy-MM-dd').format(parsedDate);
      return time8Hour;
    }

    String Format(time24Hour) {
      String time8Hour = '';
      DateTime parsedTime = DateFormat.Hms().parse(time24Hour);

      // Format the parsed time into 8-hour time with AM/PM
      time8Hour = DateFormat('h:mm a').format(parsedTime);
      return time8Hour;
    }

    String addCommasToNumber(double value) {
      final formatter = NumberFormat('#,##0.00');
      return formatter.format(value);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Obx(() {
                        FilterQuery.text = barcodeController.barcode3.value;
                        return Expanded(
                          child: TextField(
                            controller: FilterQuery,
                            onChanged: (query) {
                              //print(formattedDate);
                              expensesController.expenses.refresh();
                            },
                            decoration: InputDecoration(
                              labelText: 'Search by ID,Customer Name or Number',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        );
                      }),
                      // SizedBox(
                      //   width: 14,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //   child: IconButton(
                      //     icon: Icon(Icons.qr_code_scanner_rounded),
                      //     color: Colors.black,
                      //     onPressed: () {
                      //       barcodeController.scanBarcodeSearch();
                      //       //.then((value) => set());
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    final List<ExpensesModel> filteredinvoices =
                        expensesController.searchExpensesMonth(
                      FilterQuery.text,
                    );
                    if (expensesController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (expensesController.expenses.isEmpty) {
                      return Center(
                          child: Text('No Expenses Yet In This Store ! '));
                    } else if (filteredinvoices.length == 0) {
                      return Center(
                          child: Text('No Expenses Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final ExpensesModel expense = filteredinvoices[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '#' +
                                                expense.Expense_id.toString() +
                                                ' || ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            expense.Exp_Cat_Name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        addCommasToNumber(expense.Expense_Value)
                                                .toString() +
                                            '\$',
                                        style: TextStyle(
                                            color: Colors.red.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        expense.Expense_Date,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        ' ' + Format(expense.Expense_Time)
                                        // +
                                        // ' -- ' +
                                        // expense.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        ' || ' +
                                            expense.Username.toUpperCase() +
                                            ' Store'
                                        // +
                                        // ' -- ' +
                                        // expense.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: true,
              child: Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Expense Total US:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(expensesController
                                              .total_month.value)
                                          .toString() +
                                      '\$',
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Invoices Recieved US:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(expensesController
                            //                   .totalrecusd_month.value)
                            //               .toString() +
                            //           '\$',
                            //       style: TextStyle(
                            //           color: Colors.green.shade900,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ), Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Invoices Recieved LB:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(expensesController
                            //                   .totalreclb_month.value)
                            //               .toString() +
                            //           'LL',
                            //       style: TextStyle(
                            //           color: Colors.green.shade900,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ), Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Invoices Recieved TOTAL:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(expensesController
                            //                   .totalrec_month.value)
                            //               .toString() +
                            //           '\$',
                            //       style: TextStyle(
                            //           color: Colors.green.shade900,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Invoices Due US:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(expensesController
                            //                   .totaldue_month.value)
                            //               .toString() +
                            //           '\$',
                            //       style: TextStyle(
                            //           color: Colors.red.shade900,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
