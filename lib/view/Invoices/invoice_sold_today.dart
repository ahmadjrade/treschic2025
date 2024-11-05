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

class InvoiceSoldToday extends StatelessWidget {
  InvoiceSoldToday({super.key});

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
    // invoiceDetailController.reset();

    invoiceDetailController.CalTotal();
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
                              invoiceDetailController.invoice_detail.refresh();
                            },
                            decoration: InputDecoration(
                              labelText: 'Search by ID,Customer Name or Number',
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
                //                   groupValue: invoiceDetailController.Store.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Store.value = 'this';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Store.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Store.value = 'other';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Store.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Store.value = 'all';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Sold.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Sold.value = 'No';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Sold.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Sold.value = 'Yes';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Sold.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Sold.value = 'all';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Condition.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Condition.value = 'New';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Condition.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Condition.value = 'Used';
                //                     invoiceDetailController.searchPhones(
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
                //                   groupValue: invoiceDetailController.Condition.value,
                //                   onChanged: (value) {
                //                     invoiceDetailController.Condition.value = 'all';
                //                     invoiceDetailController.searchPhones(
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
                    final List<InvoiceHistoryModel> filteredinvoices =
                        invoiceDetailController.SearchInvoices(
                      FilterQuery.text,
                    );
                    if (invoiceDetailController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (invoiceDetailController.invoice_detail.isEmpty) {
                      return Center(
                          child: Text('No Items Sold Yet In This Store ! '));
                    } else if (filteredinvoices.length == 0) {
                      return Center(
                          child: Text('No Items Sold Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final InvoiceHistoryModel invoice =
                              filteredinvoices[index];
                          return Card(
                            color: ispaid(invoice.isPaid),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            //     padding: EdgeInsets.all(35),
                            // alignment: Alignment.center,
                            child: ExpansionTile(
                              collapsedTextColor: Colors.black,
                              textColor: Colors.black,
                              backgroundColor: ispaid(invoice.isPaid),
                              //   collapsedBackgroundColor: Colors.white,
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    invoice.Product_Quantity.toString() +
                                        ' PCS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    'TP: ' +
                                        invoice.product_TP.toString() +
                                        '\$',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.green.shade900),
                                  ),
                                ],
                              ),
                              title: Text(
                                '#' +
                                    invoice.Invoice_Detail_id.toString() +
                                    ' || ' +
                                    invoice.Product_Name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: Column(
                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Visibility(
                                          //   visible: true,
                                          //   child: IconButton(
                                          //       color: Colors.red,
                                          //       onPressed: () {
                                          //         if (double.tryParse(widget
                                          //                 .Invoice_Due_US) ==
                                          //             0) {
                                          //           showDialog(
                                          //               // The user CANNOT close this dialog  by pressing outsite it
                                          //               barrierDismissible: false,
                                          //               context: context,
                                          //               builder: (_) {
                                          //                 return Dialog(
                                          //                   // The background color
                                          //                   backgroundColor:
                                          //                       Colors.white,
                                          //                   child: Padding(
                                          //                     padding:
                                          //                         const EdgeInsets
                                          //                             .symmetric(
                                          //                             vertical:
                                          //                                 20),
                                          //                     child: Column(
                                          //                       mainAxisSize:
                                          //                           MainAxisSize
                                          //                               .min,
                                          //                       children: [
                                          //                         // The loading indicator
                                          //                         CircularProgressIndicator(),
                                          //                         SizedBox(
                                          //                           height: 15,
                                          //                         ),
                                          //                         // Some text
                                          //                         Text('Loading')
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 );
                                          //               });
                                          //           invoiceDetailController.DeleteInvItem(
                                          //                   invoice.Invoice_Detail_id
                                          //                       .toString())
                                          //               .then((value) => showToast(
                                          //                   invoiceDetailController
                                          //                       .result2))
                                          //               .then((value) =>
                                          //                   invoiceDetailController
                                          //                           .isDataFetched =
                                          //                       false)
                                          //               .then((value) =>
                                          //                   invoiceDetailController
                                          //                       .fetchinvoicesdetails)
                                          //               .then((value) =>
                                          //                   Navigator.of(context)
                                          //                       .pop());
                                          //         } else {
                                          //           showToast(
                                          //               'Invoice Due Must Be 0');
                                          //         }
                                          //       },
                                          //       icon: Icon(Icons.delete)),
                                          // ),
                                        ],
                                      ),
                                      Text('Product Code: ' +
                                          invoice.Product_Code),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('Product Color: ' +
                                          invoice.Product_Color),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Unit Price: ' +
                                              invoice.product_UP.toString() +
                                              '\$'),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(' | Total Price: ' +
                                              invoice.product_TP.toString() +
                                              '\$'),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 25,
                                      ),
                                      // Text('id' + invoice.PD_id.toString()),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),

                                      // Text('Total Price of Treatment:  ${treatments.!}\$ '),
                                    ],
                                  ),
                                )
                              ],
                              //  subtitle: Text(invoice.Product_Brand),
                              // trailing: OutlinedButton(
                              //   onPressed: () {

                              //     // productController.SelectedPhone.value = invoice;
                              //     //       // product_detailsController.selectedproduct_details.value =
                              //     //       //     null;

                              //               Get.to(() => InvoiceTodayItems(Invoice_id: invoice.Invoice_id.toString(), Customer_Name: invoice.Customer_Name,Customer_Number: invoice.Customer_Number,));
                              //   },
                              //   child: Text('Select')),
                              // // Add more properties as needed
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
            Column(
              children: [
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
                                      'Invoices Total US:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      addCommasToNumber(invoiceDetailController
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
                SizedBox(
                  height: 14,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
