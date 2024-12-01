// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RechargeDue extends StatelessWidget {
  RechargeDue({super.key});

  final RechargeInvoiceHistoryController rechargeInvoiceHistoryController =
      Get.find<RechargeInvoiceHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  TextEditingController Payment_Ammount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    rechargeInvoiceHistoryController.CalTotalall();
    // rechargeInvoiceHistoryController.reset();

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

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      appBar: AppBar(
          title: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recharge Invoice Due',
            style: TextStyle(fontSize: 17),
          ),
          Container(
            decoration: BoxDecoration(
              //   color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
                onPressed: () {
                  rechargeInvoiceHistoryController.reset();
                  rechargeInvoiceHistoryController.isDataFetched = false;
                  rechargeInvoiceHistoryController.fetchrechargeInvoice();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.blue.shade900,
                )),
          )
        ],
      ))),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                    decoration: BoxDecoration(
                      //   color: Colors.grey.shade500,
                      border: Border.all(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        //   obscureText: true,
                        //  readOnly: isLoading,
                        onChanged: (value) {
                          //print(formattedDate);
                          rechargeInvoiceHistoryController.recharge_invoices
                              .refresh();
                        },
                        controller: FilterQuery,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              FilterQuery.clear();
                              //print(formattedDate);
                              rechargeInvoiceHistoryController.recharge_invoices
                                  .refresh();
                            },
                          ),
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintText: 'Search By Name or Number',
                        ),
                      ),
                    ))),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Obx(
                  () {
                    final List<InvoiceModel> filteredinvoices =
                        rechargeInvoiceHistoryController.searchDueRecharge(
                      FilterQuery.text,
                    );
                    if (rechargeInvoiceHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (rechargeInvoiceHistoryController
                        .recharge_invoices.isEmpty) {
                      return Center(
                          child: Text('No Due invoices Yet In This Store ! '));
                    } else if (filteredinvoices.length == 0) {
                      return Center(
                          child: Text('No Due invoices Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final InvoiceModel invoice = filteredinvoices[index];
                          return Container(
                            decoration: BoxDecoration(
                              //   color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            //     padding: EdgeInsets.all(35),
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
                                      ]),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              // fixedSize:
                                              //     Size(double.infinity, 20),
                                              backgroundColor:
                                                  rechargeInvoiceHistoryController
                                                          .ispaid(
                                                              invoice.isPaid)
                                                      ? Colors.green.shade100
                                                      : Colors.blue.shade100,
                                              side: BorderSide(
                                                width: 2.0,
                                                color:
                                                    rechargeInvoiceHistoryController
                                                            .ispaid(
                                                                invoice.isPaid)
                                                        ? Colors.green.shade900
                                                        : Colors.blue.shade900,
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
                                                          Colors.blue.shade900),
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
                                                          ? Colors.blue.shade900
                                                          : Colors
                                                              .blue.shade900,
                                                  //  'Details',
                                                  //   style: TextStyle(
                                                  //        color: Colors.blue),
                                                ),
                                              ],
                                            )),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              // fixedSize:
                                              //     Size(double.infinity, 20),
                                              backgroundColor:
                                                  Colors.green.shade100,
                                              side: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.green.shade900),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Pay Due (Lebanese)'),
                                                    content: TextFormField(
                                                      readOnly: true,
                                                      initialValue: (invoice
                                                              .Invoice_Due_LB)
                                                          .toString(),
                                                      keyboardType:
                                                          TextInputType.number,

                                                      //controller: Payment_Ammount,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Enter Payment Ammount'),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              // The user CANNOT close this dialog  by pressing outsite it
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder: (_) {
                                                                return Dialog(
                                                                  // The background color
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        // The loading indicator
                                                                        CircularProgressIndicator(),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        // Some text
                                                                        Text(
                                                                            'Loading')
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                          rechargeInvoiceHistoryController.PayInvDue(
                                                                  invoice.Invoice_id
                                                                      .toString(),
                                                                  invoice.Invoice_Due_LB
                                                                      .toString(),
                                                                  invoice
                                                                      .Invoice_Date)
                                                              .then((value) => showToast(
                                                                  rechargeInvoiceHistoryController
                                                                      .result2))
                                                              .then((value) =>
                                                                  rechargeInvoiceHistoryController.isDataFetched =
                                                                      false)
                                                              .then((value) =>
                                                                  rechargeInvoiceHistoryController
                                                                      .fetchrechargeInvoice())
                                                              .then((value) =>
                                                                  Navigator.of(context)
                                                                      .pop())
                                                              .then((value) => Navigator.of(context).pop());

                                                          Payment_Ammount
                                                              .clear();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Pay',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .green.shade900),
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
                                                          : Colors
                                                              .green.shade900,
                                                ),
                                              ],
                                            )),
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
                                  'Total Due:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(
                                              rechargeInvoiceHistoryController
                                                  .totaldue_all.value)
                                          .toString() +
                                      '\$',
                                  style: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.normal),
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
