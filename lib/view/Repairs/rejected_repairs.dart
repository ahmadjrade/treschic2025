// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:dotted_line/dotted_line.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/repairs_model.dart';
import 'package:fixnshop_admin/view/Repairs/repair_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RejectedRepairs extends StatelessWidget {
  RejectedRepairs({super.key});

  final RepairsController repairsController = Get.find<RepairsController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    // repairsController.clearSelectedCat();
    // repairsController.reset();

    // repairsController.CalTotal();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Obx(() {
                    FilterQuery.text = barcodeController.barcode3.value;
                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                                repairsController.repair.refresh();
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    FilterQuery.clear();
                                    repairsController.repair.refresh();
                                  },
                                ),
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: 'Search By Phone,Name or Number',
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                          )),
                    ));
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Obx(
                () {
                  final List<RepairsModel> filteredrepairs =
                      repairsController.searchRejectedRepairs(
                    FilterQuery.text,
                  );
                  if (repairsController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (repairsController.repair.isEmpty) {
                    return Center(
                        child: Text('No Repairs Yet In This Store ! '));
                  } else if (filteredrepairs.length == 0) {
                    return Center(
                        child: Text('No Repairs Yet In This Store ! '));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredrepairs.length,
                      itemBuilder: (context, index) {
                        final RepairsModel repair = filteredrepairs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              //color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: ListTile(
                              //color: Colors.green.shade100,
                              // margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              title: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                    // collapsedTextColor: Colors.black,
                                    //   textColor: Colors.black,
                                    //backgroundColor: Colors.green.shade100,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '#' +
                                                      repair.Repair_id
                                                          .toString() +
                                                      ' ' +
                                                      repair.Cus_Name +
                                                      ' ' +
                                                      repair.Cus_Number +
                                                      '\n' +
                                                      repair.Phone_Model,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Total US: ',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Text(
                                                    addCommasToNumber(repair
                                                                .Repair_Price)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Received:  ',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Text(
                                                    addCommasToNumber(repair
                                                                .Received_Money)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  repair.Repair_Rec_Date +
                                                                      ' ' +
                                                                      Format(repair
                                                                          .Repair_Rec_Time),

                                                                  // +
                                                                  // ' -- ' +
                                                                  // repair.phone_Code,
                                                                  //  overflow: TextOverflow.fade,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          11),
                                                                ),
                                                                Text(
                                                                  'IMEI: ' +
                                                                      repair
                                                                          .Phone_IMEI,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'Repair Note: ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    Text(
                                                                      repair
                                                                          .Repair_Note,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      //  fixedSize: Size(double.maxFinite, 20),
                                                      backgroundColor:
                                                          Colors.blue.shade100,
                                                      side: BorderSide(
                                                          width: 2.0,
                                                          color: Colors
                                                              .blue.shade900),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.to(() => RepairDetails(
                                                          Repair_id:
                                                              repair.Repair_id
                                                                  .toString(),
                                                          Cus_id: repair.Cus_id
                                                              .toString(),
                                                          Cus_Name:
                                                              repair.Cus_Name,
                                                          Cus_Number:
                                                              repair.Cus_Number,
                                                          Rec_usd: repair
                                                                  .Received_Money
                                                              .toString(),
                                                          Total_usd: repair
                                                                  .Repair_Price
                                                              .toString(),
                                                          Phone: repair
                                                              .Phone_Model,additem: 0,));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Select',
                                                          style: TextStyle(
                                                              color: Colors.blue
                                                                  .shade900),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_right,
                                                          color: repairsController
                                                                  .status(repair
                                                                      .Repair_Status)
                                                              ? Colors
                                                                  .blue.shade900
                                                              : Colors.blue
                                                                  .shade900,
                                                          //  'Details',
                                                          //   style: TextStyle(
                                                          //        color: Colors.red),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ]

                                    // SizedBox(height: 2,),

                                    // controlAffinity: ListTileControlAffinity.leading,

                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
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
                                    addCommasToNumber(repairsController
                                                .total_yday.value)
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
                                    addCommasToNumber(repairsController
                                                .totalrec_yday.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))));
              }),
            ),
            SizedBox(
              height: 14,
            )
          ],
        ),
      ),
    );
  }
}
