// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_items.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RechargeInvoiceHistoryYesterday extends StatelessWidget {
  RechargeInvoiceHistoryYesterday({super.key});

  final RechargeInvoiceHistoryController rechargeInvoiceHistoryController =
      Get.find<RechargeInvoiceHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    // rechargeInvoiceHistoryController.reset();
    rechargeInvoiceHistoryController.CalTotalYday();
    // rechargeInvoiceHistoryController.CalTotal();
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
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Obx(() {
                    FilterQuery.text = barcodeController.barcode3.value;
                    return Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              //obscureText: true,
                              //  readOnly: isLoading,
                              controller: FilterQuery,
                              onChanged: (query) {
                                rechargeInvoiceHistoryController
                                    .recharge_invoices
                                    .refresh();
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: 'Search By ID,Name or Number',
                              ),
                            ),
                          )),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Obx(
                  () {
                    final List<InvoiceModel> filteredinvoices =
                        rechargeInvoiceHistoryController
                            .SearchRechargeYesterday(
                      FilterQuery.text,
                    );
                    if (rechargeInvoiceHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (rechargeInvoiceHistoryController
                        .recharge_invoices.isEmpty) {
                      return Center(
                          child: Text('No Invoices Yet In This Store ! '));
                    } else if (filteredinvoices.length == 0) {
                      return Center(
                          child: Text('No Invoices Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final InvoiceModel invoice = filteredinvoices[index];
                          return Card(
                            margin: EdgeInsets.all(5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '#' +
                                            invoice.Invoice_id.toString() +
                                            ' || ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        invoice.Cus_Name! +
                                            ' ' +
                                            invoice.Cus_Number!
                                        // +
                                        // ' -- ' +
                                        // invoice.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.paid,
                                        color: rechargeInvoiceHistoryController
                                                .ispaid(invoice.isPaid)
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        invoice.Invoice_Date
                                        // +
                                        // ' -- ' +
                                        // invoice.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                      Text(
                                        ' ' + Format(invoice.Invoice_Time)
                                        // +
                                        // ' -- ' +
                                        // invoice.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                      Text(
                                        ' || ' +
                                            invoice.Username.toUpperCase() +
                                            ' Store'
                                        // +
                                        // ' -- ' +
                                        // invoice.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Invoice Total US:  ' +
                                                      addCommasToNumber(invoice
                                                              .Invoice_Total_Usd)
                                                          .toString() +
                                                      '\$' +
                                                      ' || ' +
                                                      addCommasToNumber(invoice
                                                              .Invoice_Total_Lb)
                                                          .toString() +
                                                      ' LB',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.blue.shade900),
                                                ),
                                                Text(
                                                  'Invoice Rec US:  ' +
                                                      addCommasToNumber(invoice
                                                              .Invoice_Rec_Usd)
                                                          .toString() +
                                                      '\$' +
                                                      ' + ' +
                                                      addCommasToNumber(invoice
                                                              .Invoice_Rec_Lb)
                                                          .toString() +
                                                      ' LB',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .green.shade900),
                                                ),
                                                Text(
                                                  'Invoice Due US:  ' +
                                                      addCommasToNumber(invoice
                                                              .Invoice_Due_USD)
                                                          .toString() +
                                                      '\$' +
                                                      ' || ' +
                                                      addCommasToNumber(invoice
                                                              .Invoice_Due_LB)
                                                          .toString() +
                                                      ' LB',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.red.shade900),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize:
                                                  Size(double.maxFinite, 20),
                                              backgroundColor:
                                                  rechargeInvoiceHistoryController
                                                          .ispaid(
                                                              invoice.isPaid)
                                                      ? Colors.green.shade100
                                                      : Colors.red.shade100,
                                              side: BorderSide(
                                                width: 2.0,
                                                color:
                                                    rechargeInvoiceHistoryController
                                                            .ispaid(
                                                                invoice.isPaid)
                                                        ? Colors.green.shade900
                                                        : Colors.red.shade900,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => RechargeHistoryItems(
                                                    Recharge_id: invoice
                                                        .Invoice_id.toString(),
                                                    Customer_Name: invoice
                                                        .Cus_Name.toString(),
                                                    Customer_Number: invoice
                                                        .Cus_Number.toString(),
                                                    Invoice_Total_US: invoice
                                                            .Invoice_Total_Usd
                                                        .toString(),
                                                    Invoice_Rec_US:
                                                        invoice.Invoice_Rec_Usd
                                                            .toString(),
                                                    Invoice_Due_US:
                                                        invoice.Invoice_Due_USD
                                                            .toString(),
                                                  ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Select',
                                                  style: TextStyle(
                                                      color:
                                                          rechargeInvoiceHistoryController
                                                                  .ispaid(invoice
                                                                      .isPaid)
                                                              ? Colors.green
                                                                  .shade900
                                                              : Colors.red
                                                                  .shade900),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_circle_right_rounded,
                                                  color:
                                                      rechargeInvoiceHistoryController
                                                              .ispaid(invoice
                                                                  .isPaid)
                                                          ? Colors
                                                              .green.shade900
                                                          : Colors.red.shade900,
                                                  //  'Details',
                                                  //   style: TextStyle(
                                                  //        color: Colors.red),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
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
                              Row(
                                children: [
                                  Text(
                                    'Total: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .total_yday.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recieved: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .totalrec_yday.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Due: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .totaldue_yday.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))));
              }),
            ),
          ],
        ),
      ),
    );
  }
}
