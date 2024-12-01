// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';
import 'dart:io';

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/platform_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/repair_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_detail_controller.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Phones/phones_list.dart';
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:fixnshop_admin/view/Repairs/repair_product_list.dart';
import 'package:fixnshop_admin/view/Repairs/repair_product_list_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class AddRepairItems extends StatefulWidget {
  String Rep_id;

  AddRepairItems({
    super.key,
    required this.Rep_id,
  });

  @override
  State<AddRepairItems> createState() => _AddRepaiState();
}

class _AddRepaiState extends State<AddRepairItems> {
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

  TextEditingController Repair_p_code = TextEditingController();

  // final RepairController repairController = Get.put(RepairController());
  final RateController rateController = Get.find<RateController>();

  final RepairController repairController = Get.find<RepairController>();
  TextEditingController rec_usd_controller = TextEditingController();
  TextEditingController rec_lb_controller = TextEditingController();

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

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  TextEditingController i = TextEditingController();

  Future<void> refreshProducts() async {
    productDetailController.product_detail.clear();
    productDetailController.isDataFetched = false;
    productDetailController.fetchproductdetails();
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
                                .then((value) => null);
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
                      backgroundColor: Colors.blue.shade300,
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
                          .then((value) => repairController.reset())
                          .then((value) => repairController.reset())
                          .then((value) => repairController.reset())
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

  Future<void> CheckPrinter() async {
    if (repairController.result == 'Repair Sent Successfully') {
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
              .then((value) => repairController.reset())
              .then((value) => repairController.reset())
              .then((value) => repairController.reset())
              .then((value) => Navigator.pop(context))
              .then((value) => Navigator.pop(context));
        }
      } else {
        print('Already connected');
        repairController.PrintReceipt()
            .then((value) => refreshProducts()
                .then((value) => invoiceHistoryController.isDataFetched = false)
                .then((value) => invoiceHistoryController.fetchinvoices())
                .then((value) => invoiceDetailController.isDataFetched = false)
                .then(
                    (value) => invoiceDetailController.fetchinvoicesdetails()))
            .then((value) => repairController.reset())
            .then((value) => repairController.reset())
            .then((value) => repairController.reset())
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
    repairController.fetchProduct(scannedBarcode.text);
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repair #${widget.Rep_id} ',
                style: TextStyle(fontSize: 17),
              ),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.grey.shade500,
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.blue.shade900,
                      // iconSize: 20.0,
                      onPressed: () {
                        Get.toNamed('/BuyAccessories');
                      },
                      icon: Icon(CupertinoIcons.add),
                    ),
                    IconButton(
                      color: Colors.blue.shade900,
                      // iconSize: 20.0,
                      onPressed: () {
                        refreshProducts();
                        refreshRate();
                      },
                      icon: Icon(CupertinoIcons.refresh),
                    ),
                    IconButton(
                      color: Colors.blue.shade900,
                      // iconSize: 20.0,
                      onPressed: () {
                        repairController.reset();
                        repairController.reset();
                        repairController.reset();
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
                                          Get.to(() => RepairProductList(
                                                isPur: 1,
                                                isCreated: 1,
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
                              repairController.fetchProduct(Repair_p_code.text);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return Column(children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Repair Items',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: repairController.repairItems.length,
                          itemBuilder: (context, index) {
                            var product = repairController.repairItems[index];
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
                                                product.Repair_p_name +
                                                    ' ${product.Color}',
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
                                      Text('${product.Repair_p_code}'),
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
                                                          decoration:
                                                              InputDecoration(
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
                                                            child:
                                                                Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (New_Price
                                                                      .text !=
                                                                  '') {
                                                                repairController.updateItemPrice(
                                                                    repairController
                                                                            .repairItems[
                                                                        index],
                                                                    double.tryParse(
                                                                        New_Price
                                                                            .text)!);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                New_Price
                                                                    .clear();
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
                                                      '${product.R_product_price}\$ ',
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
                                                                  product
                                                                      .quantity
                                                                      .value,
                                                                  product
                                                                      .R_product_price)
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
                                                if (product.quantity.value ==
                                                    1) {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
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
                                                                              width: 2.0,
                                                                              color: Colors.red),
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
                                                                          style:
                                                                              TextStyle(color: Colors.white),
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
                                                                              width: 2.0,
                                                                              color: Colors.green),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(32.0),
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          repairController
                                                                              .repairItems
                                                                              .removeAt(index);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          repairController
                                                                              .calculateTotal();
                                                                          repairController
                                                                              .calculateTotalQty();
                                                                          repairController
                                                                              .calculateTotalLb();
                                                                          repairController
                                                                              .calculateDueUSD();
                                                                          repairController
                                                                              .calculateDueLB();
                                                                          // _showeditAlertDialog(
                                                                          //     context,
                                                                          //     product_info[index]
                                                                          //         .Product_info_id);
                                                                          // Navigator.of(context).pop();
                                                                        },
                                                                        child: Text(
                                                                          'Yes',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  repairController.DecreaseQty(
                                                      repairController
                                                          .repairItems[index]);
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
                                                    product
                                                        .R_product_quantity) {
                                                  Get.snackbar('Error',
                                                      'Max Quantity Reached');
                                                } else {
                                                  repairController.IncreaseQty(
                                                      repairController
                                                          .repairItems[index]);
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
                                                            TextInputType
                                                                .number,
                                                        controller: New_Qty,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Enter New Quantity'),
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
                                                                repairController.UpdateQty(
                                                                    repairController
                                                                            .repairItems[
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
                                          Text('${product.R_product_quantity}'),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ));
                          },
                        ),
                      ),
                    ]);
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
                            labelText: 'Repair Information',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                                Text('Rate: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
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
                                                '${repairController.totalQty.toString()}'),
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
                                      Text('Repair Total: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        addCommasToNumber(repairController
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
                                      Text('Repair Total LL: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        addCommasToNumber(repairController
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
                                      Text('Repair Due USD: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onLongPress: () {
                                          copyToClipboard(
                                              repairController.DueLB.value);
                                        },
                                        child: Text(
                                          addCommasToNumber(double.tryParse(
                                                  CalDue(
                                                      repairController
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
                                      Text('Repair Due LB: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onLongPress: () {
                                          copyToClipboard(
                                              repairController.DueLB.value);
                                        },
                                        child: Text(
                                          addCommasToNumber(repairController
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
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.grey.shade500,
                                        border: Border.all(
                                            color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: TextField(
                                          //obscureText: true,
                                          //  readOnly: isLoading,
                                          keyboardType:
                                              platformController.CheckPlatform()
                                                  ? TextInputType.number
                                                  : TextInputType.text,
                                          controller: rec_usd_controller,
                                          onChanged: (Value) {
                                            if (Value == '') {
                                              //  Get.snackbar('123', '123');
                                              repairController.resetRecUsd();
                                            } else {
                                              repairController
                                                      .ReceivedUSD.value =
                                                  double.tryParse(Value)!;
                                              repairController
                                                  .calculateDueUSD();
                                              repairController.calculateDueLB();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                rec_usd_controller.clear();
                                                repairController.resetRecUsd();

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
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.grey.shade500,
                                        border: Border.all(
                                            color: Colors.grey.shade500),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: TextField(
                                          //obscureText: true,
                                          //  readOnly: isLoading,
                                          keyboardType:
                                              platformController.CheckPlatform()
                                                  ? TextInputType.number
                                                  : TextInputType.text,
                                          controller: rec_lb_controller,
                                          onChanged: (value) {
                                            if (value == '') {
                                              //  Get.snackbar('123', '123');
                                              repairController.resetRecLb();
                                            } else {
                                              repairController
                                                      .ReceivedLb.value =
                                                  double.tryParse(value)!;
                                              repairController.calculateDueLB();
                                              repairController
                                                  .calculateDueUSD();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                rec_lb_controller.clear();
                                                repairController.resetRecLb();

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
                      onPressed: () {
                        if (repairController.repairItems.isNotEmpty) {
                          if (Platform.isAndroid) {
                            showDialog(
                                // The user CANNOT close this dialog  by pressing outsite it
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    // The background color
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
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
                            repairController
                                .uploadRepairToDatabase(
                                  widget.Rep_id.toString(),
                                )
                                .then((value) =>
                                    showToast(repairController.result))
                                .then((value) => CheckPrinter())
                                .then((value) =>
                                    invoiceHistoryController.CalTotal_fhome());
                          } else {
                            showDialog(
                                // The user CANNOT close this dialog  by pressing outsite it
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    // The background color
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
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
                            repairController
                                .uploadRepairToDatabase(
                                  widget.Rep_id.toString(),
                                )
                                .then((value) =>
                                    showToast(repairController.result))
                                .then((value) => refreshProducts()
                                    .then((value) => invoiceHistoryController
                                        .isDataFetched = false)
                                    .then((value) => invoiceHistoryController
                                        .fetchinvoices())
                                    .then((value) => invoiceDetailController
                                        .isDataFetched = false)
                                    .then((value) => invoiceDetailController
                                        .fetchinvoicesdetails())
                                    .then((value) => repairController.reset())
                                    .then((value) => repairController.reset())
                                    .then((value) => repairController.reset())
                                    .then((value) => Navigator.pop(context))
                                    .then((value) => Navigator.pop(context))
                                    .then((value) =>
                                        invoiceHistoryController.CalTotal_fhome()));
                          }
                        } else {
                          //    showToast('Add Products');
                          Get.snackbar('No Products Added!', 'Add Products ');
                        }
                      },
                      child: Text(
                        'Insert Items',
                        style: TextStyle(color: Colors.blue.shade900),
                      )),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
