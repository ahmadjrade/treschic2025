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

class AllRepairs extends StatelessWidget {
  AllRepairs({super.key});

  final RepairsController repairsController = Get.find<RepairsController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    // repairsController.CalTotalall();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          repairsController.repair.refresh();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search by ID,Customer Name or Number',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Obx(
                () {
                  final List<RepairsModel> filteredrepairs =
                      repairsController.searchallRepairs(FilterQuery.text);
                  if (repairsController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (repairsController.repair.isEmpty) {
                    return Center(
                        child: Text('No Repairs Yet In This Store ! '));
                  } else if (filteredrepairs.length == 0) {
                    return Center(
                        child: Text('No Repairs Yet In This Store ! '));
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredrepairs.length <
                                    repairsController.itemsToShow.value
                                ? filteredrepairs.length
                                : repairsController.itemsToShow.value,
                            itemBuilder: (context, index) {
                              final RepairsModel repair =
                                  filteredrepairs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Card(
                                  //color: Colors.green.shade100,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: ExpansionTile(
                                    collapsedTextColor: Colors.black,
                                    textColor: Colors.black,
                                    //backgroundColor: Colors.green.shade100,
                                    title: Row(
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                repair.Repair_Rec_Date +
                                                    ' ' +
                                                    Format(
                                                        repair.Repair_Rec_Time),

                                                // +
                                                // ' -- ' +
                                                // repair.phone_Code,
                                                //  overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              //  fixedSize: Size(double.maxFinite, 20),
                                              backgroundColor:
                                                  Colors.blue.shade100,
                                              side: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.blue.shade100),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => RepairDetails(
                                                  Repair_id: repair.Repair_id
                                                      .toString(),
                                                  Cus_id:
                                                      repair.Cus_id.toString(),
                                                  Cus_Name: repair.Cus_Name,
                                                  Cus_Number: repair.Cus_Number,
                                                  Rec_usd: repair.Received_Money
                                                      .toString(),
                                                  Total_usd: repair.Repair_Price
                                                      .toString(),
                                                  Phone: repair.Phone_Model));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .arrow_circle_right_rounded,
                                                  color: repairsController
                                                          .status(repair
                                                              .Repair_Status)
                                                      ? Colors.blue.shade900
                                                      : Colors.blue.shade900,
                                                  //  'Details',
                                                  //   style: TextStyle(
                                                  //        color: Colors.red),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),

                                    // SizedBox(height: 2,),

                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            50, 0, 20, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: DottedLine(
                                                direction: Axis.horizontal,
                                                alignment: WrapAlignment.center,
                                                lineLength: double.infinity,
                                                lineThickness: 1.0,
                                                dashLength: 2.0,
                                                dashColor: Colors.black,
                                                dashGradient: [
                                                  Colors.black,
                                                  Colors.black
                                                ],
                                                dashRadius: 1.0,
                                                dashGapLength: 1.0,
                                                dashGapColor:
                                                    Colors.transparent,
                                                dashGapGradient: [
                                                  Colors.white,
                                                  Colors.white
                                                ],
                                                dashGapRadius: 1.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Phone IMEI: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              Text(
                                                                repair
                                                                    .Phone_IMEI,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Repair Note: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              Text(
                                                                repair
                                                                    .Repair_Note,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Repair Total US:  ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade900,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              Text(
                                                                addCommasToNumber(
                                                                            repair.Repair_Price)
                                                                        .toString() +
                                                                    '\$',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade900),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Repair Received US:  ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              Text(
                                                                addCommasToNumber(
                                                                            repair.Received_Money)
                                                                        .toString() +
                                                                    '\$',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
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
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        if (repairsController.itemsToShow.value <
                            filteredrepairs.length)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade100,
                                side: BorderSide(
                                  width: 2.0,
                                  color: Colors.green.shade100,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: () {
                                repairsController.itemsToShow.value +=
                                    20; // Increase the observable value
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Show More',
                                    style:
                                        TextStyle(color: Colors.green.shade900),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_circle_right_rounded,
                                    color: Colors.green.shade900,
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
                                  'repair Total US:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(
                                              repairsController.total_all.value)
                                          .toString() +
                                      '\$',
                                  style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'repair Recieved US:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(repairsController
                                              .totalrecusd_all.value)
                                          .toString() +
                                      '\$',
                                  style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'repair Recieved LB:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(repairsController
                                              .totalreclb_all.value)
                                          .toString() +
                                      'LL',
                                  style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'repair Recieved TOTAL:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(repairsController
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'repair Due US:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(repairsController
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
          ],
        ),
      ),
    );
  }
}
