// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/category_controller.dart';
import 'package:treschic/controller/invoice_detail_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/controller/sub_category_controller.dart';
import 'package:treschic/controller/transfer_detail_controller.dart';
import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/invoice_history_model.dart';
import 'package:treschic/model/product_detail_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/model/transfer_details_model.dart';
import 'package:treschic/model/transfer_history_model.dart';
import 'package:treschic/view/Invoices/old_invoice_update.dart';
import 'package:treschic/view/Product/add_product_detail.dart';
import 'package:treschic/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransferHistoryItems extends StatefulWidget {
  String Transfer_id;

  TransferHistoryItems({
    super.key,
    required this.Transfer_id,
  });

  @override
  State<TransferHistoryItems> createState() => _InvoiceHistoryItemsState();
}

class _InvoiceHistoryItemsState extends State<TransferHistoryItems> {
  final TransferDetailController transferDetailController =
      Get.find<TransferDetailController>();

  TextEditingController New_Qty = TextEditingController();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  RxString Username = ''.obs;

  final RxString filter = ''.obs;

  final TextEditingController filterController = TextEditingController();

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  Future<void> CheckPrinter() async {
    if (bluetoothController!.connection == null ||
        !bluetoothController!.connection!.isConnected) {
      List<BluetoothDevice> devices = [];
      try {
        devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      } catch (e) {
        print('Error getting devices: $e');
      }

      if (devices.isNotEmpty) {
        await showAvailableDevices();
      } else {
        print('No bonded devices available');
      }
    } else {
      print('Already connected');
      // chec();
    }
  }

  Future<void> showAvailableDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } catch (e) {
      print('Error getting devices: $e');
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Available Devices'),
            content: Column(
              children: [
                Expanded(
                  child: Column(
                    children: devices.map((device) {
                      return Expanded(
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                device.name!,
                                // overflow: TextOverflow.f,
                                style: TextStyle(fontSize: 15),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          onTap: () async {
                            await bluetoothController!
                                .connectToDevice(device)
                                .then((value) => CheckPrinter());
                            Navigator.pop(
                                context); // Close the dialog after connecting
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.deepPurple.shade300,
                      side: BorderSide(
                          width: 2.0, color: Colors.deepPurple.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  // TextEditingController Customer_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    // transferDetailController.isDataFetched = false;
    // transferDetailController.fetchproductdetails();
    // List<TransferDetailsModel> FilteredTransferDetails() {

    //   return transferDetailController.transfer_detail
    //       .where((transfer_detail) =>
    //           transfer_detail.Transfer_id == int.tryParse(Transfer_id))
    //       .toList();
    // }
    List<TransferDetailsModel> FilteredTransferDetails() {
      final filterText = filter.value.toLowerCase();
      return transferDetailController.transfer_detail
          .where((transfer_detail) =>
              transfer_detail.Transfer_id == int.tryParse(widget.Transfer_id) &&
              (transfer_detail.Product_Name.toLowerCase()
                      .contains(filterText) ||
                  transfer_detail.Product_Code.toLowerCase()
                      .contains(filterText)))
          .toList();
    }

    Future<List<int>> ReceiptDesign(
      PaperSize paper,
      CapabilityProfile profile,
    ) async {
      final Generator ticket = Generator(paper, profile);
      List<int> bytes = [];
      //List Name = ['123', '1234', '12345'];

      ////final ByteData data = await rootBundle.load('images/test.png');
      ///final Uint8List imageBytes = data.buffer.asUint8List();
      //final im.Image? image = im.decodeImage(imageBytes);
      // bytes += ticket.image(image!); // Add the image to the bytes list
      bytes += ticket.text('AJTECH',
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);

      bytes += ticket.text(Username.toUpperCase() + ' Store',
          styles: PosStyles(align: PosAlign.center, bold: true));
      //bytes += ticket.text(Store_Loc!, styles: PosStyles(align: PosAlign.center));

      bytes += ticket.text('+961/81214404',
          styles: PosStyles(align: PosAlign.center, bold: true));
      // bytes += ticket.text('Web: www.treschiclb.com',
      //     styles: PosStyles(align: PosAlign.center), linesAfter: 0);
      bytes += ticket.feed(1);
      bytes += ticket.text(
        'Invoice ID #${widget.Transfer_id}',
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 1,
      );
      //bytes += ticket.qrcode(lastId);
      bytes += ticket.hr(ch: '*', linesAfter: 1);
      bytes += ticket.text('Invoice Type: ' + 'Store',
          styles: PosStyles(align: PosAlign.center, bold: true), linesAfter: 0);
      // bytes += ticket.text('Paid In: ' + Currency,
      //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
      // if (Delivery_Code.text != '') {
      //   bytes += ticket.text('Delivery Code: ' + Delivery_Code.text,
      //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);
      // }
      // if (Delivery_Code.text != '') {
      //   bytes += ticket.text(
      //       'Delivery Company Name: ' +
      //           Cus_Name +
      //           '\nDelivery Company Number: ' +
      //           Cus_Number,
      //       styles: PosStyles(align: PosAlign.center),
      //       linesAfter: 1);

      //   bytes += ticket.text(
      //       'Reciever Name: ' +
      //           C_Customer_Name.text +
      //           '\nReciever Company Number: ' +
      //           C_Customer_Number.text,
      //       styles: PosStyles(align: PosAlign.center),
      //       linesAfter: 1);

      //   bytes += ticket.text('Reciever Address: ' + Cus_address.text,
      //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);
      // }
      // if (Delivery_Code.text == '') {
      //   bytes += ticket.text(
      //       'Customer Name: ' + Cus_Name + '\nCustomer Number: ' + Cus_Number,
      //       styles: PosStyles(align: PosAlign.center),
      //       linesAfter: 1);
      // }

      // bytes += ticket.text(
      //     'UNPAID DUES: ' +
      //         addCommasToNumber(double.tryParse(Customer_Due)!) +
      //         '\$',
      //     styles: PosStyles(
      //       align: PosAlign.center,
      //       bold: true,
      //     ),
      //     linesAfter: 1);

      // bytes += ticket.text(
      //     'USD Rate: ' + (rateController.rateValue.value.toString()),
      //     styles: PosStyles(align: PosAlign.center, bold: true),
      //     linesAfter: 0);

      // bytes += ticket.beep();
      //   bytes += ticket.image();

      bytes += ticket.row([
        PosColumn(
            text: 'Qty',
            width: 1,
            styles: PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: 'Item',
            width: 5,
            styles: PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: 'Color',
            width: 2,
            styles: PosStyles(align: PosAlign.left, bold: true)),
        PosColumn(
            text: 'UP',
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
            text: 'TP',
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
      ]);
      bytes += ticket.hr(ch: '=', linesAfter: 1);

      for (int i = 0;
          i <
              transferDetailController.transfer_detail
                  .where((transfer_detail) =>
                      transfer_detail.Transfer_id ==
                          int.tryParse(widget.Transfer_id) &&
                      (transfer_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          transfer_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()
                  .length;
          i++) {
        print(FilteredTransferDetails);
        bytes += ticket.row([
          PosColumn(
              text: transferDetailController.transfer_detail
                  .where((transfer_detail) =>
                      transfer_detail.Transfer_id ==
                          int.tryParse(widget.Transfer_id) &&
                      (transfer_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          transfer_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .Product_Qty
                  .toString(),
              width: 1,
              styles: PosStyles(bold: true)),
          PosColumn(
              text: transferDetailController.transfer_detail
                  .where((transfer_detail) =>
                      transfer_detail.Transfer_id ==
                          int.tryParse(widget.Transfer_id) &&
                      (transfer_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          transfer_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .Product_Code,
              width: 5,
              styles: PosStyles(bold: true)),
          PosColumn(
              text: transferDetailController.transfer_detail
                  .where((transfer_detail) =>
                      transfer_detail.Transfer_id ==
                          int.tryParse(widget.Transfer_id) &&
                      (transfer_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          transfer_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .Product_Color,
              width: 2,
              styles: PosStyles(bold: true)),
        ]);
        bytes += ticket.row([
          PosColumn(
              text: '  ' +
                  transferDetailController.transfer_detail
                      .where((transfer_detail) =>
                          transfer_detail.Transfer_id ==
                              int.tryParse(widget.Transfer_id) &&
                          (transfer_detail.Product_Name.toLowerCase()
                                  .contains(filter.value.toLowerCase()) ||
                              transfer_detail.Product_Code.toLowerCase()
                                  .contains(filter.value.toLowerCase())))
                      .toList()[i]
                      .Product_Name
                      .toString(),
              width: 12,
              styles: PosStyles(align: PosAlign.left, bold: true)),
        ]);
        bytes += ticket.hr(ch: ' ', linesAfter: 0);
      }

      bytes += ticket.hr(ch: '=', linesAfter: 1);

      bytes += ticket.hr(ch: '=', linesAfter: 1);

      bytes += ticket.hr(ch: '=', linesAfter: 1);
      bytes += ticket.feed(2);
      bytes += ticket.text('Thank you!',
          styles: PosStyles(align: PosAlign.center, bold: true));
      final now = DateTime.now();
      final formatter = DateFormat('MM/dd/yyyy H:m');
      final String timestamp = formatter.format(now);
      bytes += ticket.text(timestamp,
          styles: PosStyles(align: PosAlign.center), linesAfter: 2);

      // bytes += ticket.text('Invoice #' + last_id.toString(),
      //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);

      // bytes += ticket.qrcode(last_id.toString());
      bytes += ticket.feed(1);
      bytes += ticket.cut();

      ticket.feed(2);
      ticket.cut();
      return bytes;
    }

    Future<void> PrintReceipt() async {
      final profile = await CapabilityProfile.load();
      final PaperSize paper = PaperSize.mm80;

      final List<int> bytes = await ReceiptDesign(paper, profile);
      if (bluetoothController!.isConnected &&
          bluetoothController!.connection != null) {
        try {
          bluetoothController!.connection!.output
              .add(Uint8List.fromList(bytes));
          await bluetoothController!.connection!.output.allSent;
        } catch (e) {
          print('Error printing: $e');
        }
      } else {
        print('Error: Not connected to a Bluetooth device');
      }
    }

    //  transferDetailController.product_detail.clear();
    // transferDetailController.isDataFetched = false;
    //  transferDetailController.fetchproductdetails(Transfer_id);
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Invoice #${widget.Transfer_id} Items'),
          IconButton(
            color: Color.fromRGBO(13, 134, 151, 1),
            iconSize: 24.0,
            onPressed: () {
              // Get.to(() => OldInvoiceUpdate(
              //       Transfer_id: widget.Transfer_id,
              //       Cus_id: widget.Customer_id,
              //       Cus_Name: widget.Customer_Name,
              //       Cus_Number: widget.Customer_Number,
              //     ));
            },
            icon: Icon(CupertinoIcons.add),
          ),
          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              if (Platform.isAndroid) {}
              // categoryController.isDataFetched =false;
              // categoryController.fetchcategories();
            },
            icon: Icon(CupertinoIcons.printer),
          ),
          IconButton(
            color: Colors.deepPurple,
            iconSize: 24.0,
            onPressed: () {
              transferDetailController.isDataFetched = false;
              transferDetailController.fetchinvoicesdetails();
              // categoryController.isDataFetched =false;
              // categoryController.fetchcategories();
            },
            icon: Icon(CupertinoIcons.refresh),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            // TextFormField(
            //   //maxLength: 15,
            //   initialValue:
            //       widget.Customer_Name + ' || ' + widget.Customer_Number,
            //   readOnly: true,
            //   //controller: Customer_Name,
            //   decoration: InputDecoration(
            //     //helperText: '*',

            //     //  hintText: '03123456',
            //     labelText: "Customer",
            //     labelStyle: TextStyle(
            //       color: Colors.black,
            //     ),
            //     fillColor: Colors.black,
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(15.0),
            //       borderSide: BorderSide(
            //         color: Colors.black,
            //       ),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(15.0),
            //       borderSide: BorderSide(
            //         color: Colors.black,
            //         width: 2.0,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         //maxLength: 15,
            //         initialValue: widget.Invoice_Total_US + '\$',
            //         readOnly: true,
            //         //controller: Customer_Name,
            //         decoration: InputDecoration(
            //           //helperText: '*',

            //           //  hintText: '03123456',
            //           labelText: "Total",
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //           ),
            //           fillColor: Colors.black,
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             borderSide: BorderSide(
            //               color: Colors.black,
            //             ),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             borderSide: BorderSide(
            //               color: Colors.black,
            //               width: 2.0,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: TextFormField(
            //         //maxLength: 15,
            //         initialValue: widget.Invoice_Rec_US + '\$',
            //         readOnly: true,
            //         //controller: Customer_Name,
            //         decoration: InputDecoration(
            //           //helperText: '*',

            //           //  hintText: '03123456',
            //           labelText: "Received",
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //           ),
            //           fillColor: Colors.black,
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             borderSide: BorderSide(
            //               color: Colors.black,
            //             ),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             borderSide: BorderSide(
            //               color: Colors.black,
            //               width: 2.0,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: TextFormField(
            //         //maxLength: 15,
            //         initialValue: widget.Invoice_Due_US + '\$',
            //         readOnly: true,
            //         //controller: Customer_Name,
            //         decoration: InputDecoration(
            //           //helperText: '*',

            //           //  hintText: '03123456',
            //           labelText: "Due",
            //           labelStyle: TextStyle(
            //             color: Colors.black,
            //           ),
            //           fillColor: Colors.black,
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             borderSide: BorderSide(
            //               color: Colors.black,
            //             ),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             borderSide: BorderSide(
            //               color: Colors.black,
            //               width: 2.0,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            TextFormField(
              controller: filterController,
              decoration: InputDecoration(
                labelText: "Filter by Name or Code",
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              onChanged: (value) {
                filter.value = value;
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(
                () {
                  final List<TransferDetailsModel> filtereditems =
                      FilteredTransferDetails();
                  if (transferDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (transferDetailController.transfer_detail.isEmpty) {
                    return Center(child: Text('No Items Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filtereditems.length,
                      itemBuilder: (context, index) {
                        final TransferDetailsModel transfer =
                            filtereditems[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '#' +
                                          transfer.Product_Detail_id
                                              .toString() +
                                          ' || ' +
                                          transfer.Product_Name,
                                      style: TextStyle(
                                          // overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    transfer.Product_Qty.toString() + ' PCS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Product Code: ' + transfer.Product_Code),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Product Color: ' + transfer.Product_Color),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: true,
                                child: IconButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      showDialog(
                                          // The user CANNOT close this dialog  by pressing outsite it
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) {
                                            return Dialog(
                                              // The background color
                                              backgroundColor: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // The loading indicator
                                                    CircularProgressIndicator(),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    // Some text
                                                    Text('Loading')
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                      // transferDetailController.DeleteInvItem(
                                      //         transfer.Invoice_Detail_id
                                      //             .toString())
                                      //     .then((value) => showToast(
                                      //         transferDetailController
                                      //             .result2))
                                      //     .then((value) =>
                                      //         transferDetailController
                                      //                 .isDataFetched =
                                      //             false)
                                      //     .then((value) =>
                                      //         transferDetailController
                                      //             .fetchinvoicesdetails)
                                      //     .then((value) =>
                                      //         Navigator.of(context)
                                      // .pop());
                                    },
                                    icon: Icon(Icons.delete)),
                              ),
                            ]),
                          ),

                          //  subtitle: Text(transfer.Product_Brand),
                          // trailing: OutlinedButton(
                          //   onPressed: () {

                          //     // productController.SelectedPhone.value = transfer;
                          //     //       // product_detailsController.selectedproduct_details.value =
                          //     //       //     null;

                          //               Get.to(() => TransferHistoryItems(Transfer_id: transfer.Transfer_id.toString(), Customer_Name: transfer.Customer_Name,Customer_Number: transfer.Customer_Number,));
                          //   },
                          //   child: Text('Select')),
                          // // Add more properties as needed
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
