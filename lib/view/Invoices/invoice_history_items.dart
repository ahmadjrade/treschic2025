// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/invoice_history_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Invoices/old_invoice_update.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceHistoryItems extends StatefulWidget {
  String Invoice_id,
      Customer_id,
      Customer_Name,
      Customer_Number,
      Invoice_Total_US,
      Invoice_Rec_US,
      Invoice_Due_US;
  InvoiceHistoryItems(
      {super.key,
      required this.Invoice_id,
      required this.Customer_id,
      required this.Customer_Name,
      required this.Customer_Number,
      required this.Invoice_Total_US,
      required this.Invoice_Rec_US,
      required this.Invoice_Due_US});

  @override
  State<InvoiceHistoryItems> createState() => _InvoiceHistoryItemsState();
}

class _InvoiceHistoryItemsState extends State<InvoiceHistoryItems> {
  final InvoiceDetailController invoiceDetailController =
      Get.find<InvoiceDetailController>();

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

    // invoiceDetailController.isDataFetched = false;
    // invoiceDetailController.fetchproductdetails();
    // List<InvoiceHistoryModel> filteredProductDetails() {

    //   return invoiceDetailController.invoice_detail
    //       .where((invoice_detail) =>
    //           invoice_detail.Invoice_id == int.tryParse(Invoice_id))
    //       .toList();
    // }
    List<InvoiceHistoryModel> filteredProductDetails() {
      final filterText = filter.value.toLowerCase();
      return invoiceDetailController.invoice_detail
          .where((invoice_detail) =>
              invoice_detail.Invoice_id == int.tryParse(widget.Invoice_id) &&
              (invoice_detail.Product_Name.toLowerCase().contains(filterText) ||
                  invoice_detail.Product_Code.toLowerCase()
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
        'Invoice ID #${widget.Invoice_id}',
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
      if (widget.Customer_Name != '000000') {
        bytes += ticket.text(
            'Customer Name: ' +
                widget.Customer_Name +
                '\nCustomer Number: ' +
                widget.Customer_Number,
            styles: PosStyles(align: PosAlign.center, bold: true),
            linesAfter: 1);
        // bytes += ticket.text(
        //     'UNPAID DUES: ' +
        //         addCommasToNumber(double.tryParse(Customer_Due)!) +
        //         '\$',
        //     styles: PosStyles(
        //       align: PosAlign.center,
        //       bold: true,
        //     ),
        //     linesAfter: 1);
      }
      // bytes += ticket.text(
      //     'USD Rate: ' + (rateController.rateValue.value.toString()),
      //     styles: PosStyles(align: PosAlign.center, bold: true),
      //     linesAfter: 0);

      // bytes += ticket.beep();
      //   bytes += ticket.image();

      bytes += ticket.hr();
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
              invoiceDetailController.invoice_detail
                  .where((invoice_detail) =>
                      invoice_detail.Invoice_id ==
                          int.tryParse(widget.Invoice_id) &&
                      (invoice_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          invoice_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()
                  .length;
          i++) {
        print(filteredProductDetails);
        bytes += ticket.row([
          PosColumn(
              text: invoiceDetailController.invoice_detail
                  .where((invoice_detail) =>
                      invoice_detail.Invoice_id ==
                          int.tryParse(widget.Invoice_id) &&
                      (invoice_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          invoice_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .Product_Quantity
                  .toString(),
              width: 1,
              styles: PosStyles(bold: true)),
          PosColumn(
              text: invoiceDetailController.invoice_detail
                  .where((invoice_detail) =>
                      invoice_detail.Invoice_id ==
                          int.tryParse(widget.Invoice_id) &&
                      (invoice_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          invoice_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .Product_Code,
              width: 5,
              styles: PosStyles(bold: true)),
          PosColumn(
              text: invoiceDetailController.invoice_detail
                  .where((invoice_detail) =>
                      invoice_detail.Invoice_id ==
                          int.tryParse(widget.Invoice_id) &&
                      (invoice_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          invoice_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .Product_Color,
              width: 2,
              styles: PosStyles(bold: true)),
          PosColumn(
              text: invoiceDetailController.invoice_detail
                  .where((invoice_detail) =>
                      invoice_detail.Invoice_id ==
                          int.tryParse(widget.Invoice_id) &&
                      (invoice_detail.Product_Name.toLowerCase()
                              .contains(filter.value.toLowerCase()) ||
                          invoice_detail.Product_Code.toLowerCase()
                              .contains(filter.value.toLowerCase())))
                  .toList()[i]
                  .product_TP
                  .toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right, bold: true)),
          PosColumn(
              text: (invoiceDetailController.invoice_detail
                      .where((invoice_detail) =>
                          invoice_detail.Invoice_id ==
                              int.tryParse(widget.Invoice_id) &&
                          (invoice_detail.Product_Name.toLowerCase()
                                  .contains(filter.value.toLowerCase()) ||
                              invoice_detail.Product_Code.toLowerCase()
                                  .contains(filter.value.toLowerCase())))
                      .toList()[i]
                      .product_TP)
                  .toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right, bold: true)),
        ]);
        bytes += ticket.row([
          PosColumn(
              text: '  ' +
                  invoiceDetailController.invoice_detail
                      .where((invoice_detail) =>
                          invoice_detail.Invoice_id ==
                              int.tryParse(widget.Invoice_id) &&
                          (invoice_detail.Product_Name.toLowerCase()
                                  .contains(filter.value.toLowerCase()) ||
                              invoice_detail.Product_Code.toLowerCase()
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

      bytes += ticket.row([
        PosColumn(
            text: 'TOTAL USD',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(double.tryParse(widget.Invoice_Total_US)!) +
                ' USD',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
      ]);

      bytes += ticket.row([
        PosColumn(
            text: 'TOTAL LL',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(double.tryParse(widget.Invoice_Total_US)!) +
                ' LL',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
      ]);

      bytes += ticket.row([
        PosColumn(
            text: 'Received Usd',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(double.tryParse(widget.Invoice_Rec_US)!) +
                ' USD',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: 'Received LL',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(double.tryParse(widget.Invoice_Total_US)!) +
                ' LL',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
      ]);

      bytes += ticket.row([
        PosColumn(
            text: 'Due Usd',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(double.tryParse(widget.Invoice_Due_US)!) +
                ' USD',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: 'Due LL',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(double.tryParse(widget.Invoice_Due_US)!) +
                ' LL',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
      ]);
      bytes += ticket.hr(ch: '=', linesAfter: 1);
      bytes += ticket.row([
        PosColumn(
            text: 'New Due',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        // PosColumn(
        //     text: addCommasToNumber(double.tryParse(Invoice_Due_US)! +
        //             double.tryParse(Cus_Due)!) +
        //         ' USD',
        //     width: 6,
        //     styles: PosStyles(
        //         align: PosAlign.right,
        //         height: PosTextSize.size1,
        //         bold: true,
        //         width: PosTextSize.size1)),
      ]);
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

    //  invoiceDetailController.product_detail.clear();
    // invoiceDetailController.isDataFetched = false;
    //  invoiceDetailController.fetchproductdetails(Invoice_id);
    // productController.fetchproducts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Invoice #${widget.Invoice_id} Items'),
          IconButton(
            color: Color.fromRGBO(13, 134, 151, 1),
            iconSize: 24.0,
            onPressed: () {
              Get.to(() => OldInvoiceUpdate(
                    Invoice_id: widget.Invoice_id,
                    Cus_id: widget.Customer_id,
                    Cus_Name: widget.Customer_Name,
                    Cus_Number: widget.Customer_Number,
                  ));
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
              invoiceDetailController.isDataFetched = false;
              invoiceDetailController.fetchinvoicesdetails();
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
            TextFormField(
              //maxLength: 15,
              initialValue:
                  widget.Customer_Name + ' || ' + widget.Customer_Number,
              readOnly: true,
              //controller: Customer_Name,
              decoration: InputDecoration(
                //helperText: '*',

                //  hintText: '03123456',
                labelText: "Customer",
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                fillColor: Colors.black,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    //maxLength: 15,
                    initialValue: widget.Invoice_Total_US + '\$',
                    readOnly: true,
                    //controller: Customer_Name,
                    decoration: InputDecoration(
                      //helperText: '*',

                      //  hintText: '03123456',
                      labelText: "Total",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      fillColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    //maxLength: 15,
                    initialValue: widget.Invoice_Rec_US + '\$',
                    readOnly: true,
                    //controller: Customer_Name,
                    decoration: InputDecoration(
                      //helperText: '*',

                      //  hintText: '03123456',
                      labelText: "Received",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      fillColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    //maxLength: 15,
                    initialValue: widget.Invoice_Due_US + '\$',
                    readOnly: true,
                    //controller: Customer_Name,
                    decoration: InputDecoration(
                      //helperText: '*',

                      //  hintText: '03123456',
                      labelText: "Due",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      fillColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
                  final List<InvoiceHistoryModel> filtereditems =
                      filteredProductDetails();
                  if (invoiceDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (invoiceDetailController.invoice_detail.isEmpty) {
                    return Center(child: Text('No Items Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filtereditems.length,
                      itemBuilder: (context, index) {
                        final InvoiceHistoryModel invoice =
                            filtereditems[index];
                        return Container(
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          //     padding: EdgeInsets.all(35),
                          alignment: Alignment.center,
                          child: ExpansionTile(
                            collapsedTextColor: Colors.black,
                            textColor: Colors.black,
                            backgroundColor: Colors.deepPurple.shade100,
                            //   collapsedBackgroundColor: Colors.white,
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  invoice.Product_Quantity.toString() + ' PCS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(
                                  'UP: ' + invoice.product_UP.toString() + '\$',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.green.shade900),
                                ),
                              ],
                            ),
                            title: Text(
                              '#' +
                                  invoice.Invoice_Detail_id.toString() +
                                  ' || ' +
                                  invoice.Product_Name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Column(
                                  //  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: true,
                                          child: IconButton(
                                              color: Colors.red,
                                              onPressed: () {
                                                if (double.tryParse(widget
                                                        .Invoice_Due_US) ==
                                                    0) {
                                                  showDialog(
                                                      // The user CANNOT close this dialog  by pressing outsite it
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (_) {
                                                        return Dialog(
                                                          // The background color
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
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
                                                  invoiceDetailController.DeleteInvItem(
                                                          invoice.Invoice_Detail_id
                                                              .toString())
                                                      .then((value) => showToast(
                                                          invoiceDetailController
                                                              .result2))
                                                      .then((value) =>
                                                          invoiceDetailController
                                                                  .isDataFetched =
                                                              false)
                                                      .then((value) =>
                                                          invoiceDetailController
                                                              .fetchinvoicesdetails)
                                                      .then((value) =>
                                                          Navigator.of(context)
                                                              .pop());
                                                } else {
                                                  showToast(
                                                      'Invoice Due Must Be 0');
                                                }
                                              },
                                              icon: Icon(Icons.delete)),
                                        ),
                                      ],
                                    ),

                                    Text('Product Code: ' +
                                        invoice.Product_Code),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Product Color: ' +
                                        invoice.Product_Color),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Unit Price: ' +
                                        invoice.product_UP.toString() +
                                        '\$'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Total Price: ' +
                                        invoice.product_TP.toString() +
                                        '\$'),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    // Text('id' + invoice.PD_id.toString()),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),

                                    // Text('Total Price of Treatment:  ${treatments.!}\$ '),
                                  ],
                                ),
                              )
                            ],
                            //  subtitle: Text(invoice.Product_Brand),
                            // trailing: OutlinedButton(
                            //   onPressed: () {

                            //     // productController.SelectedPhone.value = invoice;
                            //     //       // product_detailsController.selectedproduct_details.value =
                            //     //       //     null;

                            //               Get.to(() => InvoiceHistoryItems(Invoice_id: invoice.Invoice_id.toString(), Customer_Name: invoice.Customer_Name,Customer_Number: invoice.Customer_Number,));
                            //   },
                            //   child: Text('Select')),
                            // // Add more properties as needed
                          ),
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
