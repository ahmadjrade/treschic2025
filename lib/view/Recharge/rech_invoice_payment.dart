// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/rech_invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/invoice_payment_model.dart';
import 'package:fixnshop_admin/model/rech_invoice_payment_model.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RechInvoicePayment extends StatelessWidget {
  RechInvoicePayment({super.key});

  final RechInvoicePaymentController rechInvoicePaymentController =
      Get.find<RechInvoicePaymentController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    // invoicePaymentController.reset();

    rechInvoicePaymentController.CalTotal();
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
                                rechInvoicePaymentController.payments.refresh();
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
                  //                   groupValue: invoicePaymentController.Store.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Store.value = 'this';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Store.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Store.value = 'other';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Store.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Store.value = 'all';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Sold.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Sold.value = 'No';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Sold.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Sold.value = 'Yes';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Sold.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Sold.value = 'all';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Condition.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Condition.value = 'New';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Condition.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Condition.value = 'Used';
                  //                     invoicePaymentController.searchPhones(
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
                  //                   groupValue: invoicePaymentController.Condition.value,
                  //                   onChanged: (value) {
                  //                     invoicePaymentController.Condition.value = 'all';
                  //                     invoicePaymentController.searchPhones(
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
                      final List<RechInvoicePaymentModel> filteredinvoices =
                          rechInvoicePaymentController.SearchPayments(
                        FilterQuery.text,
                      );
                      if (rechInvoicePaymentController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (rechInvoicePaymentController.payments.isEmpty) {
                        return Center(
                            child: Text('No Payment Yet In This Store ! '));
                      } else if (filteredinvoices.length == 0) {
                        return Center(
                            child: Text('No Payment Yet In This Store ! '));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredinvoices.length,
                          itemBuilder: (context, index) {
                            final RechInvoicePaymentModel invoice =
                                filteredinvoices[index];
                            return Container(
                              //  width: double.infinity,
                              //   height: 140.0,
                              color: Colors.grey.shade300,
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
                                              invoice.Recharge_Invoice_id.toString() +
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
                                          invoice.Payment_Date
                                         
                                          ,
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
                                                        addCommasToNumber(invoice
                                                                .Ammount)
                                                            .toString() +
                                                        ' LL',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                  Text(
                                                    'Invoice Date:  ' +
                                                        (invoice
                                                                .Invoice_Date)
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                 
                                                
                                                  
                                                  // Text(
                                                  //   'Invoice Due US:  ' +
                                                  //       addCommasToNumber(invoice
                                                  //               .Invoice_Due_USD)
                                                  //           .toString() +
                                                  //       '\$',
                                                  //   style: TextStyle(
                                                  //       fontSize: 14,
                                                  //       color: Colors
                                                  //           .red.shade900),
                                                  // ),
                                                  // Text(
                                                  //   'Invoice Due LL:  ' +
                                                  //       addCommasToNumber(invoice
                                                  //               .Invoice_Due_LB)
                                                  //           .toString() +
                                                  //       ' LB',
                                                  //   style: TextStyle(
                                                  //       fontSize: 14,
                                                  //       color: Colors
                                                  //           .red.shade900),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          // OutlinedButton(
                                          //     style: ElevatedButton.styleFrom(
                                          //       fixedSize:
                                          //           Size(double.maxFinite, 20),
                                          //       backgroundColor:
                                          //           invoicePaymentController
                                          //                   .ispaid(
                                          //                       invoice.isPaid)
                                          //               ? Colors.green.shade900
                                          //               : Colors.red.shade900,
                                          //       side: BorderSide(
                                          //         width: 2.0,
                                          //         color:
                                          //             invoicePaymentController
                                          //                     .ispaid(invoice
                                          //                         .isPaid)
                                          //                 ? Colors
                                          //                     .green.shade900
                                          //                 : Colors.red.shade900,
                                          //       ),
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 15.0),
                                          //       ),
                                          //     ),
                                          //     onPressed: () {
                                          //       Get.to(
                                          //           () => InvoiceHistoryItems(
                                          //                 Invoice_id:
                                          //                     invoice.Invoice_id
                                          //                         .toString(),
                                          //                 Customer_id:
                                          //                     invoice.Cus_id
                                          //                         .toString(),
                                          //                 Customer_Name:
                                          //                     invoice.Cus_Name
                                          //                         .toString(),
                                          //                 Customer_Number:
                                          //                     invoice.Cus_Number
                                          //                         .toString(),
                                          //                 Invoice_Total_US:
                                          //                     invoice.Invoice_Total_Usd
                                          //                         .toString(),
                                          //                 Invoice_Rec_US: invoice
                                          //                         .Invoice_Rec_Usd
                                          //                     .toString(),
                                          //                 Invoice_Due_US: invoice
                                          //                         .Invoice_Due_USD
                                          //                     .toString(),
                                          //               ));
                                          //     },
                                          //     child: Row(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.center,
                                          //       children: [
                                          //         Text(
                                          //           'Select',
                                          //           style: TextStyle(
                                          //               color: Colors.white),
                                          //         ),
                                          //         SizedBox(
                                          //           width: 10,
                                          //         ),
                                          //         Icon(
                                          //           Icons
                                          //               .arrow_circle_right_rounded,
                                          //           color:
                                          //               invoicePaymentController
                                          //                       .ispaid(invoice
                                          //                           .isPaid)
                                          //                   ? Colors.white
                                          //                   : Colors.white,
                                          //           //  'Details',
                                          //           //   style: TextStyle(
                                          //           //        color: Colors.red),
                                          //         ),
                                          //       ],
                                          //     )),

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
                                    'Invoices Total:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(rechInvoicePaymentController
                                                .total.value)
                                            .toString() +
                                        ' LL',
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
