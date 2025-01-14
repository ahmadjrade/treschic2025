// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/view/Invoices/invoice_history_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceHistoryByDriver extends StatelessWidget {
  String Driver_id, Driver_Name, Driver_Number;
  InvoiceHistoryByDriver(
      {super.key,
      required this.Driver_id,
      required this.Driver_Name,
      required this.Driver_Number});

  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;
  TextEditingController FilterQuery = TextEditingController();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  @override
  Widget build(BuildContext context) {
    invoiceHistoryController.CalDueForDriver(Driver_Name);
    // invoiceHistoryController.reset();

    //invoiceHistoryController.CalDueForDriver(Driver_id);
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

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$Driver_Name Statement',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              decoration: BoxDecoration(
                //   color: Colors.grey.shade500,
                border: Border.all(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                  onPressed: () {
                    invoiceHistoryController.reset();
                    invoiceHistoryController.isDataFetched = false;
                    invoiceHistoryController.fetchinvoices();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.blue.shade900,
                  )),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            Obx(() {
              FilterQuery.text = barcodeController.barcode3.value;
              return Padding(
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
                            invoiceHistoryController.invoices.refresh();
                          },
                          controller: FilterQuery,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                FilterQuery.clear();
                                invoiceHistoryController.invoices.refresh();
                              },
                            ),
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: 'Search By Name or Number',
                          ),
                        ),
                      )));
            }),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Obx(
                  () {
                    final List<InvoiceModel> filteredinvoices =
                        invoiceHistoryController.SearchInvoicesAllForDriver(
                            FilterQuery.text, Driver_id);

                    if (invoiceHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (invoiceHistoryController.invoices.isEmpty) {
                      return Center(
                          child: Text('No Invoices Yet In This Store!'));
                    } else if (filteredinvoices.isEmpty) {
                      return Center(child: Text('No Invoices Found!'));
                    } else {
                      return ListView.builder(
                        //s  shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredinvoices.length,
                        itemBuilder: (context, index) {
                          final InvoiceModel invoice = filteredinvoices[index];
                          return Container(
                              decoration: BoxDecoration(
                                //   color: Colors.grey.shade500,
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: ListTile(
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
                                              invoice.Invoice_id.toString() +
                                              ' || ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          invoice.Cus_Name! +
                                              ' ' +
                                              invoice.Cus_Number!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.paid,
                                          color: invoiceHistoryController
                                                  .ispaid(invoice.isPaid)
                                              ? Colors.green.shade900
                                              : Colors.red.shade900,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Delivery Code: ' +
                                              (invoice.Delivery_Code ?? '')
                                          // +
                                          // ' -- ' +
                                          // driver.Product_Code,
                                          ,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          invoice.Invoice_Date,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          ' ' + Format(invoice.Invoice_Time),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          ' || ' +
                                              invoice.Username.toUpperCase() +
                                              ' Store',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          ' || ' + invoice.Invoice_Type!
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total US:  ' +
                                              addCommasToNumber(
                                                      invoice.Invoice_Total_Usd)
                                                  .toString() +
                                              '\$',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue.shade900),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'OR ' +
                                              addCommasToNumber(
                                                      invoice.Invoice_Total_Lb)
                                                  .toString() +
                                              ' LB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue.shade900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recieved US:  ' +
                                              addCommasToNumber(
                                                      invoice.Invoice_Rec_Usd)
                                                  .toString() +
                                              '\$',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green.shade900),
                                        ),
                                        Text(
                                          ' And ' +
                                              addCommasToNumber(
                                                      invoice.Invoice_Rec_Lb)
                                                  .toString() +
                                              ' LB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green.shade900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Due:  ' +
                                              addCommasToNumber(
                                                      invoice.Invoice_Due_USD)
                                                  .toString() +
                                              '\$',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red.shade900),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'OR ' +
                                              addCommasToNumber(
                                                      invoice.Invoice_Due_LB)
                                                  .toString() +
                                              ' LB',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red.shade900),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize:
                                                  Size(double.maxFinite, 20),
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
                                              Get.to(() => InvoiceHistoryItems(
                                                    Invoice_id: invoice
                                                        .Invoice_id.toString(),
                                                    Customer_id: invoice.Cus_id
                                                        .toString(),
                                                    Customer_Name: invoice
                                                        .Cus_Name.toString(),
                                                    Customer_Number: invoice
                                                        .Cus_Number.toString(),
                                                    Invoice_Total_US: invoice
                                                            .Invoice_Total_Usd
                                                        .toString(),
                                                    Invoice_Rec_US:
                                                        invoice.Invoice_Rec_Usd
                                                            .toString(),
                                                    Invoice_Due_US:
                                                        invoice.Invoice_Due_USD
                                                            .toString(),
                                                    rate: invoice.Inv_Rate
                                                        .toString(),
                                                    Inv_Type:
                                                        invoice.Invoice_Type!,
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
                                                SizedBox(width: 10),
                                                Icon(
                                                  Icons
                                                      .arrow_circle_right_rounded,
                                                  color: Colors.blue.shade900,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize:
                                                  Size(double.maxFinite, 20),
                                              backgroundColor:
                                                  Colors.green.shade100,
                                              side: BorderSide(
                                                width: 2.0,
                                                color: Colors.green.shade900,
                                              ),
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
                                                    return AlertDialog(
                                                      title: Text('Pay Due'),
                                                      content:
                                                          Text('Are you Sure?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
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
                                                            invoiceHistoryController.PayInvDue(
                                                                    invoice.Invoice_id
                                                                        .toString(),
                                                                    invoice.Invoice_Total_Usd
                                                                        .toString(),
                                                                    invoice.Invoice_Due_USD
                                                                        .toString(),
                                                                    (invoice.Invoice_Due_USD - (invoice.Invoice_Total_Usd))
                                                                        .toString(),
                                                                    invoice.Cus_id
                                                                        .toString(),
                                                                    invoice
                                                                        .Invoice_Date)
                                                                .then((value) =>
                                                                    showToast(
                                                                        invoiceHistoryController
                                                                            .result2))
                                                                .then((value) =>
                                                                    invoiceHistoryController
                                                                            .isDataFetched =
                                                                        false)
                                                                .then((value) => invoiceHistoryController.fetchinvoices())
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

                                                            // Do something with the text, e.g., save it
                                                            //  String enteredText = _textEditingController.text;
                                                            //  print('Entered text: $enteredText');
                                                            // Close the dialog
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  });
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
                                                SizedBox(width: 10),
                                                Icon(
                                                  Icons
                                                      .arrow_circle_right_rounded,
                                                  color: Colors.green.shade900,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                        },

                        // if (invoiceHistoryController.itemsToShow.value <
                        //     filteredinvoices.length)
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 120.0),
                        //     child: OutlinedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         // fixedSize: Size(double.maxFinite,20),
                        //         backgroundColor: Colors.white,
                        //         side: BorderSide(
                        //           width: 2.0,
                        //           color: Colors.green.shade900,
                        //         ),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(15.0),
                        //         ),
                        //       ),
                        //       onPressed: () {
                        //         invoiceHistoryController
                        //                 .itemsToShow.value +=
                        //             20; // Increase the observable value
                        //       },
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             'Show More',
                        //             style: TextStyle(
                        //                 color: Colors.green.shade900),
                        //           ),
                        //           SizedBox(width: 10),
                        //           Icon(
                        //             Icons.arrow_circle_right_rounded,
                        //             color: Colors.green.shade900,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
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
                              Text(
                                'Due: ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                addCommasToNumber(invoiceHistoryController
                                            .totaldue_driver.value)
                                        .toString() +
                                    '\$',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.normal),
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
