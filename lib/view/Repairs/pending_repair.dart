// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:dotted_line/dotted_line.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/repairs_model.dart';
import 'package:fixnshop_admin/view/Repairs/repair_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PendingRepairs extends StatelessWidget {
  PendingRepairs({super.key});

  final RepairsController repairsController = Get.find<RepairsController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    repairsController.reset();

    //repairsController.CalTotal();

    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText));
      // Show a snackbar or any other feedback that the text has been copied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Repair IMEI copied to clipboard'),
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
                              repairsController.repair.refresh();
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
                  height: 5,
                ),
        
                Obx(
                  () {
                    final List<RepairsModel> filteredrepairs =
                        repairsController.searchPendingRepairs(
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredrepairs.length,
                        itemBuilder: (context, index) {
                          final RepairsModel repair = filteredrepairs[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Card(
                              // color: repairsController
                              //         .status(repair.Repair_Status)
                              //     ? Colors.green.shade900
                              //     : Colors.orangeAccent.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                    //color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            repair.Cus_Name +
                                                ' ' +
                                                repair.Cus_Number
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '#' + repair.Repair_id.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(height: 2,),
                                      Row(
                                        children: [
                                          Text(
                                            repair.Repair_Rec_Date
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10),
                                          ),
                                          Text(
                                            ' ' +
                                                Format(repair.Repair_Rec_Time)
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10),
                                          ),
                                          Text(
                                            ' || ' +
                                                repair.Username
                                                    .toUpperCase() +
                                                ' Store'
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: DottedLine(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.center,
                                          lineLength: double.infinity,
                                          lineThickness: 2.0,
                                          dashLength: 4.0,
                                          dashColor: Colors.black,
                                          dashGradient: [
                                            Colors.black,
                                            Colors.black
                                          ],
                                          dashRadius: 1.0,
                                          dashGapLength: 1.0,
                                          dashGapColor: Colors.transparent,
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
                                                  CrossAxisAlignment.start,
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
                                                          'Phone Model: ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          repair.Phone_Model,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                      ],
                                                    ),
        
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Phone Issue: ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          repair.Phone_Issue,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Phone IMEI: ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          repair.Phone_IMEI,
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          repair.Repair_Note,
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .blue
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          addCommasToNumber(repair
                                                                      .Repair_Price)
                                                                  .toString() +
                                                              '\$',
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          addCommasToNumber(repair
                                                                      .Received_Money)
                                                                  .toString() +
                                                              '\$',
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                      OutlinedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize:
                                                Size(double.maxFinite, 20),
                                            backgroundColor: Colors.orange.shade600,
                                            side: BorderSide(
                                              width: 2.0,
                                              color: Colors.orange.shade600,
                                            ),
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
                                                color: repairsController
                                                        .status(repair
                                                            .Repair_Status)
                                                    ? Colors.white
                                                    : Colors.white,
                                                //  'Details',
                                                //   style: TextStyle(
                                                //        color: Colors.red),
                                              ),
                                            ],
                                          )),
                                    ],
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
                                  'Repairs Total US:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(
                                              repairsController.total.value)
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
                                  'Repairs Recieved US:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  addCommasToNumber(repairsController
                                              .totalrec.value)
                                          .toString() +
                                      '\$',
                                  style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'repairs Due US:',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       addCommasToNumber(repairsController
                            //                   .totaldue.value)
                            //               .toString() +
                            //           '\$',
                            //       style: TextStyle(
                            //           color: Colors.red.shade900,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
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
