// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';
import 'dart:io';

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/invoice_detail_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/platform_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/rate_controller.dart';
import 'package:treschic/controller/transfer_controller.dart';
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

class NewTransfer extends StatefulWidget {
  String Store_id, Store_Name;

  NewTransfer({
    super.key,
    required this.Store_id,
    required this.Store_Name,
  });

  @override
  State<NewTransfer> createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewTransfer> {
  final BarcodeController barcodeController = Get.find<BarcodeController>();

  TextEditingController New_Qty = TextEditingController();
  final PlatformController platformController = Get.find<PlatformController>();

  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();

  TextEditingController Product_Code = TextEditingController();
  TextEditingController Delivery_Code = TextEditingController();

  // final TransferController transferController = Get.put(TransferController());

  final TransferController transferController = Get.find<TransferController>();

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
                      backgroundColor: Colors.blue.shade900,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      refreshProducts()
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
    if (transferController.result == 'Transfer Sent Successfully') {
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
              .then((value) => Navigator.pop(context))
              .then((value) => Navigator.pop(context));
        }
      } else {
        print('Already connected');
        transferController.PrintReceipt()
            .then((value) =>
                refreshProducts().then((value) => Navigator.pop(context)))
            .then((value) => Navigator.pop(context));
      }
    }
  }

  bool CheckPhone(int isphone) {
    if (isphone == 1) {
      return true;
    } else {
      return false;
    }
  }

  TextEditingController scannedBarcode = TextEditingController();

  void _onBarcodeScanned(String barcode) {
    transferController.fetchProduct(scannedBarcode.text);
    print("Barcode scanned: $barcode");
    // Add your desired function here to handle the scanned barcode
  }

  @override
  Widget build(BuildContext context) {
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
              Text('New Transfer'),
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
                      iconSize: 24.0,
                      onPressed: () {
                        refreshProducts();
                        //refreshRate();
                      },
                      icon: Icon(CupertinoIcons.refresh),
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
                                          Get.to(() => ProductList(
                                                from_home: 0,
                                                isPur: 3,
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
                              barcodeController.scanBarcodeTransfer();
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
                              transferController
                                  .fetchProduct(Product_Code.text);
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
                          labelText: 'Transfer Items',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: transferController.TransferItems.length,
                          itemBuilder: (context, index) {
                            var product =
                                transferController.TransferItems[index];
                            return Card(
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '#' +
                                        product.Product_id.toString() +
                                        ' ' +
                                        product.Product_Name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text('Color: ' + product.Product_Color),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CheckPhone(product.isPhone)
                                          ? Text(
                                              'IMEI: ${product.Product_Code}')
                                          : Text(
                                              'Code: ${product.Product_Code}'),
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
                                                                          transferController.TransferItems.removeAt(
                                                                              index);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          transferController
                                                                              .calculateTotalQty();

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
                                                  transferController.DecreaseQty(
                                                      transferController
                                                              .TransferItems[
                                                          index]);
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
                                                  transferController.IncreaseQty(
                                                      transferController
                                                              .TransferItems[
                                                          index]);
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
                                                                transferController.UpdateQty(
                                                                    transferController
                                                                            .TransferItems[
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
                            labelText: 'Transfer Information',
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
                                      Text('Item Count: '),
                                      Text(
                                          '${transferController.totalQty.toString()}'),
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
                                      Text('Transfer To: '),
                                      Text(
                                        widget.Store_Name,
                                        style: TextStyle(
                                            color: Colors.green.shade900),
                                      ),
                                    ],
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
                      onPressed: () {
                        if (transferController.TransferItems.isNotEmpty) {
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
                            transferController
                                .uploadTransferToDatabase(widget.Store_id)
                                .then((value) => transferController.reset())
                                .then((value) => transferController.reset())
                                .then((value) => transferController.reset())
                                .then((value) =>
                                    showToast(transferController.result));
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
                            transferController
                                .uploadTransferToDatabase(widget.Store_id)
                                .then((value) =>
                                    showToast(transferController.result))
                                .then((value) => refreshProducts()
                                    .then((value) => transferController.reset())
                                    .then((value) => transferController.reset())
                                    .then((value) => transferController.reset())
                                    .then((value) => Navigator.pop(context))
                                    .then((value) => Navigator.pop(context)));
                          }
                        } else {
                          //    showToast('Add Products');
                          Get.snackbar('No Products Added!', 'Add Products ');
                        }
                      },
                      child: Text(
                        'Insert Transfer',
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
