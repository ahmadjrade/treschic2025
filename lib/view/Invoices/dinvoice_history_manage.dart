// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/view/Invoices/dinvoice_history.dart';
import 'package:treschic/view/Invoices/dinvoice_history_all.dart';
import 'package:treschic/view/Invoices/dinvoice_history_month.dart';
import 'package:treschic/view/Invoices/dinvoice_history_yesterday.dart';
import 'package:treschic/view/Invoices/invoice_history.dart';
import 'package:treschic/view/Invoices/invoice_history_all.dart';
import 'package:treschic/view/Invoices/invoice_history_items.dart';
import 'package:treschic/view/Invoices/invoice_history_month.dart';
import 'package:treschic/view/Invoices/invoice_history_yesterday.dart';
import 'package:treschic/view/Invoices/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DInvoiceHistoryManage extends StatelessWidget {
  DInvoiceHistoryManage({super.key});

  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  String Today = '';
  String Yesterday = '';

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Today = DateFormat('EEEE').format(now);
    DateTime yday = now.subtract(Duration(days: 1));
    String getMonthName(DateTime date) {
      return DateFormat('MMMM').format(date);
    }

    String monthName = getMonthName(now);

    // Getting the name of the day for yesterday
    Yesterday = DateFormat('EEEE').format(yday);

    // invoiceHistoryController.reset();

    // invoiceHistoryController.CalTotal();
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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Invoice History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Container(
                decoration: BoxDecoration(
                  //   color: Colors.grey.shade500,
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                    onPressed: () {
                      invoiceHistoryController.reset();
                      invoiceHistoryController.isDataFetched = false;
                      invoiceHistoryController.fetchinvoices();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.blue.shade900,
                    )),
              )
            ],
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.green.shade100,
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    TabItem(title: Today, count: 0),
                    TabItem(title: Yesterday, count: 0),
                    TabItem(title: monthName, count: 0),
                    TabItem(title: 'All', count: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              DInvoiceHistory(), // Page for "Today" tab
              DInvoiceHistoryYesterday(),
              DInvoiceHistoryMonth(), // Page for "Yesterday" tab
              // Page for "Yesterday" tab
              DInvoiceHistoryAll(), // Page for "All" tab
            ],
          ),
        ),
      ),
    );
  }
}
