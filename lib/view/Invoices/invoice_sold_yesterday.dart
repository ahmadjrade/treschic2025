// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/invoice_history_model.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/invoice_payment_model.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceSoldYday extends StatelessWidget {
  InvoiceSoldYday({super.key});

  final InvoiceDetailController invoiceDetailController =
      Get.find<InvoiceDetailController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  Color ispaid(int ispaid) {
    if (ispaid == 1) {
      return Colors.green.shade100;
    } else {
      return Colors.red.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    invoiceDetailController.CalTotalYday();
    // invoiceDetailController.reset();

    // invoiceDetailController.CalTotal();
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
            // Top Search Section
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
                          invoiceDetailController.invoice_detail.refresh();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search by ID, Customer Name, or Number',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Spacing
            SizedBox(height: 20),

            // Scrollable List of Invoices
            Expanded(
              child: Obx(() {
                final List<InvoiceHistoryModel> filteredInvoices =
                    invoiceDetailController.SearchInvoicesYesterday(
                  FilterQuery.text,
                );
                if (invoiceDetailController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (invoiceDetailController.invoice_detail.isEmpty) {
                  return Center(child: Text('No Items Sold In This Store!'));
                } else if (filteredInvoices.isEmpty) {
                  return Center(
                      child: Text('No Items Sold Yet In This Store!'));
                } else {
                  return ListView.builder(
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      final InvoiceHistoryModel invoice =
                          filteredInvoices[index];
                      return Card(
                        color: ispaid(invoice.isPaid),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: ExpansionTile(
                          collapsedTextColor: Colors.black,
                          textColor: Colors.black,
                          backgroundColor: ispaid(invoice.isPaid),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${invoice.Product_Quantity} PCS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                'TP: ${invoice.product_TP}\$',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.green.shade900),
                              ),
                            ],
                          ),
                          title: Text(
                            '#${invoice.Invoice_Detail_id} || ${invoice.Product_Name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Product Code: ${invoice.Product_Code}'),
                                  SizedBox(width: 5),
                                  Text(
                                      'Product Color: ${invoice.Product_Color}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          'Unit Price: ${invoice.product_UP}\$'),
                                      SizedBox(height: 5),
                                      Text(
                                          ' | Total Price: ${invoice.product_TP}\$'),
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
            ),

            // Bottom Total Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
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
                          Obx(() => Text(
                                '${addCommasToNumber(invoiceDetailController.total_yday.value)}\$',
                                style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Spacing
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
