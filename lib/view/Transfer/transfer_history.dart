// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/transfer_history_controller.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/transfer_history_model.dart';
import 'package:fixnshop_admin/view/Transfer/transfer_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class transferHistory extends StatelessWidget {
  transferHistory({super.key});

  final TransferHistoryController transferHistoryController =
      Get.find<TransferHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    // transferHistoryController.reset();

    // transferHistoryController.CalTotal();
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
                                transferHistoryController.transfers.refresh();
                              },
                              decoration: InputDecoration(
                                labelText: 'Search by ID',
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
                  //                   groupValue: transferHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Store.value = 'this';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Store.value = 'other';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Store.value = 'all';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Sold.value = 'No';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Sold.value = 'Yes';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Sold.value = 'all';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Condition.value = 'New';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Condition.value = 'Used';
                  //                     transferHistoryController.searchPhones(
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
                  //                   groupValue: transferHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     transferHistoryController.Condition.value = 'all';
                  //                     transferHistoryController.searchPhones(
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
                      final List<TransferHistoryModel> filteredTransfers =
                          transferHistoryController.searchTransfer(
                        FilterQuery.text,
                      );
                      if (transferHistoryController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (transferHistoryController.transfers.isEmpty) {
                        return Center(
                            child: Text('No Transfers Yet In This Store ! '));
                      } else if (filteredTransfers.length == 0) {
                        return Center(
                            child: Text('No Transfers Yet In This Store ! '));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredTransfers.length,
                          itemBuilder: (context, index) {
                            final TransferHistoryModel transfer =
                                filteredTransfers[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 10, 25, 10),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#' +
                                              transfer.Transfer_id.toString() +
                                              ' || ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        Text(
                                          transfer.Transfer_Date
                                          // +
                                          // ' -- ' +
                                          // transfer.phone_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          ' ' + Format(transfer.Transfer_Time)
                                          // +
                                          // ' -- ' +
                                          // transfer.phone_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'From : ' +
                                              transfer.Transfer_FStore_Name +
                                              ' Store'
                                          // +
                                          // ' -- ' +
                                          // transfer.phone_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          'To : ' +
                                              transfer.Transfer_TStore_Name +
                                              ' Store'
                                          // +
                                          // ' -- ' +
                                          // transfer.phone_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
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
                                              OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize: Size(
                                                        double.maxFinite, 20),
                                                    side: BorderSide(
                                                      width: 2.0,
                                                      color:
                                                          Colors.green.shade900,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        TransferHistoryItems(
                                                          Transfer_id: transfer
                                                                  .Transfer_id
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
                                                            color: Colors.green
                                                                .shade900),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_circle_right_rounded,
                                                        color: Colors
                                                            .green.shade900,
                                                        //  'Details',
                                                        //   style: TextStyle(
                                                        //        color: Colors.red),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
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
