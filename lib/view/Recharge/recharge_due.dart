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
          Text('Recharge Invoice Due'),
          IconButton(
              onPressed: () {
                rechargeInvoiceHistoryController.reset();
                rechargeInvoiceHistoryController.isDataFetched = false;
                rechargeInvoiceHistoryController.fetchrechargeInvoice();
              },
              icon: Icon(Icons.refresh))
        ],
      ))),
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Val == 0;
                  //     // categoryController.f =false;
                  //     // categoryController.fetchcategories();
                  //   },
                  //   child: Icon(CupertinoIcons.list_bullet),
                  // ),

                  // Obx(
                  //   () {
                  //     return Visibility(
                  //       visible: true,
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               SizedBox(
                  //                 width: 10,
                  //               ),
                  //               // Text(
                  //               //   'Condition ? ',
                  //               //   style: TextStyle(
                  //               //     fontSize: 14,
                  //               //     fontWeight: FontWeight.w600,
                  //               //   ),
                  //               // ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   title: Column(
                  //                     children: [
                  //                       Text(
                  //                         Username.value.toUpperCase() +
                  //                             ' Store',
                  //                         style: TextStyle(fontSize: 8),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   value: 'this',
                  //                   groupValue: rechargeInvoiceHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Store.value = 'this';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   // havePassword = false;
                  //                     //   Condition = value.toString();
                  //                     //   // Password.text = 'No Password';
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   //selected: true,
                  //                   title: Text(
                  //                     'OTHER STORE',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'other',
                  //                   groupValue: rechargeInvoiceHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Store.value = 'other';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   //havePassword = true;
                  //                     //   // Password.clear();
                  //                     //   Condition = value.toString();
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   title: Text(
                  //                     'all',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'all',
                  //                   groupValue: rechargeInvoiceHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Store.value = 'all';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   // havePassword = false;
                  //                     //   Condition = value.toString();
                  //                     //   // Password.text = 'No Password';
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               SizedBox(
                  //                 width: 10,
                  //               ),
                  //               // Text(
                  //               //   'Condition ? ',
                  //               //   style: TextStyle(
                  //               //     fontSize: 14,
                  //               //     fontWeight: FontWeight.w600,
                  //               //   ),
                  //               // ),

                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   title: Text(
                  //                     'Listed',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'No',
                  //                   groupValue: rechargeInvoiceHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Sold.value = 'No';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   // havePassword = false;
                  //                     //   Condition = value.toString();
                  //                     //   // Password.text = 'No Password';
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   //selected: true,
                  //                   title: Text(
                  //                     'SOLD',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'Yes',
                  //                   groupValue: rechargeInvoiceHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Sold.value = 'Yes';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   //havePassword = true;
                  //                     //   // Password.clear();
                  //                     //   Condition = value.toString();
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   title: Text(
                  //                     'all',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'all',
                  //                   groupValue: rechargeInvoiceHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Sold.value = 'all';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   // havePassword = false;
                  //                     //   Condition = value.toString();
                  //                     //   // Password.text = 'No Password';
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               SizedBox(
                  //                 width: 10,
                  //               ),
                  //               // Text(
                  //               //   'Condition ? ',
                  //               //   style: TextStyle(
                  //               //     fontSize: 14,
                  //               //     fontWeight: FontWeight.w600,
                  //               //   ),
                  //               // ),

                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   title: Text(
                  //                     'New',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'New',
                  //                   groupValue: rechargeInvoiceHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Condition.value = 'New';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   // havePassword = false;
                  //                     //   Condition = value.toString();
                  //                     //   // Password.text = 'No Password';
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   //selected: true,
                  //                   title: Text(
                  //                     'Used',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'Used',
                  //                   groupValue: rechargeInvoiceHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Condition.value = 'Used';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   //havePassword = true;
                  //                     //   // Password.clear();
                  //                     //   Condition = value.toString();
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: RadioListTile(
                  //                   title: Text(
                  //                     'all',
                  //                     style: TextStyle(fontSize: 8),
                  //                   ),
                  //                   value: 'all',
                  //                   groupValue: rechargeInvoiceHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     rechargeInvoiceHistoryController.Condition.value = 'all';
                  //                     rechargeInvoiceHistoryController.searchPhones(
                  //                         FilterQuery.text, Username.value);

                  //                     // setState(() {
                  //                     //   // havePassword = false;
                  //                     //   Condition = value.toString();
                  //                     //   // Password.text = 'No Password';
                  //                     // });
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () {
                      final List<InvoiceModel> filteredinvoices =
                          rechargeInvoiceHistoryController.searchDueRecharge  (
                        FilterQuery.text,
                      );
                      if (rechargeInvoiceHistoryController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (rechargeInvoiceHistoryController
                          .recharge_invoices.isEmpty) {
                        return Center(
                            child:
                                Text('No Due invoices Yet In This Store ! '));
                      } else if (filteredinvoices.length == 0) {
                        return Center(
                            child:
                                Text('No Due invoices Yet In This Store ! '));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredinvoices.length,
                          itemBuilder: (context, index) {
                            final InvoiceModel invoice =
                                filteredinvoices[index];
                            return Container(
                              //  width: double.infinity,
                              //   height: 140.0,
                              color: rechargeInvoiceHistoryController
                                      .ispaid(invoice.isPaid)
                                  ? Colors.grey.shade300
                                  : Colors.red.shade100,
                              margin: EdgeInsets.fromLTRB(14, 0, 14, 10),
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
                                              fontSize: 17),
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
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          ' ' + Format(invoice.Invoice_Time)
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'invoice Total US:  ' +
                                                        addCommasToNumber(invoice
                                                                .Invoice_Total_Usd)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                  Text(
                                                    'invoice Total LL:  ' +
                                                        addCommasToNumber(invoice
                                                                .Invoice_Total_Lb)
                                                            .toString() +
                                                        ' LB',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                  Text(
                                                    'invoice Rec US:  ' +
                                                        addCommasToNumber(invoice
                                                                .Invoice_Rec_Usd)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .green.shade900),
                                                  ),
                                                  Text(
                                                    'invoice Rec LL:  ' +
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
                                                    'invoice Due US:  ' +
                                                        addCommasToNumber(invoice
                                                                .Invoice_Due_USD)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .red.shade900),
                                                  ),
                                                  Text(
                                                    'invoice Due LL:  ' +
                                                        addCommasToNumber(invoice
                                                                .Invoice_Due_LB)
                                                            .toString() +
                                                        ' LB',
                                                    style: TextStyle(
                                                        fontSize: 14,
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
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // fixedSize:
                                                      //     Size(double.infinity, 20),
                                                      backgroundColor:
                                                          rechargeInvoiceHistoryController
                                                                  .ispaid(invoice
                                                                      .isPaid)
                                                              ? Colors.green
                                                                  .shade900
                                                              : Colors
                                                                  .red.shade900,
                                                      side: BorderSide(
                                                        width: 2.0,
                                                        color: rechargeInvoiceHistoryController
                                                                .ispaid(invoice
                                                                    .isPaid)
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors
                                                                .red.shade900,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          RechargeHistoryItems(
                                                            Recharge_id: invoice
                                                                    .Invoice_id
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
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Select',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_circle_right_rounded,
                                                          color: rechargeInvoiceHistoryController
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
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: OutlinedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // fixedSize:
                                                      //     Size(double.infinity, 20),
                                                      backgroundColor:
                                                          Colors.green.shade900,
                                                      side: BorderSide(
                                                          width: 2.0,
                                                          color: Colors
                                                              .green.shade900),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Pay Due (Lebanese)'),
                                                            content:
                                                                TextFormField(
                                                              readOnly: true,
                                                              initialValue: (invoice
                                                                      .Invoice_Due_LB)
                                                                  .toString(),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,

                                                              //controller: Payment_Ammount,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          'Enter Payment Ammount'),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                      // The user CANNOT close this dialog  by pressing outsite it
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) {
                                                                        return Dialog(
                                                                          // The background color
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 20),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
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
                                                                  rechargeInvoiceHistoryController.PayInvDue(
                                                                          invoice.Invoice_id
                                                                              .toString(),
                                                                          invoice.Invoice_Due_LB
                                                                              .toString())
                                                                      .then((value) =>
                                                                          showToast(
                                                                              rechargeInvoiceHistoryController
                                                                                  .result2))
                                                                      .then((value) => rechargeInvoiceHistoryController
                                                                              .isDataFetched =
                                                                          false)
                                                                      .then((value) =>
                                                                          rechargeInvoiceHistoryController
                                                                              .fetchrechargeInvoice())
                                                                      .then((value) =>
                                                                          Navigator.of(context)
                                                                              .pop())
                                                                      .then((value) =>
                                                                          Navigator.of(context)
                                                                              .pop());

                                                                  // productDetailController.UpdateProductQty(
                                                                  //         product.PD_id
                                                                  //             .toString(),
                                                                  //         New_Qty.text)
                                                                  //     .then((value) => showToast(
                                                                  //         productDetailController
                                                                  //             .result2))
                                                                  //     .then((value) =>
                                                                  //         productDetailController
                                                                  //                 .isDataFetched =
                                                                  //             false)
                                                                  //     .then((value) =>
                                                                  //         productDetailController
                                                                  //             .fetchproductdetails())
                                                                  //     .then((value) =>
                                                                  //         Navigator.of(context)
                                                                  //             .pop())
                                                                  //     .then((value) =>
                                                                  //         Navigator.of(context).pop());

                                                                  Payment_Ammount
                                                                      .clear();

                                                                  // Do something with the text, e.g., save it
                                                                  //  String enteredText = _textEditingController.text;
                                                                  //  print('Entered text: $enteredText');
                                                                  // Close the dialog
                                                                },
                                                                child:
                                                                    Text('OK'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      // Get.to(
                                                      //     () => invoiceHistoryItems(
                                                      //           invoice_id:
                                                      //               invoice.invoice_id
                                                      //                   .toString(),
                                                      //                   Customer_id: invoice.Cus_id.toString(),
                                                      //           Customer_Name:
                                                      //               invoice.Cus_Name
                                                      //                   .toString(),
                                                      //           Customer_Number:
                                                      //               invoice.Cus_Number
                                                      //                   .toString(),
                                                      //           invoice_Total_US:
                                                      //               invoice.invoice_Total_Usd
                                                      //                   .toString(),
                                                      //           invoice_Rec_US: invoice
                                                      //                   .invoice_Rec_Usd
                                                      //               .toString(),
                                                      //           invoice_Due_US: invoice
                                                      //                   .invoice_Due_USD
                                                      //               .toString(),
                                                      //         ));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Pay',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_circle_right_rounded,
                                                          color: rechargeInvoiceHistoryController
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
                                              ),
                                            ],
                                          ),

                                          // Text(
                                          //     'Store: ' +
                                          //         invoice.Username.toUpperCase() +
                                          //         ' Store',
                                          //     style: TextStyle(
                                          //         fontSize: 14,
                                          //         color: Colors.black)),
                                          // Text(
                                          //   'Sell Price: ' +
                                          //       invoice.Sell_Price.toString() +
                                          //       '\$',
                                          //   style: TextStyle(
                                          //       color: rechargeInvoiceHistoryController
                                          //               .issold(invoice.isSold)
                                          //           ? Colors.black
                                          //           : Colors.green.shade900),
                                          // ),
                                          // Visibility(
                                          //   visible: rechargeInvoiceHistoryController
                                          //       .isadmin(Username.value),
                                          //   child: Text(
                                          //     'Cost Price: ' +
                                          //         invoice.Price.toString() +
                                          //         '\$',
                                          //     style: TextStyle(
                                          //         color: rechargeInvoiceHistoryController
                                          //                 .issold(invoice.isSold)
                                          //             ? Colors.black
                                          //             : Colors.red.shade900),
                                          //   ),
                                          // ),
                                          // Visibility(
                                          //   visible: rechargeInvoiceHistoryController
                                          //       .isadmin(Username.value),
                                          //   child: Text(
                                          //     'Bought From: ' +
                                          //         invoice.Cus_Name +
                                          //         ' - ' +
                                          //         invoice.Cus_Number.toString(),
                                          //     style: TextStyle(
                                          //         color: Colors.black),
                                          //   ),
                                          // ),
                                          // Visibility(
                                          //   visible: rechargeInvoiceHistoryController
                                          //       .isadmin(Username.value),
                                          //   child: Text(
                                          //     'Bought at: ' +
                                          //         invoice.Buy_Date +
                                          //         ' - ' +
                                          //         Format(invoice.Buy_Time),
                                          //     style: TextStyle(
                                          //         color: Colors.black),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    // Visibility(
                                    //   visible: rechargeInvoiceHistoryController
                                    //       .isadmin(Username.value),
                                    //   child: IconButton(
                                    //       onPressed: () {
                                    //         Get.to(() => PhoneEdit(
                                    //             Phone_id: invoice.Phone_id,
                                    //             FilterQuery: invoice.FilterQuery,
                                    //             IMEI: invoice.IMEI,
                                    //             Cost_Price: invoice.Price,
                                    //             Sell_Price: invoice.Sell_Price,
                                    //             Condition:
                                    //                 invoice.Phone_Condition,
                                    //             Capacity: invoice.Capacity,
                                    //             Note: invoice.Note,Color: invoice.Color_id,));
                                    //       },
                                    //       icon: Icon(Icons.edit,
                                    //           color: rechargeInvoiceHistoryController
                                    //                   .issold(invoice.isSold)
                                    //               ? Colors.black
                                    //               : Colors.red)),
                                    // )
                                    // Column(
                                    //   children: [
                                    //     Text(
                                    //       invoice.Sell_Price.toString() + '\$',
                                    //       style: TextStyle(
                                    //           fontSize: 17,
                                    //           color: Colors.green.shade900),
                                    //     ),
                                    //     Visibility(
                                    //       visible:
                                    //           rechargeInvoiceHistoryController.isadmin(Username.value),
                                    //       child: Text(
                                    //         invoice.Price.toString() + '\$',
                                    //         style: TextStyle(
                                    //             fontSize: 17,
                                    //             color: Colors.red.shade900),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    // OutlinedButton(
                                    //     onPressed: () {
                                    //       // rechargeInvoiceHistoryController.SelectedPhone.value = invoice;
                                    //       //       // subcategoryController.selectedSubCategory.value =
                                    //       //       //     null;

                                    //       // Get.to(() => PhonesListDetail(
                                    //       //       phone_id:
                                    //       //           invoice.phone_id.toString(),
                                    //       //       FilterQuery: invoice.FilterQuery,
                                    //       //       phone_Color: invoice.phone_Color,
                                    //       //       phone_LPrice:
                                    //       //           invoice.phone_LPrice.toString(),
                                    //       //       phone_MPrice:
                                    //       //           invoice.phone_MPrice.toString(),
                                    //       //       phone_Code: invoice.phone_Code,
                                    //       //     ));
                                    //     },
                                    //     child: Icon(Icons.arrow_right)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'invoices Due US:',
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
                height: 14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
