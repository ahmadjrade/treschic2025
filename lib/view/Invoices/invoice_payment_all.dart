// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/invoice_payment_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/model/invoice_payment_model.dart';
import 'package:treschic/view/Invoices/invoice_history_items.dart';
import 'package:treschic/view/Invoices/invoice_payment_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

class InvoicePaymentAll extends StatelessWidget {
  InvoicePaymentAll({super.key});

  final InvoicePaymentController invoicePaymentController =
      Get.find<InvoicePaymentController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  @override
  Widget build(BuildContext context) {
    invoicePaymentController.CalTotalall();
    // invoicePaymentController.reset();
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    invoicePaymentController.CalTotalall();
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Obx(() {
                    FilterQuery.text = barcodeController.barcode3.value;
                    return Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
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
                                invoicePaymentController.payments.refresh();
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    FilterQuery.clear();
                                    invoicePaymentController.payments.refresh();
                                  },
                                ),
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: 'Search By Item Name or Number',
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Obx(
                  () {
                    final List<InvoicePaymentModel> filteredinvoices =
                        invoicePaymentController.SearchInvoicesAll(
                            FilterQuery.text);

                    if (invoicePaymentController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (invoicePaymentController.payments.isEmpty) {
                      return Center(
                          child: Text('No Payments Yet In This Store!'));
                    } else if (filteredinvoices.isEmpty) {
                      return Center(child: Text('No Payments Found!'));
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredinvoices.length <
                                      invoicePaymentController.itemsToShow.value
                                  ? filteredinvoices.length
                                  : invoicePaymentController.itemsToShow.value,
                              itemBuilder: (context, index) {
                                final InvoicePaymentModel invoice =
                                    filteredinvoices[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    //   color: Colors.grey.shade500,
                                    border:
                                        Border.all(color: Colors.grey.shade500),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: ListTile(
                                    onLongPress: () {
                                      //copyToClipboard(invoice.id);
                                    },
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'P#${invoice.Invoice_Payment_id} - '
                                                      '#' +
                                                  invoice.Invoice_id
                                                      .toString() +
                                                  ' || ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              invoice.Payment_Date,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              ' ' + Format(invoice.Payment_Time)
                                              // +
                                              // ' -- ' +
                                              // invoice.phone_Code,
                                              ,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              ' || ' +
                                                  invoice.Username
                                                      .toUpperCase() +
                                                  ' Store'
                                              // +
                                              // ' -- ' +
                                              // invoice.phone_Code,
                                              ,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Payment Ammount:  ' +
                                                            addCommasToNumber(
                                                                    invoice
                                                                        .Ammount)
                                                                .toString() +
                                                            '\$',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .blue.shade900),
                                                      ),
                                                      Text(
                                                        'Invoice Date:  ' +
                                                            (invoice.Invoice_Date)
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .blue.shade900),
                                                      ),
                                                      Text(
                                                        'Old Due:  ' +
                                                            (invoice.Old_Due)
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                      Text(
                                                        'New Due:  ' +
                                                            (invoice.New_Due)
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              OutlinedButton(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(
                                                      double.maxFinite, 20),
                                                  backgroundColor:
                                                      Colors.red.shade100,
                                                  side: BorderSide(
                                                    width: 2.0,
                                                    color: Colors.red.shade900,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      // The user CANNOT close this dialog  by pressing outsite it
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (_) {
                                                        return Dialog(
                                                          // The background color
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // The loading indicator
                                                                CircularProgressIndicator(),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                // Some text
                                                                Text('Loading')
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  invoicePaymentController.DeletePayment(
                                                          invoice.Invoice_Payment_id
                                                              .toString())
                                                      .then((value) =>
                                                          Navigator.of(context)
                                                              .pop())
                                                      .then((value) => showToast(
                                                          invoicePaymentController
                                                              .result2))
                                                      .then((value) =>
                                                          invoicePaymentController
                                                                  .isDataFetched =
                                                              false)
                                                      .then((value) =>
                                                          invoicePaymentController
                                                              .fetch_payments());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .red.shade900),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Icon(
                                                      Icons.delete,
                                                      color:
                                                          Colors.red.shade900,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (invoicePaymentController.itemsToShow.value <
                              filteredinvoices.length)
                            OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade100,
                                side: BorderSide(
                                  width: 2.0,
                                  color: Colors.green.shade100,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () {
                                invoicePaymentController.itemsToShow.value +=
                                    20; // Increase the observable value
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Show More',
                                    style:
                                        TextStyle(color: Colors.green.shade900),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_circle_right_rounded,
                                    color: Colors.green.shade900,
                                  ),
                                ],
                              ),
                            ),
                        ],
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
                                Text(
                                  'Invoices Total US:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(invoicePaymentController
                                              .total_all.value)
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
                            //       addCommasToNumber(invoicePaymentController
                            //                   .totalrecusd_all.value)
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
                            //       'Invoices Recieved LB:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(invoicePaymentController
                            //                   .totalreclb_all.value)
                            //               .toString() +
                            //           'LL',
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
                            //       'Invoices Recieved TOTAL:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(invoicePaymentController
                            //                   .totalrec_all.value)
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
                            //       addCommasToNumber(invoicePaymentController
                            //                   .totaldue_all.value)
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
            SizedBox(
              height: 14,
            )
          ],
        ),
      ),
    );
  }
}
