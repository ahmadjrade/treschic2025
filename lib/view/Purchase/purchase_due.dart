// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/purchase_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/purchase_model.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PurchaseDue extends StatelessWidget {
  PurchaseDue({super.key});

  final PurchaseHistoryController purchaseHistoryController =
      Get.find<PurchaseHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  TextEditingController Payment_Ammount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // purchaseHistoryController.reset();

    // purchaseHistoryController.CalTotal();
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
          Text('Purchase Due'),
          Container(
            decoration: BoxDecoration(
              //   color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
                onPressed: () {
                  purchaseHistoryController.reset();
                  purchaseHistoryController.isDataFetched = false;
                  purchaseHistoryController.fetchpurchases();
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          purchaseHistoryController.pruchases.refresh();
                        },
                        controller: FilterQuery,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              FilterQuery.clear();
                              //print(formattedDate);
                              purchaseHistoryController.pruchases.refresh();
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
                    final List<PurchaseModel> filteredPurchases =
                        purchaseHistoryController.SearchDuePurchases(
                      FilterQuery.text,
                    );
                    if (purchaseHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (purchaseHistoryController.pruchases.isEmpty) {
                      return Center(
                          child: Text('No Due Purchases Yet In This Store ! '));
                    } else if (filteredPurchases.length == 0) {
                      return Center(
                          child: Text('No Due Purchases Yet In This Store ! '));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredPurchases.length,
                        itemBuilder: (context, index) {
                          final PurchaseModel Purchase =
                              filteredPurchases[index];
                          return Container(
                            decoration: BoxDecoration(
                              //   color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: ListTile(
                              // leading: Column(
                              //   children: [
                              //     Expanded(
                              //       child: Purchase.imageUrl != null
                              //           ? Image.network(Purchase.imageUrl!)
                              //           : Placeholder(),
                              //     ),
                              //   ],
                              // ),
                              onLongPress: () {
                                //copyToClipboard(Purchase.id);
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
                                            Purchase.Purchase_id.toString() +
                                            ' || ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        Purchase.Supplier_Name! +
                                            ' ' +
                                            Purchase.Supplier_Number!
                                        // +
                                        // ' -- ' +
                                        // Purchase.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.paid,
                                        color: purchaseHistoryController
                                                .ispaid(Purchase.isPaid)
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Purchase.Purchase_Date
                                        // +
                                        // ' -- ' +
                                        // Purchase.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                      Text(
                                        ' ' + Format(Purchase.Purchase_Time)
                                        // +
                                        // ' -- ' +
                                        // Purchase.phone_Code,
                                        ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11),
                                      ),
                                      Text(
                                        ' || ' +
                                            Purchase.Username.toUpperCase() +
                                            ' Store'
                                        // +
                                        // ' -- ' +
                                        // Purchase.phone_Code,
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
                                                  'Purchase Total US:  ' +
                                                      addCommasToNumber(Purchase
                                                              .Purchase_Total_USD)
                                                          .toString() +
                                                      '\$' +
                                                      ' || ' +
                                                      addCommasToNumber(Purchase
                                                              .Purchase_Total_LB)
                                                          .toString() +
                                                      ' LB',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.blue.shade900),
                                                ),
                                                Text(
                                                  'Purchase Rec US:  ' +
                                                      addCommasToNumber(Purchase
                                                              .Purchase_Rec_USD)
                                                          .toString() +
                                                      '\$' +
                                                      ' + ' +
                                                      addCommasToNumber(Purchase
                                                              .Purchase_Rec_LB)
                                                          .toString() +
                                                      ' LB',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .green.shade900),
                                                ),
                                                Text(
                                                  'Purchase Due US:  ' +
                                                      addCommasToNumber(Purchase
                                                              .Purchase_Due_USD)
                                                          .toString() +
                                                      '\$' +
                                                      ' || ' +
                                                      addCommasToNumber(Purchase
                                                              .Purchase_Due_LB)
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
                                                  Colors.blue.shade100,
                                              side: BorderSide(
                                                width: 2.0,
                                                color: Colors.blue.shade900,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.to(() => PurchaseHistoryItems(
                                                    Purchase_id: Purchase
                                                        .Purchase_id.toString(),
                                                    Supplier_Name:
                                                        Purchase.Supplier_Name
                                                            .toString(),
                                                    Supplier_Number:
                                                        Purchase.Supplier_Number
                                                            .toString(),
                                                    purchase_Total_US: Purchase
                                                            .Purchase_Total_USD
                                                        .toString(),
                                                    purchase_Rec_US: Purchase
                                                            .Purchase_Rec_USD
                                                        .toString(),
                                                    purchase_Due_US: Purchase
                                                            .Purchase_Due_USD
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
                                                  color: Colors.blue.shade900,
                                                  //  'Details',
                                                  //   style: TextStyle(
                                                  //        color: Colors.red),
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
                                                  Payment_Ammount.text =
                                                      Purchase.Purchase_Due_USD
                                                          .toString();
                                                  return AlertDialog(
                                                    title: Text('Pay Due'),
                                                    content: TextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          Payment_Ammount,
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
                                                          if (Payment_Ammount
                                                                  .text !=
                                                              '') {
                                                            showDialog(
                                                                // The user CANNOT close this dialog  by pressing outsite it
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
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
                                                                            MainAxisSize.min,
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
                                                            purchaseHistoryController.PayInvDue(
                                                                    Purchase.Purchase_id
                                                                        .toString(),
                                                                    Payment_Ammount
                                                                        .text,
                                                                    Purchase.Purchase_Due_USD
                                                                        .toString(),
                                                                    (Purchase.Purchase_Due_USD - double.tryParse(Payment_Ammount.text)!)
                                                                        .toString(),
                                                                    Purchase
                                                                        .Purchase_Date)
                                                                .then((value) =>
                                                                    showToast(purchaseHistoryController
                                                                        .result2))
                                                                .then((value) =>
                                                                    purchaseHistoryController
                                                                            .isDataFetched =
                                                                        false)
                                                                .then((value) =>
                                                                    purchaseHistoryController
                                                                        .fetchpurchases())
                                                                .then((value) => Navigator.of(context).pop())
                                                                .then((value) => Navigator.of(context).pop());

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
                                                          } else {
                                                            Get.snackbar(
                                                                'Error',
                                                                'Add New Quantity');
                                                          }

                                                          // Do something with the text, e.g., save it
                                                          //  String enteredText = _textEditingController.text;
                                                          //  print('Entered text: $enteredText');
                                                          // Close the dialog
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              // Get.to(
                                              //     () => PurchaseHistoryItems(
                                              //           Purchase_id:
                                              //               Purchase.Purchase_id
                                              //                   .toString(),
                                              //                   Customer_id: Purchase.Cus_id.toString(),
                                              //           Customer_Name:
                                              //               Purchase.Cus_Name
                                              //                   .toString(),
                                              //           Customer_Number:
                                              //               Purchase.Cus_Number
                                              //                   .toString(),
                                              //           Purchase_Total_US:
                                              //               Purchase.Purchase_Total_Usd
                                              //                   .toString(),
                                              //           Purchase_Rec_US: Purchase
                                              //                   .Purchase_Rec_Usd
                                              //               .toString(),
                                              //           Purchase_Due_US: Purchase
                                              //                   .Purchase_Due_USD
                                              //               .toString(),
                                              //         ));
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
                                                  color: Colors.green.shade900,
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
                                Row(
                                  children: [
                                    Text(
                                      'Total: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      addCommasToNumber(
                                                  purchaseHistoryController
                                                      .total.value)
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
                                      addCommasToNumber(
                                                  purchaseHistoryController
                                                      .totalrec.value)
                                              .toString() +
                                          '\$',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Due: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      addCommasToNumber(
                                                  purchaseHistoryController
                                                      .totaldue.value)
                                              .toString() +
                                          '\$',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade900,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
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
