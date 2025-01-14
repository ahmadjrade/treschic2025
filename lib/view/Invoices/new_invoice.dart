// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/invoice_detail_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/platform_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/rate_controller.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:treschic/view/Product/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class NewInvoice extends StatefulWidget {
  String Cus_id,
      Cus_Name,
      Cus_Number,
      Cus_Due,
      Driver_id,
      Driver_Name,
      Driver_Number,
      isDel,
      Address;

  NewInvoice(
      {super.key,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number,
      required this.Cus_Due,
      required this.Driver_id,
      required this.Driver_Name,
      required this.Driver_Number,
      required this.isDel,
      required this.Address});

  @override
  State<NewInvoice> createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewInvoice> {
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  TextEditingController New_Price = TextEditingController();

  TextEditingController New_Qty = TextEditingController();
  final PlatformController platformController = Get.find<PlatformController>();
  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();

  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();

  final InvoiceDetailController invoiceDetailController =
      Get.find<InvoiceDetailController>();

  TextEditingController Product_Code = TextEditingController();
  TextEditingController Delivery_Code = TextEditingController();

  // final InvoiceController invoiceController = Get.put(InvoiceController());
  final RateController rateController = Get.find<RateController>();

  final InvoiceController invoiceController = Get.find<InvoiceController>();

  double TP = 0;

  double CalPrice(qty, up) {
    return TP = qty * up;
  }

  bool isDelivery(isDel) {
    if (isDel == '1') {
      return true;
    } else {
      return false;
    }
  }

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  String CalculatedDueUsd = '';

  String CalDue(due, rate) {
    CalculatedDueUsd = '';
    CalculatedDueUsd = (due / rate).toString();
    return CalculatedDueUsd;
  }

  Future<void> showToast(result) async {
    final snackBar2 = SnackBar(
      content: Text(result),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar2);
  }

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  TextEditingController i = TextEditingController();
  TextEditingController rec_usd_controller = TextEditingController();
  TextEditingController rec_lb_controller = TextEditingController();
  Future<void> refreshProducts() async {
    productDetailController.product_detail.clear();
    productDetailController.isDataFetched = false;
    productDetailController.fetchproductdetails();
  }

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text('Loading'),
              ],
            ),
          ),
        );
      },
    );
  }

  void dismissDialog(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('No Internet'),
          content: Text('Internet connection lost. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> processInvoice(BuildContext context) async {
    // Validate guest dues
    if (widget.Cus_Number == '00000000' &&
        invoiceController.DueUSD.value != 0) {
      Get.snackbar('Error', 'Guest can\'t have dues!');
      return;
    }

    // Validate invoice items
    if (invoiceController.invoiceItems.isEmpty) {
      Get.snackbar('No Products Added!', 'Add Products');
      return;
    }

    // Validate received amount
    final totalReceived = invoiceController.ReceivedUSD.value +
        (invoiceController.ReceivedLb.value / rateController.rateValue.value);

    if (totalReceived > invoiceController.totalUsd.value) {
      Get.snackbar('Error', 'Received is bigger than Total');
      return;
    }

    // Validate delivery code if applicable
    if (widget.isDel == '1' && Delivery_Code.text.isEmpty) {
      showToast('Please add Delivery Code');
      return;
    }

    // Show loading dialog
    showLoadingDialog(context);

    bool hasCompleted = false;

    // Periodic internet check every second for up to 5 seconds
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (hasCompleted) {
        timer.cancel();
        return;
      }

      final isConnected = await checkInternetConnection();
      if (!isConnected) {
        timer.cancel();
        dismissDialog(context);
        showNoInternetDialog(context);
      }
    });

    try {
      // Upload invoice to database
      await invoiceController.uploadInvoiceToDatabase(
        widget.Cus_id.toString(),
        widget.Cus_Name,
        widget.Cus_Number,
        widget.Driver_id,
        widget.Driver_Name,
        widget.Driver_Number,
        widget.isDel,
        Delivery_Code.text,
      );

      hasCompleted = true;

      // Show result sssstoast
      showToast(invoiceController.result);

      // Additional actions
      if (Platform.isAndroid) {
        await CheckPrinter(
          widget.Cus_Name,
          widget.Cus_Number,
          widget.Cus_Due,
        );
      } else {
        await refreshProducts();
        invoiceHistoryController.isDataFetched = false;
        invoiceHistoryController.fetchinvoices();
        invoiceDetailController.isDataFetched = false;
        invoiceDetailController.fetchinvoicesdetails();
        invoiceController.reset();
      }

      // Update totals
      invoiceHistoryController.CalTotal_fhome();
    } catch (e) {
      // Handle errors gracefully
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      // Always dismiss the loading dialog
      if (!hasCompleted) {
        dismissDialog(context);
        dismissDialog(context);
      }
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
                                .then((value) => CheckPrinter(widget.Cus_Name,
                                    widget.Cus_Number, widget.Cus_Due));
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
                      backgroundColor: Colors.blue.shade900,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      refreshProducts()
                          .then((value) =>
                              invoiceDetailController.isDataFetched = false)
                          .then((value) =>
                              invoiceDetailController.fetchinvoicesdetails())
                          .then((value) => invoiceController.reset())
                          .then((value) => invoiceController.reset())
                          .then((value) => invoiceController.reset())
                          .then((value) => Navigator.of(context).pop())
                          .then((value) => Navigator.of(context).pop())
                          .then((value) => Navigator.of(context).pop());
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

  Future<void> CheckPrinter(Cus_Name, Cus_Number, Cus_Due) async {
    if (invoiceController.result == 'Invoice Sent Successfully') {
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
          refreshProducts()
              .then((value) => invoiceHistoryController.isDataFetched = false)
              .then((value) => invoiceHistoryController.fetchinvoices())
              .then((value) => invoiceDetailController.isDataFetched = false)
              .then((value) => invoiceDetailController.fetchinvoicesdetails())
              .then((value) => invoiceController.reset())
              .then((value) => invoiceController.reset())
              .then((value) => invoiceController.reset())
              .then((value) => Navigator.pop(context))
              .then((value) => Navigator.pop(context));
        }
      } else {
        print('Already connected');
        invoiceController.PrintReceipt(Cus_Name, Cus_Number, Cus_Due)
            .then((value) => refreshProducts()
                .then((value) => invoiceHistoryController.isDataFetched = false)
                .then((value) => invoiceHistoryController.fetchinvoices())
                .then((value) => invoiceDetailController.isDataFetched = false)
                .then(
                    (value) => invoiceDetailController.fetchinvoicesdetails()))
            .then((value) => invoiceController.reset())
            .then((value) => invoiceController.reset())
            .then((value) => invoiceController.reset())
            .then((value) => Navigator.pop(context))
            .then((value) => Navigator.pop(context));
      }
    }
  }

  Future<void> refreshRate() async {
    rateController.isDataFetched = false;
    rateController.fetchrate();
  }

  TextEditingController scannedBarcode = TextEditingController();

  void _onBarcodeScanned(String barcode) {
    invoiceController.fetchProduct(scannedBarcode.text);
    print("Barcode scanned: $barcode");
    // Add your desired function here to handle the scanned barcode
  }

  @override
  Widget build(BuildContext context) {
    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Remaining LB copied to clipboard'),
        ),
      );
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      // /  backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          //backgroundColor: Colors.grey.shade100,
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('New Invoice'),
          Container(
            // height: 40,
            // width: 150,
            decoration: BoxDecoration(
              // color: Colors.grey.shade500,
              border: Border.all(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // IconButton(
                //   color: Colors.blue.shade900,
                //   //iconSize: 17.0,
                //   onPressed: () {
                //     Get.toNamed('/BuyAccessories');
                //   },
                //   icon: Icon(CupertinoIcons.add),
                // ),
                IconButton(
                  color: Colors.blue.shade900,
                  //iconSize: 17.0,
                  onPressed: () {
                    refreshProducts();
                    refreshRate();
                  },
                  icon: Icon(CupertinoIcons.refresh),
                ),
                IconButton(
                  color: Colors.blue.shade900,
                  //  iconSize: 17.0,
                  onPressed: () {
                    invoiceController.reset();
                    invoiceController.reset();
                    invoiceController.reset();
                  },
                  icon: Icon(CupertinoIcons.clear),
                ),
              ],
            ),
          ),
        ],
      )),
      body: BarcodeKeyboardListener(
        onBarcodeScanned: (barcode) {
          setState(() {
            scannedBarcode.text = barcode;
          });

          // Trigger the function you want here
          _onBarcodeScanned(barcode);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey.shade500,
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextField(
                                  //obscureText: true,
                                  //  readOnly: isLoading,
                                  controller: Product_Code,

                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Product_Code.clear();
                                        //customerController.customers.refresh();
                                      },
                                    ),
                                    prefixIcon: IconButton(
                                        icon: Icon(Icons.search),
                                        onPressed: () {
                                          Get.to(() => ProductList(
                                                from_home: 0,
                                                isPur: 1,
                                              ));
                                        }),
                                    border: InputBorder.none,
                                    hintText: 'Product Code',
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.qr_code,
                              size: 17,
                            ),
                            onPressed: () {
                              barcodeController.scanBarcodeInv();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.done,
                              size: 17,
                            ),
                            onPressed: () {
                              invoiceController.fetchProduct(Product_Code.text);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isDelivery(widget.isDel),
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Visibility(
                    visible: isDelivery(widget.isDel),
                    child: Container(
                        decoration: BoxDecoration(
                          //color: Colors.grey.shade500,
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            //obscureText: true,
                            //  readOnly: isLoading,
                            controller: Delivery_Code,

                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Delivery_Code.clear();
                                  //customerController.customers.refresh();
                                },
                              ),
                              prefixIcon: IconButton(
                                  icon: Icon(Icons.numbers),
                                  onPressed: () {
                                    // Get.to(() => ProductList(
                                    //       from_home: 0,
                                    //       isPur: 1,
                                    //     ));
                                  }),
                              border: InputBorder.none,
                              hintText: 'Delivery Code',
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Invoice Items',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      child: ListView.builder(
                        // primary: false,
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: invoiceController.invoiceItems.length,
                        itemBuilder: (context, index) {
                          var product = invoiceController.invoiceItems[index];
                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.Product_Name +
                                                  ' ${product.Product_Color}',
                                              // overflow:
                                              //     TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${product.pdetail_code}'),
                                    Obx(() {
                                      return Row(
                                        children: [
                                          IconButton(
                                              color: Colors.red,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Update Item Price'),
                                                      content: TextField(
                                                        keyboardType:
                                                            platformController
                                                                    .CheckPlatform()
                                                                ? TextInputType
                                                                    .number
                                                                : TextInputType
                                                                    .text,
                                                        controller: New_Price,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Enter New Price'),
                                                      ),
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
                                                            if (New_Price
                                                                    .text !=
                                                                '') {
                                                              invoiceController.updateItemPrice(
                                                                  invoiceController
                                                                          .invoiceItems[
                                                                      index],
                                                                  double.tryParse(
                                                                      New_Price
                                                                          .text)!);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              New_Price.clear();
                                                            } else {
                                                              Get.snackbar(
                                                                  'Error',
                                                                  'Add New Price');
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
                                              },
                                              icon: Icon(Icons.price_change)),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    ' UP: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    '${product.product_MPrice}\$ ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors
                                                            .green.shade900),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'TP: ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    CalPrice(
                                                                product.quantity
                                                                    .value,
                                                                product
                                                                    .product_MPrice)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors
                                                            .green.shade900),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (product.quantity.value == 1) {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Remove Item?'),
                                                        // content: setupAlertDialoadContainer(),

                                                        actions: [
                                                          Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: OutlinedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        fixedSize: Size(
                                                                            double.infinity,
                                                                            20),
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        side: BorderSide(
                                                                            width:
                                                                                2.0,
                                                                            color:
                                                                                Colors.red),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(32.0),
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Expanded(
                                                                  child: OutlinedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        fixedSize: Size(
                                                                            double.infinity,
                                                                            20),
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                        side: BorderSide(
                                                                            width:
                                                                                2.0,
                                                                            color:
                                                                                Colors.green),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(32.0),
                                                                        ),
                                                                      ),
                                                                      onPressed: () {
                                                                        invoiceController
                                                                            .invoiceItems
                                                                            .removeAt(index);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        invoiceController
                                                                            .calculateTotal();
                                                                        invoiceController
                                                                            .calculateTotalQty();
                                                                        invoiceController
                                                                            .calculateTotalLb();
                                                                        invoiceController
                                                                            .calculateDueUSD();
                                                                        invoiceController
                                                                            .calculateDueLB();
                                                                        // _showeditAlertDialog(
                                                                        //     context,
                                                                        //     product_info[index]
                                                                        //         .Product_info_id);
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                      child: Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                invoiceController.DecreaseQty(
                                                    invoiceController
                                                        .invoiceItems[index]);
                                              }
                                            },
                                            icon: Icon(Icons.remove)),
                                        Obx(() {
                                          return Text(
                                              '${product.quantity.value}');
                                        }),
                                        IconButton(
                                            onPressed: () {
                                              if (product.quantity.value ==
                                                  product.Product_Quantity) {
                                                Get.snackbar('Error',
                                                    'Max Quantity Reached');
                                              } else {
                                                invoiceController.IncreaseQty(
                                                    invoiceController
                                                        .invoiceItems[index]);
                                              }
                                            },
                                            icon: Icon(Icons.add)),
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Update Item Quantity'),
                                                    content: TextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller: New_Qty,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Enter New Quantity'),
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
                                                          if (New_Qty.text !=
                                                              '') {
                                                            if (int.tryParse(
                                                                    New_Qty
                                                                        .text)! ==
                                                                0) {
                                                              Get.snackbar(
                                                                  'Error',
                                                                  'Quantity Can\'t Be 0');
                                                            } else {
                                                              invoiceController.UpdateQty(
                                                                  invoiceController
                                                                          .invoiceItems[
                                                                      index],
                                                                  int.tryParse(
                                                                      New_Qty
                                                                          .text)!);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              New_Qty.clear();
                                                            }
                                                          } else {
                                                            Get.snackbar(
                                                                'Error',
                                                                'Add New Price');
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
                                            },
                                            icon: Icon(Icons
                                                .production_quantity_limits)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Max Quantity: '),
                                        Text('${product.Product_Quantity}'),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ));
                        },
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return Container(
                        width: double.infinity,
                        //     height: double.maxFinite,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Invoice Information',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Customer: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.Cus_Name +
                                            ' - ' +
                                            widget.Cus_Number,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isDelivery(widget.isDel),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Address: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.Address,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isDelivery(widget.isDel),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Driver: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.Driver_Name +
                                              ' - ' +
                                              widget.Driver_Number,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Obx(() {
                                      if (rateController.isLoading.value) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return
                                            //Text('${rateController.rateValue.value}');
                                            Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Rate: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    '${rateController.rateValue.value}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Item Count: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${invoiceController.totalQty.toString()}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Invoice Total: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        addCommasToNumber(invoiceController
                                                .totalUsd.value) +
                                            ' \$',
                                        style: TextStyle(
                                            color: Colors.green.shade900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Invoice Total LL: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        addCommasToNumber(invoiceController
                                                .totalLb.value) +
                                            ' LB',
                                        style: TextStyle(
                                            color: Colors.green.shade900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Invoice Due USD: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onLongPress: () {
                                          copyToClipboard(
                                              invoiceController.DueLB.value);
                                        },
                                        child: Text(
                                          addCommasToNumber(double.tryParse(
                                                  CalDue(
                                                      invoiceController
                                                          .DueLB.value,
                                                      rateController
                                                          .rateValue.value))!) +
                                              ' \$',
                                          style: TextStyle(
                                              color: Colors.green.shade900),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Invoice Due LB: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onLongPress: () {
                                          copyToClipboard(
                                              invoiceController.DueLB.value);
                                        },
                                        child: Text(
                                          addCommasToNumber(invoiceController
                                                  .DueLB.value) +
                                              ' \LB',
                                          style: TextStyle(
                                              color: Colors.green.shade900),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !isDelivery(widget.isDel),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          //color: Colors.grey.shade500,
                                          border: Border.all(
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: TextField(
                                            //obscureText: true,
                                            //  readOnly: isLoading,
                                            keyboardType: platformController
                                                    .CheckPlatform()
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            controller: rec_usd_controller,
                                            onChanged: (Value) {
                                              if (Value == '') {
                                                //  Get.snackbar('123', '123');
                                                invoiceController.resetRecUsd();
                                              } else {
                                                invoiceController
                                                        .ReceivedUSD.value =
                                                    double.tryParse(Value)!;
                                                invoiceController
                                                    .calculateDueUSD();
                                                invoiceController
                                                    .calculateDueLB();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  rec_usd_controller.clear();
                                                  invoiceController
                                                      .resetRecUsd();

                                                  //customerController.customers.refresh();
                                                },
                                              ),
                                              prefixIcon: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('USD'),
                                                ],
                                              ),
                                              border: InputBorder.none,
                                              //  hintText: 'Product Code',
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !isDelivery(widget.isDel),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          //color: Colors.grey.shade500,
                                          border: Border.all(
                                              color: Colors.grey.shade500),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: TextField(
                                            //obscureText: true,
                                            //  readOnly: isLoading,
                                            keyboardType: platformController
                                                    .CheckPlatform()
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            controller: rec_lb_controller,
                                            onChanged: (value) {
                                              if (value == '') {
                                                //  Get.snackbar('123', '123');
                                                invoiceController.resetRecLb();
                                              } else {
                                                invoiceController
                                                        .ReceivedLb.value =
                                                    double.tryParse(value)!;
                                                invoiceController
                                                    .calculateDueLB();
                                                invoiceController
                                                    .calculateDueUSD();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  rec_lb_controller.clear();
                                                  invoiceController
                                                      .resetRecLb();

                                                  //customerController.customers.refresh();
                                                },
                                              ),
                                              prefixIcon: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text('LB'),
                                                ],
                                              ),
                                              border: InputBorder.none,
                                              //  hintText: 'Product Code',
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.maxFinite, 50),
                        backgroundColor: Colors.blue.shade100,
                        side:
                            BorderSide(width: 2.0, color: Colors.blue.shade900),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        processInvoice(context);

                        // void showLoadingDialog(BuildContext context) {
                        //   showDialog(
                        //     barrierDismissible: false,
                        //     context: context,
                        //     builder: (_) {
                        //       return Dialog(
                        //         backgroundColor: Colors.white,
                        //         child: Padding(
                        //           padding:
                        //               const EdgeInsets.symmetric(vertical: 20),
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               CircularProgressIndicator(),
                        //               SizedBox(height: 15),
                        //               Text('Loading'),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   );
                        // }

                        // // Helper to dismiss dialog
                        // void dismissDialog(BuildContext context) {
                        //   if (Navigator.canPop(context)) Navigator.pop(context);
                        // }

                        // // Validate guest dues
                        // if (widget.Cus_Number == '00000000' &&
                        //     invoiceController.DueUSD.value != 0) {
                        //   Get.snackbar('Error', 'Guest can\'t have dues!');
                        //   return;
                        // }

                        // // Validate invoice items
                        // if (invoiceController.invoiceItems.isEmpty) {
                        //   Get.snackbar('No Products Added!', 'Add Products');
                        //   return;
                        // }

                        // // Validate received amount
                        // final totalReceived =
                        //     invoiceController.ReceivedUSD.value +
                        //         (invoiceController.ReceivedLb.value /
                        //             rateController.rateValue.value);

                        // if (totalReceived > invoiceController.totalUsd.value) {
                        //   Get.snackbar(
                        //       'Error', 'Received is bigger than Total');
                        //   return;
                        // }

                        // // Validate delivery code if applicable
                        // if (widget.isDel == '1' && Delivery_Code.text.isEmpty) {
                        //   showToast('Please add Delivery Code');
                        //   return;
                        // }

                        // try {
                        //   // Show loading dialog
                        //   showLoadingDialog(context);

                        //   // Upload invoice to database
                        //   await invoiceController.uploadInvoiceToDatabase(
                        //     widget.Cus_id.toString(),
                        //     widget.Cus_Name,
                        //     widget.Cus_Number,
                        //     widget.Driver_id,
                        //     widget.Driver_Name,
                        //     widget.Driver_Number,
                        //     widget.isDel,
                        //     Delivery_Code.text,
                        //   );

                        //   // Show result toast
                        //   showToast(invoiceController.result);

                        //   // Additional actions
                        //   if (Platform.isAndroid) {
                        //     await CheckPrinter(
                        //       widget.Cus_Name,
                        //       widget.Cus_Number,
                        //       widget.Cus_Due,
                        //     );
                        //   } else {
                        //     await refreshProducts();
                        //     invoiceHistoryController.isDataFetched = false;
                        //     invoiceHistoryController.fetchinvoices();
                        //     invoiceDetailController.isDataFetched = false;
                        //     invoiceDetailController.fetchinvoicesdetails();
                        //     invoiceController.reset();
                        //   }

                        //   // Update totals
                        //   invoiceHistoryController.CalTotal_fhome();
                        // } catch (e) {
                        //   // Handle errors gracefully
                        //   Get.snackbar('Error', 'Something went wrong: $e');
                        // } finally {
                        //   // Always dismiss the loading dialog
                        //   dismissDialog(context);
                        // }
                        // if (widget.Cus_Number == '00000000' &&
                        //     invoiceController.DueUSD.value != 0) {
                        //   Get.snackbar('Error', 'Guest can\'t have dues!');
                        // } else {
                        //   if (invoiceController.invoiceItems.isNotEmpty) {
                        //     if ((invoiceController.ReceivedUSD.value +
                        //             invoiceController.ReceivedLb.value /
                        //                 rateController.rateValue.value) >
                        //         (invoiceController.totalUsd.value)) {
                        //       Get.snackbar(
                        //           'Error', 'Recieved is bigger than Total');
                        //     } else {
                        //       if (widget.isDel == '1') {
                        //         if (Delivery_Code.text != '') {
                        //           if (Platform.isAndroid) {
                        //             showDialog(
                        //                 // The user CANNOT close this dialog  by pressing outsite it
                        //                 barrierDismissible: false,
                        //                 context: context,
                        //                 builder: (_) {
                        //                   return Dialog(
                        //                     // The background color
                        //                     backgroundColor: Colors.white,
                        //                     child: Padding(
                        //                       padding:
                        //                           const EdgeInsets.symmetric(
                        //                               vertical: 20),
                        //                       child: Column(
                        //                         mainAxisSize: MainAxisSize.min,
                        //                         children: [
                        //                           // The loading indicator
                        //                           CircularProgressIndicator(),
                        //                           SizedBox(
                        //                             height: 15,
                        //                           ),
                        //                           // Some text
                        //                           Text('Loading')
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //                 });
                        //             invoiceController
                        //                 .uploadInvoiceToDatabase(
                        //                     widget.Cus_id.toString(),
                        //                     widget.Cus_Name,
                        //                     widget.Cus_Number,
                        //                     widget.Driver_id,
                        //                     widget.Driver_Name,
                        //                     widget.Driver_Number,
                        //                     widget.isDel,
                        //                     Delivery_Code.text)
                        //                 .then((value) =>
                        //                     showToast(invoiceController.result))
                        //                 .then((value) => CheckPrinter(
                        //                     widget.Cus_Name,
                        //                     widget.Cus_Number,
                        //                     widget.Cus_Due))
                        //                 .then((value) =>
                        //                     invoiceHistoryController
                        //                         .CalTotal_fhome());
                        //           } else {
                        //             showDialog(
                        //                 // The user CANNOT close this dialog  by pressing outsite it
                        //                 barrierDismissible: false,
                        //                 context: context,
                        //                 builder: (_) {
                        //                   return Dialog(
                        //                     // The background color
                        //                     backgroundColor: Colors.white,
                        //                     child: Padding(
                        //                       padding:
                        //                           const EdgeInsets.symmetric(
                        //                               vertical: 20),
                        //                       child: Column(
                        //                         mainAxisSize: MainAxisSize.min,
                        //                         children: [
                        //                           // The loading indicator
                        //                           CircularProgressIndicator(),
                        //                           SizedBox(
                        //                             height: 15,
                        //                           ),
                        //                           // Some text
                        //                           Text('Loading')
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //                 });
                        //             invoiceController
                        //                 .uploadInvoiceToDatabase(
                        //                     widget.Cus_id.toString(),
                        //                     widget.Cus_Name,
                        //                     widget.Cus_Number,
                        //                     widget.Driver_id,
                        //                     widget.Driver_Name,
                        //                     widget.Driver_Number,
                        //                     widget.isDel,
                        //                     Delivery_Code.text)
                        //                 .then((value) =>
                        //                     showToast(invoiceController.result))
                        //                 .then((value) => refreshProducts()
                        //                     .then((value) => invoiceHistoryController
                        //                         .isDataFetched = false)
                        //                     .then((value) =>
                        //                         invoiceHistoryController
                        //                             .fetchinvoices())
                        //                     .then((value) => invoiceDetailController
                        //                         .isDataFetched = false)
                        //                     .then((value) =>
                        //                         invoiceDetailController.fetchinvoicesdetails())
                        //                     .then((value) => invoiceController.reset())
                        //                     .then((value) => invoiceController.reset())
                        //                     .then((value) => invoiceController.reset())
                        //                     .then((value) => Navigator.pop(context))
                        //                     .then((value) => Navigator.pop(context))
                        //                     .then((value) => invoiceHistoryController.CalTotal_fhome()));
                        //           }
                        //         } else {
                        //           showToast('Please add Delivery Code');
                        //         }
                        //       } else {
                        //         if (Platform.isAndroid) {
                        //           showDialog(
                        //               // The user CANNOT close this dialog  by pressing outsite it
                        //               barrierDismissible: false,
                        //               context: context,
                        //               builder: (_) {
                        //                 return Dialog(
                        //                   // The background color
                        //                   backgroundColor: Colors.white,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.symmetric(
                        //                         vertical: 20),
                        //                     child: Column(
                        //                       mainAxisSize: MainAxisSize.min,
                        //                       children: [
                        //                         // The loading indicator
                        //                         CircularProgressIndicator(),
                        //                         SizedBox(
                        //                           height: 15,
                        //                         ),
                        //                         // Some text
                        //                         Text('Loading')
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 );
                        //               });
                        //           invoiceController
                        //               .uploadInvoiceToDatabase(
                        //                   widget.Cus_id.toString(),
                        //                   widget.Cus_Name,
                        //                   widget.Cus_Number,
                        //                   widget.Driver_id,
                        //                   widget.Driver_Name,
                        //                   widget.Driver_Number,
                        //                   widget.isDel,
                        //                   Delivery_Code.text)
                        //               .then((value) =>
                        //                   showToast(invoiceController.result))
                        //               .then((value) => CheckPrinter(
                        //                   widget.Cus_Name,
                        //                   widget.Cus_Number,
                        //                   widget.Cus_Due))
                        //               .then((value) => invoiceHistoryController
                        //                   .CalTotal_fhome());
                        //         } else {
                        //           showDialog(
                        //               // The user CANNOT close this dialog  by pressing outsite it
                        //               barrierDismissible: false,
                        //               context: context,
                        //               builder: (_) {
                        //                 return Dialog(
                        //                   // The background color
                        //                   backgroundColor: Colors.white,
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.symmetric(
                        //                         vertical: 20),
                        //                     child: Column(
                        //                       mainAxisSize: MainAxisSize.min,
                        //                       children: [
                        //                         // The loading indicator
                        //                         CircularProgressIndicator(),
                        //                         SizedBox(
                        //                           height: 15,
                        //                         ),
                        //                         // Some text
                        //                         Text('Loading')
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 );
                        //               });
                        //           invoiceController
                        //               .uploadInvoiceToDatabase(
                        //                   widget.Cus_id.toString(),
                        //                   widget.Cus_Name,
                        //                   widget.Cus_Number,
                        //                   widget.Driver_id,
                        //                   widget.Driver_Name,
                        //                   widget.Driver_Number,
                        //                   widget.isDel,
                        //                   Delivery_Code.text)
                        //               .then((value) =>
                        //                   showToast(invoiceController.result))
                        //               .then((value) => refreshProducts()
                        //                   .then((value) => invoiceHistoryController
                        //                       .isDataFetched = false)
                        //                   .then((value) =>
                        //                       invoiceHistoryController
                        //                           .fetchinvoices())
                        //                   .then((value) => invoiceDetailController
                        //                       .isDataFetched = false)
                        //                   .then((value) =>
                        //                       invoiceDetailController.fetchinvoicesdetails())
                        //                   .then((value) => invoiceController.reset())
                        //                   .then((value) => invoiceController.reset())
                        //                   .then((value) => invoiceController.reset())
                        //                   .then((value) => Navigator.pop(context))
                        //                   .then((value) => Navigator.pop(context))
                        //                   .then((value) => invoiceHistoryController.CalTotal_fhome()));
                        //         }
                        //       }
                        //     }
                        //   } else {
                        //     //    showToast('Add Products');
                        //     Get.snackbar('No Products Added!', 'Add Products ');
                        // }
                        // }
                      },
                      child: Text(
                        'Insert Invoice',
                        style: TextStyle(color: Colors.blue.shade900),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
