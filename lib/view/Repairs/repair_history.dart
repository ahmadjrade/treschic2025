// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/repairs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RepairHistory extends StatelessWidget {
  RepairHistory({super.key});

  final RepairsController repairsController = Get.find<RepairsController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  @override
  Widget build(BuildContext context) {
    repairsController.reset();

    repairsController.CalTotal();

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
      appBar: AppBar(
          title: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Repairs'),
          IconButton(
              onPressed: () {
                repairsController.isDataFetched = false;
                repairsController.fetchrepairs();
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
                                repairsController.repairs.refresh();
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
                        //   width: 15,
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
                  //               //     fontSize: 15,
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
                  //                   groupValue: repairsController.Store.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Store.value = 'this';
                  //                     repairsController.searchPhones(
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
                  //                   groupValue: repairsController.Store.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Store.value = 'other';
                  //                     repairsController.searchPhones(
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
                  //                   groupValue: repairsController.Store.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Store.value = 'all';
                  //                     repairsController.searchPhones(
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
                  //               //     fontSize: 15,
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
                  //                   groupValue: repairsController.Sold.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Sold.value = 'No';
                  //                     repairsController.searchPhones(
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
                  //                   groupValue: repairsController.Sold.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Sold.value = 'Yes';
                  //                     repairsController.searchPhones(
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
                  //                   groupValue: repairsController.Sold.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Sold.value = 'all';
                  //                     repairsController.searchPhones(
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
                  //               //     fontSize: 15,
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
                  //                   groupValue: repairsController.Condition.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Condition.value = 'New';
                  //                     repairsController.searchPhones(
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
                  //                   groupValue: repairsController.Condition.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Condition.value = 'Used';
                  //                     repairsController.searchPhones(
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
                  //                   groupValue: repairsController.Condition.value,
                  //                   onChanged: (value) {
                  //                     repairsController.Condition.value = 'all';
                  //                     repairsController.searchPhones(
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
                  
                  Obx(
                    () {
                      final List<RepairsModel> filteredrepairs =
                          repairsController.searchrepairs(
                        FilterQuery.text,
                      );
                      if (repairsController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (repairsController.repairs.isEmpty) {
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
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: repairsController.getcolor(repair.Repair_Status),
                                // leading: Column(
                                //   children: [
                                //     Expanded(
                                //       child: repair.imageUrl != null
                                //           ? Image.network(repair.imageUrl!)
                                //           : Placeholder(),
                                //     ),
                                //   ],
                                // ),
                                // onLongPress: () {
                                //   //copyToClipboard(repair.id);
                                // },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Repair ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),Text(
                                            
                                                '#' + repair.Repair_id.toString() +
                                                ' || ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
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
                                                fontSize: 15),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.paid,
                                            color: repairsController
                                                    .ispaid(repair.Repair_Status)
                                                ? Colors.green.shade900
                                                : Colors.red.shade900,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            repair.Repair_Rec_Date
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            ' ' + Format(repair.Repair_Rec_Time)
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            ' || ' +
                                                repair.Username.toUpperCase() +
                                                ' Store'
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            ' || ' +
                                                repair.Repair_Status.toUpperCase() 
                                            // +
                                            // ' -- ' +
                                            // repair.phone_Code,
                                            ,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),Row(
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
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Phone Model: ',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,fontWeight: FontWeight.bold),
                                                        ),Text(
                                                      
                                                          repair.Phone_Model,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    ),
                                                      ],
                                                    ),
                                                     
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Phone Issue: ',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                      
                                                          repair.Phone_Issue,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Phone IMEI: ',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                      
                                                          repair.Phone_IMEI,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Repair Note: ',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,fontWeight: FontWeight.bold),
                                                        ),Text(
                                                              repair.Repair_Note,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,fontWeight: FontWeight.normal),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Repair Total US:  ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .blue.shade900,fontWeight:FontWeight.bold),
                                                        ),Text(
                                                         
                                                              addCommasToNumber(repair
                                                                      .Repair_Price)
                                                                  .toString() +
                                                              '\$',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .blue.shade900),
                                                        ),
                                                      ],
                                                    ),
                                                    // Text(
                                                    //   'repair Total LL:  ' +
                                                    //       addCommasToNumber(repair
                                                    //               .Repair_Price)
                                                    //           .toString() +
                                                    //       ' LB',
                                                    //   style: TextStyle(
                                                    //       fontSize: 13,
                                                    //       color: Colors
                                                    //           .blue.shade900),
                                                    // ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Repair Received US:  ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .green.shade900,fontWeight:FontWeight.bold),
                                                        ),Text(
                                                          
                                                              addCommasToNumber(repair
                                                                      .Received_Money)
                                                                  .toString() +
                                                              '\$',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .green.shade900,fontWeight: FontWeight.normal),
                                                        ),
                                                      ],
                                                    ),
                                                    
                                                    // Text(
                                                    //   'repair Rec LL:  ' +
                                                    //       addCommasToNumber(repair
                                                    //               .Received_Money)
                                                    //           .toString() +
                                                    //       ' LB',
                                                    //   style: TextStyle(
                                                    //       fontSize: 13,
                                                    //       color: Colors
                                                    //           .green.shade900),
                                                    // ),
                                                    // Text(
                                                    //   'repair Due US:  ' +
                                                    //       addCommasToNumber(repair
                                                    //               .repair_Due_USD)
                                                    //           .toString() +
                                                    //       '\$',
                                                    //   style: TextStyle(
                                                    //       fontSize: 13,
                                                    //       color: Colors
                                                    //           .red.shade900),
                                                    // ),
                                                    // Text(
                                                    //   'repair Due LL:  ' +
                                                    //       addCommasToNumber(repair
                                                    //               .repair_Due_LB)
                                                    //           .toString() +
                                                    //       ' LB',
                                                    //   style: TextStyle(
                                                    //       fontSize: 13,
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
                                                                
                                            // Text(
                                            //     'Store: ' +
                                            //         repair.Username.toUpperCase() +
                                            //         ' Store',
                                            //     style: TextStyle(
                                            //         fontSize: 13,
                                            //         color: Colors.black)),
                                            // Text(
                                            //   'Sell Price: ' +
                                            //       repair.Sell_Price.toString() +
                                            //       '\$',
                                            //   style: TextStyle(
                                            //       color: repairsController
                                            //               .issold(repair.isSold)
                                            //           ? Colors.black
                                            //           : Colors.green.shade900),
                                            // ),
                                            // Visibility(
                                            //   visible: repairsController
                                            //       .isadmin(Username.value),
                                            //   child: Text(
                                            //     'Cost Price: ' +
                                            //         repair.Price.toString() +
                                            //         '\$',
                                            //     style: TextStyle(
                                            //         color: repairsController
                                            //                 .issold(repair.isSold)
                                            //             ? Colors.black
                                            //             : Colors.red.shade900),
                                            //   ),
                                            // ),
                                            // Visibility(
                                            //   visible: repairsController
                                            //       .isadmin(Username.value),
                                            //   child: Text(
                                            //     'Bought From: ' +
                                            //         repair.Cus_Name +
                                            //         ' - ' +
                                            //         repair.Cus_Number.toString(),
                                            //     style: TextStyle(
                                            //         color: Colors.black),
                                            //   ),
                                            // ),
                                            // Visibility(
                                            //   visible: repairsController
                                            //       .isadmin(Username.value),
                                            //   child: Text(
                                            //     'Bought at: ' +
                                            //         repair.Buy_Date +
                                            //         ' - ' +
                                            //         Format(repair.Buy_Time),
                                            //     style: TextStyle(
                                            //         color: Colors.black),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      // Visibility(
                                      //   visible: repairsController
                                      //       .isadmin(Username.value),
                                      //   child: IconButton(
                                      //       onPressed: () {
                                      //         Get.to(() => PhoneEdit(
                                      //             Phone_id: repair.Phone_id,
                                      //             FilterQuery: repair.FilterQuery,
                                      //             IMEI: repair.IMEI,
                                      //             Cost_Price: repair.Price,
                                      //             Sell_Price: repair.Sell_Price,
                                      //             Condition:
                                      //                 repair.Phone_Condition,
                                      //             Capacity: repair.Capacity,
                                      //             Note: repair.Note,Color: repair.Color_id,));
                                      //       },
                                      //       icon: Icon(Icons.edit,
                                      //           color: repairsController
                                      //                   .issold(repair.isSold)
                                      //               ? Colors.black
                                      //               : Colors.red)),
                                      // )
                                      // Column(
                                      //   children: [
                                      //     Text(
                                      //       repair.Sell_Price.toString() + '\$',
                                      //       style: TextStyle(
                                      //           fontSize: 17,
                                      //           color: Colors.green.shade900),
                                      //     ),
                                      //     Visibility(
                                      //       visible:
                                      //           repairsController.isadmin(Username.value),
                                      //       child: Text(
                                      //         repair.Price.toString() + '\$',
                                      //         style: TextStyle(
                                      //             fontSize: 17,
                                      //             color: Colors.red.shade900),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                                                
                                      // OutlinedButton(
                                      //     onPressed: () {
                                      //       // repairsController.SelectedPhone.value = repair;
                                      //       //       // subcategoryController.selectedSubCategory.value =
                                      //       //       //     null;
                                                                
                                      //       // Get.to(() => PhonesListDetail(
                                      //       //       phone_id:
                                      //       //           repair.phone_id.toString(),
                                      //       //       FilterQuery: repair.FilterQuery,
                                      //       //       phone_Color: repair.phone_Color,
                                      //       //       phone_LPrice:
                                      //       //           repair.phone_LPrice.toString(),
                                      //       //       phone_MPrice:
                                      //       //           repair.phone_MPrice.toString(),
                                      //       //       phone_Code: repair.phone_Code,
                                      //       //     ));
                                      //     },
                                      //     child: Icon(Icons.arrow_right)),
                                    ],
                                  ),
                                  OutlinedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      fixedSize: Size(double.maxFinite, 20),
                                                      backgroundColor:
                                                         repairsController
                                                    .ispaid(repair.Repair_Status)
                                                ? Colors.green.shade900
                                                : Colors.red.shade900,
                                                      side: BorderSide(
                                                        width: 2.0,
                                                        color: repairsController
                                                                .ispaid(repair
                                                                    .Repair_Status)
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors.red.shade900,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15.0),
                                                      ),
                                                    ),
                                                    onPressed: () {},
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center ,
                                                        children: [
                                                        Text('Select',style: TextStyle(color: Colors.white),),
                                                        SizedBox(width: 10,),
                                                        Icon(
                                                          Icons
                                                              .arrow_circle_right_rounded,
                                                          color: repairsController
                                                                  .ispaid(repair
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
                          padding: const EdgeInsets.all(15.0),
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
