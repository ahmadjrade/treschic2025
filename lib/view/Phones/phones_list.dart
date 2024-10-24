// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/transfer_controller.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/view/Phones/phone_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';

class PhonesList extends StatefulWidget {
  bool isTransfer;
  PhonesList({super.key, required this.isTransfer});

  @override
  State<PhonesList> createState() => _PhonesListState();
}

class _PhonesListState extends State<PhonesList> {
  final PhoneController phoneController = Get.find<PhoneController>();

  final BarcodeController barcodeController = Get.find<BarcodeController>();

  TextEditingController Phone_Name = TextEditingController();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final InvoiceController invoiceController = Get.find<InvoiceController>();
  final TransferController transferController = Get.find<TransferController>();

  RxString Username = ''.obs;
  bool isVisible = false;

  Future<void> set() async {
    Phone_Name.text = barcodeController.barcode3.value;
    phoneController.searchPhones(Phone_Name.text, Username.value);
    phoneController.phones.refresh();
  }

  int Val = 0;

  bool isSupplier(sup_id) {
    if (sup_id != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Username.value != 'admin') {
      phoneController.Condition.value = 'all';
      phoneController.Store.value = 'this';
      phoneController.Sold.value = 'No';
    } else {
      phoneController.Condition.value = 'all';
      phoneController.Store.value = 'all';
      phoneController.Sold.value = 'No';
    }

    Username = sharedPreferencesController.username;
    phoneController.CalTotal();
    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText));
      // Show a snackbar or any other feedback that the text has been copied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone Phone_IMEI copied to clipboard'),
        ),
      );
    }

    String Format(time24Hour) {
      String time8Hour = '';
      DateTime parsedTime = DateFormat.Hms().parse(time24Hour);

      // Format the parsed time into 8-hour time with AM/PM
      time8Hour = DateFormat('h:mm a').format(parsedTime);
      return time8Hour;
    }

    // phoneController.fetchphones();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Phones List'),
          Row(
            children: [
              IconButton(
                color: Colors.deepPurple,
                icon: Icon(isVisible
                    ? Icons.filter_alt_off_outlined
                    : Icons.filter_list_alt),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  phoneController.isDataFetched = false;
                  phoneController.fetchphones();
                  // categoryController.f =false;
                  // categoryController.fetchcategories();
                },
                icon: Icon(CupertinoIcons.refresh),
              ),
            ],
          ),
        ],
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Obx(() {
                          Phone_Name.text = barcodeController.barcode3.value;
                          return Expanded(
                            child: TextField(
                              controller: Phone_Name,
                              onChanged: (query) {
                                phoneController.phones.refresh();
                              },
                              decoration: InputDecoration(
                                labelText: 'Search by Phone Name or Phone_IMEI',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: IconButton(
                            icon: Icon(Icons.qr_code_scanner_rounded),
                            color: Colors.black,
                            onPressed: () {
                              barcodeController
                                  .scanBarcodeSearch()
                                  .then((value) => set());
                            },
                          ),
                        ),
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

                  Obx(
                    () {
                      return Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                // Text(
                                //   'Condition ? ',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                                Expanded(
                                  child: RadioListTile(
                                    title: Column(
                                      children: [
                                        Text(
                                          Username.value.toUpperCase() +
                                              ' Store',
                                          style: TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    ),
                                    value: 'this',
                                    groupValue: phoneController.Store.value,
                                    onChanged: (value) {
                                      phoneController.Store.value = 'this';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   // havePassword = false;
                                      //   Condition = value.toString();
                                      //   // Password.text = 'No Password';
                                      // });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    //selected: true,
                                    title: Text(
                                      'OTHER STORE',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'other',
                                    groupValue: phoneController.Store.value,
                                    onChanged: (value) {
                                      phoneController.Store.value = 'other';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   //havePassword = true;
                                      //   // Password.clear();
                                      //   Condition = value.toString();
                                      // });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: Text(
                                      'all',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'all',
                                    groupValue: phoneController.Store.value,
                                    onChanged: (value) {
                                      phoneController.Store.value = 'all';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   // havePassword = false;
                                      //   Condition = value.toString();
                                      //   // Password.text = 'No Password';
                                      // });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                // Text(
                                //   'Condition ? ',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),

                                Expanded(
                                  child: RadioListTile(
                                    title: Text(
                                      'Listed',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'No',
                                    groupValue: phoneController.Sold.value,
                                    onChanged: (value) {
                                      phoneController.Sold.value = 'No';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   // havePassword = false;
                                      //   Condition = value.toString();
                                      //   // Password.text = 'No Password';
                                      // });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    //selected: true,
                                    title: Text(
                                      'SOLD',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'Yes',
                                    groupValue: phoneController.Sold.value,
                                    onChanged: (value) {
                                      phoneController.Sold.value = 'Yes';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   //havePassword = true;
                                      //   // Password.clear();
                                      //   Condition = value.toString();
                                      // });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: Text(
                                      'all',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'all',
                                    groupValue: phoneController.Sold.value,
                                    onChanged: (value) {
                                      phoneController.Sold.value = 'all';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   // havePassword = false;
                                      //   Condition = value.toString();
                                      //   // Password.text = 'No Password';
                                      // });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                // Text(
                                //   'Condition ? ',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),

                                Expanded(
                                  child: RadioListTile(
                                    title: Text(
                                      'New',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'New',
                                    groupValue: phoneController.Condition.value,
                                    onChanged: (value) {
                                      phoneController.Condition.value = 'New';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   // havePassword = false;
                                      //   Condition = value.toString();
                                      //   // Password.text = 'No Password';
                                      // });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    //selected: true,
                                    title: Text(
                                      'Used',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'Used',
                                    groupValue: phoneController.Condition.value,
                                    onChanged: (value) {
                                      phoneController.Condition.value = 'Used';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   //havePassword = true;
                                      //   // Password.clear();
                                      //   Condition = value.toString();
                                      // });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    title: Text(
                                      'all',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                    value: 'all',
                                    groupValue: phoneController.Condition.value,
                                    onChanged: (value) {
                                      phoneController.Condition.value = 'all';
                                      phoneController.searchPhones(
                                          Phone_Name.text, Username.value);

                                      // setState(() {
                                      //   // havePassword = false;
                                      //   Condition = value.toString();
                                      //   // Password.text = 'No Password';
                                      // });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Obx(
                    () {
                      final List<PhoneModel> filteredCategories =
                          phoneController.searchPhones(
                              Phone_Name.text, Username.value);
                      if (phoneController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (filteredCategories.isEmpty) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('No phones Yet ! Add Some ')]);
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            final PhoneModel phone = filteredCategories[index];
                            return GestureDetector(
                              onDoubleTap: () {
                                invoiceController
                                    .fetchProduct(phone.Phone_IMEI);
                              },
                              onLongPress: () {
                                copyToClipboard(phone.Phone_IMEI);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '#' +
                                                    phone.Phone_id.toString() +
                                                    ' ' +
                                                    phone.Brand_Name +
                                                    ' ' +
                                                    phone.Phone_Name +
                                                    ' ' +
                                                    phone.Color +
                                                    ' ' +
                                                    phone.Phone_Capacity +
                                                    ' ' +
                                                    phone.Phone_Condition,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'IMEI: ' + phone.Phone_IMEI,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Sell Price: ' +
                                                  phone.Sell_Price.toString() +
                                                  '\$',
                                              style: TextStyle(
                                                  color: Colors.green.shade900,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: sharedPreferencesController
                                              .isAdmin(),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Purchase Price: ' +
                                                        phone.Phone_Price
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.red.shade900,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Sell Price: ' +
                                                        phone.Sell_Price
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.red.shade900,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible: isSupplier(
                                                    phone.Supplier_id),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Bought From Supplier : #' +
                                                            phone.Supplier_id
                                                                .toString() +
                                                            ' | ${phone.Supplier_Name} | ${phone.Supplier_Number}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: !isSupplier(
                                                    phone.Supplier_id),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Bought From Customer: #' +
                                                            phone.Cus_id
                                                                .toString() +
                                                            ' | ${phone.Cus_Name} | ${phone.Cus_Number}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    sharedPreferencesController
                                                        .isAdmin(),
                                                child: IconButton(
                                                    onPressed: () {
                                                      Get.to(() => PhoneEdit(
                                                            Phone_id:
                                                                phone.Phone_id,
                                                            Phone_Name: phone
                                                                .Phone_Name,
                                                            IMEI: phone
                                                                .Phone_IMEI,
                                                            Cost_Price: phone
                                                                .Phone_Price,
                                                            Sell_Price: phone
                                                                .Sell_Price!,
                                                            Condition: phone
                                                                .Phone_Condition,
                                                            Capacity: phone
                                                                .Phone_Capacity,
                                                            Color: phone
                                                                .Phone_Color_id,
                                                          ));
                                                    },
                                                    icon: Icon(Icons.edit,
                                                        color: phoneController
                                                                .issold(phone
                                                                    .isSold)
                                                            ? Colors.black
                                                            : Colors.red)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red.shade100,
                                                    side: BorderSide(
                                                        width: 2.0,
                                                        color: Colors
                                                            .red.shade100),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(() => PhoneEdit(
                                                          Phone_id:
                                                              phone.Phone_id,
                                                          Phone_Name:
                                                              phone.Phone_Name,
                                                          IMEI:
                                                              phone.Phone_IMEI,
                                                          Cost_Price:
                                                              phone.Phone_Price,
                                                          Sell_Price:
                                                              phone.Sell_Price!,
                                                          Condition: phone
                                                              .Phone_Condition,
                                                          Capacity: phone
                                                              .Phone_Capacity,
                                                          Color: phone
                                                              .Phone_Color_id,
                                                        ));
                                                  },
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red.shade900),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            widget.isTransfer
                                                ? Expanded(
                                                    child: OutlinedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade100,
                                                          side: BorderSide(
                                                              width: 2.0,
                                                              color: Colors
                                                                  .green
                                                                  .shade100),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          transferController
                                                              .fetchProduct(phone
                                                                  .Phone_IMEI);
                                                        },
                                                        child: Text(
                                                          'Add To Transfer',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .shade900),
                                                        )),
                                                  )
                                                : Expanded(
                                                    child: OutlinedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade100,
                                                          side: BorderSide(
                                                              width: 2.0,
                                                              color: Colors
                                                                  .green
                                                                  .shade100),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          invoiceController
                                                              .fetchProduct(phone
                                                                  .Phone_IMEI);
                                                        },
                                                        child: Text(
                                                          'Add To Invoice',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .shade900),
                                                        )),
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  // leading: Column(
                                  //   children: [
                                  //     Expanded(
                                  //       child: phone.imageUrl != null
                                  //           ? Image.network(phone.imageUrl!)
                                  //           : Placeholder(),
                                  //     ),
                                  //   ],
                                  // ),

                                  // subtitle: Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             'Phone_IMEI:  ' + phone.Phone_IMEI,
                                  //             style: TextStyle(
                                  //                 fontSize: 13,
                                  //                 color: Colors.black),
                                  //           ),
                                  //           Text(
                                  //               'Store: ' +
                                  //                   phone.Username.toUpperCase() +
                                  //                   ' Store',
                                  //               style: TextStyle(
                                  //                   fontSize: 13,
                                  //                   color: Colors.black)),
                                  //           Text(
                                  //             'Sell Phone_Price: ' +
                                  //                 phone.Sell_Price.toString() +
                                  //                 '\$',
                                  //             style: TextStyle(
                                  //                 color: phoneController
                                  //                         .issold(phone.isSold)
                                  //                     ? Colors.black
                                  //                     : Colors.green.shade900),
                                  //           ),
                                  //           Visibility(
                                  //             visible: phoneController
                                  //                 .isadmin(Username.value),
                                  //             child: Text(
                                  //               'Cost Phone_Price: ' +
                                  //                   phone.Phone_Price.toString() +
                                  //                   '\$',
                                  //               style: TextStyle(
                                  //                   color: phoneController
                                  //                           .issold(phone.isSold)
                                  //                       ? Colors.black
                                  //                       : Colors.red.shade900),
                                  //             ),
                                  //           ),
                                  //           Visibility(
                                  //             visible: phoneController
                                  //                 .isadmin(Username.value),
                                  //             child: Text(
                                  //               'Bought From: ' +
                                  //                   phone.Cus_Name! +
                                  //                   ' - ' +
                                  //                   phone.Cus_Number.toString(),
                                  //               style: TextStyle(
                                  //                   color: Colors.black),
                                  //             ),
                                  //           ),
                                  //           Visibility(
                                  //             visible: phoneController
                                  //                 .isadmin(Username.value),
                                  //             child: Text(
                                  //               'Bought at: ' +
                                  //                   phone.Buy_Date +
                                  //                   ' - ' +
                                  //                   Format(phone.Buy_Time),
                                  //               style: TextStyle(
                                  //                   color: Colors.black),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     Visibility(
                                  //       visible: phoneController
                                  //           .isadmin(Username.value),
                                  //       child: IconButton(
                                  //           onPressed: () {
                                  //             Get.to(() => PhoneEdit(
                                  //                   Phone_id: phone.Phone_id,
                                  //                   Phone_Name: phone.Phone_Name,
                                  //                   IMEI: phone.Phone_IMEI,
                                  //                   Cost_Price: phone.Phone_Price,
                                  //                   Sell_Price: phone.Sell_Price!,
                                  //                   Condition:
                                  //                       phone.Phone_Condition,
                                  //                   Capacity:
                                  //                       phone.Phone_Capacity,
                                  //                   Color: phone.Phone_Color_id,
                                  //                 ));
                                  //           },
                                  //           icon: Icon(Icons.edit,
                                  //               color: phoneController
                                  //                       .issold(phone.isSold)
                                  //                   ? Colors.black
                                  //                   : Colors.red)),
                                  //     )
                                  //     // Column(
                                  //     //   children: [
                                  //     //     Text(
                                  //     //       phone.Sell_Phone_Price.toString() + '\$',
                                  //     //       style: TextStyle(
                                  //     //           fontSize: 17,
                                  //     //           color: Colors.green.shade900),
                                  //     //     ),
                                  //     //     Visibility(
                                  //     //       visible:
                                  //     //           phoneController.isadmin(Username.value),
                                  //     //       child: Text(
                                  //     //         phone.Phone_Price.toString() + '\$',
                                  //     //         style: TextStyle(
                                  //     //             fontSize: 17,
                                  //     //             color: Colors.red.shade900),
                                  //     //       ),
                                  //     //     ),
                                  //     //   ],
                                  //     // ),

                                  //     // OutlinedButton(
                                  //     //     onPressed: () {
                                  //     //       // phoneController.SelectedPhone.value = phone;
                                  //     //       //       // subcategoryController.selectedSubCategory.value =
                                  //     //       //       //     null;

                                  //     //       // Get.to(() => PhonesListDetail(
                                  //     //       //       phone_id:
                                  //     //       //           phone.phone_id.toString(),
                                  //     //       //       Phone_Name: phone.Phone_Name,
                                  //     //       //       phone_Color: phone.phone_Color,
                                  //     //       //       phone_LPhone_Price:
                                  //     //       //           phone.phone_LPhone_Price.toString(),
                                  //     //       //       phone_MPhone_Price:
                                  //     //       //           phone.phone_MPhone_Price.toString(),
                                  //     //       //       phone_Code: phone.phone_Code,
                                  //     //       //     ));
                                  //     //     },
                                  //     //     child: Icon(Icons.arrow_right)),
                                  //   ],
                                  // ),
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
                visible: phoneController.isadmin(Username.value),
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Listed Phones Cost:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                phoneController.total.value.toString() + '\$',
                                style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold),
                              )
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
      ),
    );
  }
}
