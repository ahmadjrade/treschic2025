// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/purchase_history_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/model/purchase_history_model.dart';
import 'package:treschic/model/purchase_model.dart';
import 'package:treschic/view/Invoices/invoice_history_items.dart';
import 'package:treschic/view/purchase/purchase_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

class PurchaseHistory extends StatelessWidget {
  PurchaseHistory({super.key});

  final PurchaseHistoryController purchaseHistoryController =
      Get.find<PurchaseHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    // purchaseHistoryController.reset();

    purchaseHistoryController.CalTotal();
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
                                purchaseHistoryController.purchases.refresh();
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    FilterQuery.clear();
                                    purchaseHistoryController.purchases
                                        .refresh();
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
                    final List<PurchaseModel> filteredinvoices =
                        purchaseHistoryController.searchPurchases(
                      FilterQuery.text,
                    );
                    if (purchaseHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (purchaseHistoryController.purchases.isEmpty) {
                      return Center(
                          child: Text('No Invoices Yet In This Store ! '));
                    } else if (filteredinvoices.length == 0) {
                      return Center(
                          child: Text('No Invoices Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final PurchaseModel purchase =
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
                              // leading: Column(
                              //   children: [
                              //     Expanded(
                              //       child: purchase.imageUrl != null
                              //           ? Image.network(purchase.imageUrl!)
                              //           : Placeholder(),
                              //     ),
                              //   ],
                              // ),
                              onLongPress: () {
                                //copyToClipboard(purchase.id);
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
                                            purchase.Purchase_id.toString() +
                                            ' || ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        purchase.Supplier_Name! +
                                            ' ' +
                                            purchase.Supplier_Number!
                                        // +
                                        // ' -- ' +
                                        // purchase.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.paid,
                                        color: purchaseHistoryController
                                                .ispaid(purchase.isPaid)
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        purchase.Purchase_Date
                                        // +
                                        // ' -- ' +
                                        // purchase.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                      Text(
                                        ' ' + Format(purchase.Purchase_Time)
                                        // +
                                        // ' -- ' +
                                        // purchase.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                      Text(
                                        ' || ' +
                                            purchase.Username.toUpperCase() +
                                            ' Store'
                                        // +
                                        // ' -- ' +
                                        // purchase.phone_Code,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                    addCommasToNumber(purchase
                                                            .Purchase_Total_USD)
                                                        .toString() +
                                                    '\$' +
                                                    ' || ' +
                                                    addCommasToNumber(purchase
                                                            .Purchase_Total_LB)
                                                        .toString() +
                                                    ' LB',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Colors.blue.shade900),
                                              ),
                                              Text(
                                                'Invoice Rec US:  ' +
                                                    addCommasToNumber(purchase
                                                            .Purchase_Rec_USD)
                                                        .toString() +
                                                    '\$' +
                                                    ' + ' +
                                                    addCommasToNumber(purchase
                                                            .Purchase_Rec_LB)
                                                        .toString() +
                                                    ' LB',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Colors.green.shade900),
                                              ),
                                              Text(
                                                'Invoice Due US:  ' +
                                                    addCommasToNumber(purchase
                                                            .Purchase_Due_USD)
                                                        .toString() +
                                                    '\$' +
                                                    ' || ' +
                                                    addCommasToNumber(purchase
                                                            .Purchase_Due_LB)
                                                        .toString() +
                                                    ' LB',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red.shade900),
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
                                                purchaseHistoryController
                                                        .ispaid(purchase.isPaid)
                                                    ? Colors.green.shade100
                                                    : Colors.red.shade100,
                                            side: BorderSide(
                                              width: 2.0,
                                              color: purchaseHistoryController
                                                      .ispaid(purchase.isPaid)
                                                  ? Colors.green.shade900
                                                  : Colors.red.shade900,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.to(() => PurchaseHistoryItems(
                                                  Purchase_id: purchase
                                                      .Purchase_id.toString(),
                                                  Supplier_Name: purchase
                                                      .Supplier_Name.toString(),
                                                  Supplier_Number:
                                                      purchase.Supplier_Number
                                                          .toString(),
                                                  purchase_Total_US: purchase
                                                          .Purchase_Total_USD
                                                      .toString(),
                                                  purchase_Rec_US:
                                                      purchase.Purchase_Rec_USD
                                                          .toString(),
                                                  purchase_Due_US:
                                                      purchase.Purchase_Due_USD
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
                                                      purchaseHistoryController
                                                              .ispaid(purchase
                                                                  .isPaid)
                                                          ? Colors
                                                              .green.shade900
                                                          : Colors.red.shade900,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_circle_right_rounded,
                                                color: purchaseHistoryController
                                                        .ispaid(purchase.isPaid)
                                                    ? Colors.green.shade900
                                                    : Colors.red.shade900,
                                                //  'Details',
                                                //   style: TextStyle(
                                                //        color: Colors.red),
                                              ),
                                            ],
                                          )),
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
                                                  purchaseHistoryController
                                                      .total.value)
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
                                                  purchaseHistoryController
                                                      .totalrec.value)
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
                                                  purchaseHistoryController
                                                      .totaldue.value)
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
