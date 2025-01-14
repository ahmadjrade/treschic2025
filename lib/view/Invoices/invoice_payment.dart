// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/invoice_payment_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/invoice_payment_model.dart';

class InvoicePayment extends StatelessWidget {
  InvoicePayment({super.key});

  final InvoicePaymentController invoicePaymentController =
      Get.find<InvoicePaymentController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    // invoicePaymentController.reset();

    invoicePaymentController.CalTotal();
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
                        invoicePaymentController.SearchPayments(
                      FilterQuery.text,
                    );
                    if (invoicePaymentController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (invoicePaymentController.payments.isEmpty) {
                      return Center(
                          child: Text('No Payment Yet In This Store ! '));
                    } else if (filteredinvoices.length == 0) {
                      return Center(
                          child: Text('No Payment Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final InvoicePaymentModel invoice =
                              filteredinvoices[index];
                          return Container(
                            decoration: BoxDecoration(
                              //   color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: ListTile(
                              onLongPress: () {
                                //copyToClipboard(invoice.id);
                              },
                              title: Column(
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
                                            invoice.Username.toUpperCase() +
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Payment Ammount:  ' +
                                                      addCommasToNumber(
                                                              invoice.Ammount)
                                                          .toString() +
                                                      '\$',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.blue.shade900),
                                                ),
                                                Text(
                                                  'Invoice Date:  ' +
                                                      (invoice.Invoice_Date)
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.blue.shade900),
                                                ),
                                                Text(
                                                  'Old Due:  ' +
                                                      (invoice.Old_Due)
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .green.shade900),
                                                ),
                                                Text(
                                                  'New Due:  ' +
                                                      (invoice.New_Due)
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .green.shade900),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
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
                                              .total.value)
                                          .toString() +
                                      '\$',
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
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
