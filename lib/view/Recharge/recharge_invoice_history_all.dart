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

class RechargeInvoiceHistoryAll extends StatelessWidget {
  RechargeInvoiceHistoryAll({super.key});

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
      rechargeInvoiceHistoryController.CalTotalall();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                rechargeInvoiceHistoryController
                                    .recharge_invoices
                                    .refresh();
                              },
                              decoration: InputDecoration(
                                labelText:
                                    'Search by ID,Customer Name or Number',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          );
                        }),
                       
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                 
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () {
                      final List<InvoiceModel> filteredinvoices =
                          rechargeInvoiceHistoryController.SearchRechargeAll(
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
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredinvoices.length < rechargeInvoiceHistoryController.itemsToShow.value
                                                ? filteredinvoices.length
                                                : rechargeInvoiceHistoryController.itemsToShow.value,
                              itemBuilder: (context, index) {
                                final InvoiceModel invoice =
                                    filteredinvoices[index];
                                return Container(
                                  //  width: double.infinity,
                                  //   height: 150.0,
                                  color: rechargeInvoiceHistoryController
                                          .ispaid(invoice.isPaid)
                                      ? Colors.grey.shade300
                                      : Colors.red.shade100,
                                  margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  //     padding: EdgeInsets.all(35),
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    // leading: Column(
                                    //   children: [
                                    //     Expanded(
                                    //       child: invoice.imageUrl != null
                                    //           ? Image.network(invoice.imageUrl!)
                                    //           : Placeholder(),
                                    //     ),
                                    //   ],
                                    // ),
                                    onLongPress: () {
                                      //copyToClipboard(invoice.id);
                                    },
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                            Icon(
                                              Icons.paid,
                                              color:
                                                  rechargeInvoiceHistoryController
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
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              ' ' + Format(invoice.Invoice_Time)
                                              // +
                                              // ' -- ' +
                                              // invoice.phone_Code,
                                              ,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
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
                                                  fontWeight: FontWeight.w300,
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
                                                            '\$',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .blue.shade900),
                                                      ),
                                                      Text(
                                                        'Invoice Total LL:  ' +
                                                            addCommasToNumber(invoice
                                                                    .Invoice_Total_Lb)
                                                                .toString() +
                                                            ' LB',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .blue.shade900),
                                                      ),
                                                      Text(
                                                        'Invoice Rec US:  ' +
                                                            addCommasToNumber(invoice
                                                                    .Invoice_Rec_Usd)
                                                                .toString() +
                                                            '\$',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .green.shade900),
                                                      ),
                                                      Text(
                                                        'Invoice Rec LL:  ' +
                                                            addCommasToNumber(invoice
                                                                    .Invoice_Rec_Lb)
                                                                .toString() +
                                                            ' LB',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .green.shade900),
                                                      ),
                                                      Text(
                                                        'Invoice Due US:  ' +
                                                            addCommasToNumber(invoice
                                                                    .Invoice_Due_USD)
                                                                .toString() +
                                                            '\$',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .red.shade900),
                                                      ),
                                                      Text(
                                                        'Invoice Due LL:  ' +
                                                            addCommasToNumber(invoice
                                                                    .Invoice_Due_LB)
                                                                .toString() +
                                                            ' LB',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .red.shade900),
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
                                                            ? Colors.green.shade900
                                                            : Colors.red.shade900,
                                                    side: BorderSide(
                                                      width: 2.0,
                                                      color:
                                                          rechargeInvoiceHistoryController
                                                                  .ispaid(invoice
                                                                      .isPaid)
                                                              ? Colors
                                                                  .green.shade900
                                                              : Colors.red.shade900,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(
                                                        () => RechargeHistoryItems(
                                                              Recharge_id:
                                                                  invoice.Invoice_id
                                                                      .toString(),
                                                              Customer_Name:
                                                                  invoice.Cus_Name
                                                                      .toString(),
                                                              Customer_Number:
                                                                  invoice.Cus_Number
                                                                      .toString(),
                                                              Invoice_Total_US:
                                                                  invoice.Invoice_Total_Usd
                                                                      .toString(),
                                                              Invoice_Rec_US: invoice
                                                                      .Invoice_Rec_Usd
                                                                  .toString(),
                                                              Invoice_Due_US: invoice
                                                                      .Invoice_Due_USD
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
                                                            color: Colors.white),
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
                                                                ? Colors.white
                                                                : Colors.white,
                                                        //  'Details',
                                                        //   style: TextStyle(
                                                        //        color: Colors.red),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                            
                                            ]),),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ), if (rechargeInvoiceHistoryController.itemsToShow.value < filteredinvoices.length)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120.0),
                  child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                    // fixedSize: Size(double.maxFinite,20),
                                    backgroundColor:
                                        Colors.white
                                           ,
                                    side: BorderSide(
                                      width: 2.0,
                                      color: Colors.green.shade900
                                          
                                          ,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                                        rechargeInvoiceHistoryController.itemsToShow.value += 20; // Increase the observable value

                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Show More',
                                        style: TextStyle(color: Colors.green.shade900),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_circle_right_rounded,
                                        color: 
                                             Colors.green.shade900,
                                      ),
                                    ],
                                  ),
                                ),
                  
                 
                ),
                          ],
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
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Total US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .total_all.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Recieved US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .totalrecusd_all.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Recieved US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .totalreclb_all.value)
                                            .toString() +
                                        ' LL',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Recieved TOTAL:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .totalrec_all.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Due US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(
                                                rechargeInvoiceHistoryController
                                                    .totaldue_all.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.red.shade900,
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
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
