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
          IconButton(
              onPressed: () {
                purchaseHistoryController.reset();
                purchaseHistoryController.isDataFetched = false;
                purchaseHistoryController.fetchpurchases();
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
                                purchaseHistoryController.pruchases.refresh();
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
                  //                   groupValue: purchaseHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Store.value = 'this';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Store.value = 'other';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Store.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Store.value = 'all';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Sold.value = 'No';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Sold.value = 'Yes';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Sold.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Sold.value = 'all';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Condition.value = 'New';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Condition.value = 'Used';
                  //                     purchaseHistoryController.searchPhones(
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
                  //                   groupValue: purchaseHistoryController.Condition.value,
                  //                   onChanged: (value) {
                  //                     purchaseHistoryController.Condition.value = 'all';
                  //                     purchaseHistoryController.searchPhones(
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
                              //  width: double.infinity,
                              //   height: 140.0,
                              color: purchaseHistoryController
                                      .ispaid(Purchase.isPaid)
                                  ? Colors.grey.shade300
                                  : Colors.red.shade100,
                              margin: EdgeInsets.fromLTRB(14, 0, 14, 10),
                              //     padding: EdgeInsets.all(35),
                              alignment: Alignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Purchase #' +
                                              Purchase.Purchase_id.toString() +
                                              ' || ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
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
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          ' ' + Format(Purchase.Purchase_Time)
                                          // +
                                          // ' -- ' +
                                          // Purchase.phone_Code,
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
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
                                                    'Purchase Total US:  ' +
                                                        addCommasToNumber(Purchase
                                                                .Purchase_Total_USD)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                  Text(
                                                    'Purchase Total LL:  ' +
                                                        addCommasToNumber(Purchase
                                                                .Purchase_Total_LB)
                                                            .toString() +
                                                        ' LB',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                  Text(
                                                    'Purchase Rec US:  ' +
                                                        addCommasToNumber(Purchase
                                                                .Purchase_Rec_USD)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .green.shade900),
                                                  ),
                                                  Text(
                                                    'Purchase Rec LL:  ' +
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
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .red.shade900),
                                                  ),
                                                  Text(
                                                    'Purchase Due LL:  ' +
                                                        addCommasToNumber(Purchase
                                                                .Purchase_Due_LB)
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
                                                style: ElevatedButton.styleFrom(
                                                  // fixedSize:
                                                  //     Size(double.infinity, 20),
                                                  backgroundColor:
                                                      purchaseHistoryController
                                                              .ispaid(
                                                                  Purchase.isPaid)
                                                          ? Colors.green.shade900
                                                          : Colors.red.shade900,
                                                  side: BorderSide(
                                                    width: 2.0,
                                                    color:
                                                        purchaseHistoryController
                                                                .ispaid(Purchase
                                                                    .isPaid)
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors.red.shade900,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Get.to(
                                                      () => PurchaseHistoryItems(
                                                            Purchase_id:
                                                                Purchase.Purchase_id
                                                                    .toString(),
                                                            Supplier_Name:
                                                                Purchase.Supplier_Name
                                                                    .toString(),
                                                            Supplier_Number:
                                                                Purchase.Supplier_Number
                                                                    .toString(),
                                                            purchase_Total_US:
                                                                Purchase.Purchase_Total_USD
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
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color:
                                                          purchaseHistoryController
                                                                  .ispaid(Purchase
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
                                                style: ElevatedButton.styleFrom(
                                                  // fixedSize:
                                                  //     Size(double.infinity, 20),
                                                  backgroundColor:
                                                     Colors.green.shade900
                                                          ,
                                                  side: BorderSide(
                                                    width: 2.0,
                                                    color:
                                                         Colors
                                                                .green.shade900
                                                            
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Pay Due'),
                                                  content: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: Payment_Ammount,
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
                                                        if (Payment_Ammount.text !=
                                                            '') {
                                                          showDialog(
                                                              // The user CANNOT close this dialog  by pressing outsite it
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
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
                                                                          MainAxisSize
                                                                              .min,
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
                                                              purchaseHistoryController.PayInvDue(Purchase.Purchase_id.toString(), Payment_Ammount.text, Purchase.Purchase_Due_USD.toString(), (Purchase.Purchase_Due_USD - double.tryParse(Payment_Ammount.text)! ).toString(),Purchase.Purchase_Date)
                                                                   .then((value) => showToast(
                                                                  purchaseHistoryController
                                                                      .result2))
                                                                      .then((value) => purchaseHistoryController.isDataFetched = false)
                                                                      .then((value) => purchaseHistoryController.fetchpurchases())
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

                                                          Payment_Ammount.clear();
                                                        } else {
                                                          Get.snackbar('Error',
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
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_circle_right_rounded,
                                                      color:
                                                          purchaseHistoryController
                                                                  .ispaid(Purchase
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
                                          //         Purchase.Username.toUpperCase() +
                                          //         ' Store',
                                          //     style: TextStyle(
                                          //         fontSize: 14,
                                          //         color: Colors.black)),
                                          // Text(
                                          //   'Sell Price: ' +
                                          //       Purchase.Sell_Price.toString() +
                                          //       '\$',
                                          //   style: TextStyle(
                                          //       color: purchaseHistoryController
                                          //               .issold(Purchase.isSold)
                                          //           ? Colors.black
                                          //           : Colors.green.shade900),
                                          // ),
                                          // Visibility(
                                          //   visible: purchaseHistoryController
                                          //       .isadmin(Username.value),
                                          //   child: Text(
                                          //     'Cost Price: ' +
                                          //         Purchase.Price.toString() +
                                          //         '\$',
                                          //     style: TextStyle(
                                          //         color: purchaseHistoryController
                                          //                 .issold(Purchase.isSold)
                                          //             ? Colors.black
                                          //             : Colors.red.shade900),
                                          //   ),
                                          // ),
                                          // Visibility(
                                          //   visible: purchaseHistoryController
                                          //       .isadmin(Username.value),
                                          //   child: Text(
                                          //     'Bought From: ' +
                                          //         Purchase.Cus_Name +
                                          //         ' - ' +
                                          //         Purchase.Cus_Number.toString(),
                                          //     style: TextStyle(
                                          //         color: Colors.black),
                                          //   ),
                                          // ),
                                          // Visibility(
                                          //   visible: purchaseHistoryController
                                          //       .isadmin(Username.value),
                                          //   child: Text(
                                          //     'Bought at: ' +
                                          //         Purchase.Buy_Date +
                                          //         ' - ' +
                                          //         Format(Purchase.Buy_Time),
                                          //     style: TextStyle(
                                          //         color: Colors.black),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    // Visibility(
                                    //   visible: purchaseHistoryController
                                    //       .isadmin(Username.value),
                                    //   child: IconButton(
                                    //       onPressed: () {
                                    //         Get.to(() => PhoneEdit(
                                    //             Phone_id: Purchase.Phone_id,
                                    //             FilterQuery: Purchase.FilterQuery,
                                    //             IMEI: Purchase.IMEI,
                                    //             Cost_Price: Purchase.Price,
                                    //             Sell_Price: Purchase.Sell_Price,
                                    //             Condition:
                                    //                 Purchase.Phone_Condition,
                                    //             Capacity: Purchase.Capacity,
                                    //             Note: Purchase.Note,Color: Purchase.Color_id,));
                                    //       },
                                    //       icon: Icon(Icons.edit,
                                    //           color: purchaseHistoryController
                                    //                   .issold(Purchase.isSold)
                                    //               ? Colors.black
                                    //               : Colors.red)),
                                    // )
                                    // Column(
                                    //   children: [
                                    //     Text(
                                    //       Purchase.Sell_Price.toString() + '\$',
                                    //       style: TextStyle(
                                    //           fontSize: 17,
                                    //           color: Colors.green.shade900),
                                    //     ),
                                    //     Visibility(
                                    //       visible:
                                    //           purchaseHistoryController.isadmin(Username.value),
                                    //       child: Text(
                                    //         Purchase.Price.toString() + '\$',
                                    //         style: TextStyle(
                                    //             fontSize: 17,
                                    //             color: Colors.red.shade900),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    // OutlinedButton(
                                    //     onPressed: () {
                                    //       // purchaseHistoryController.SelectedPhone.value = Purchase;
                                    //       //       // subcategoryController.selectedSubCategory.value =
                                    //       //       //     null;

                                    //       // Get.to(() => PhonesListDetail(
                                    //       //       phone_id:
                                    //       //           Purchase.phone_id.toString(),
                                    //       //       FilterQuery: Purchase.FilterQuery,
                                    //       //       phone_Color: Purchase.phone_Color,
                                    //       //       phone_LPrice:
                                    //       //           Purchase.phone_LPrice.toString(),
                                    //       //       phone_MPrice:
                                    //       //           Purchase.phone_MPrice.toString(),
                                    //       //       phone_Code: Purchase.phone_Code,
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
                                    'Purchases Total US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(purchaseHistoryController
                                                .total.value)
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
                                    'Purchases Recieved US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(purchaseHistoryController
                                                .totalrec.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Purchases Due US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(purchaseHistoryController
                                                .totaldue.value)
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
