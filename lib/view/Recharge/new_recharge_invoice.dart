// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/platform_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/controller/recharge_detail_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_carts.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewRechargeInvoice extends StatefulWidget {
  String Cus_id, Cus_Name, Cus_Number;

  NewRechargeInvoice(
      {super.key,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number});

  @override
  State<NewRechargeInvoice> createState() => _NewRechargeInvoiceState();
}

class _NewRechargeInvoiceState extends State<NewRechargeInvoice> {
  TextEditingController New_Price = TextEditingController();

  TextEditingController New_Qty = TextEditingController();
  final PlatformController platformController = Get.find<PlatformController>();

  final RechargeCartController rechargeCartController =
      Get.find<RechargeCartController>();

  final RechargeInvoiceHistoryController rechargeInvoiceHistoryController =
      Get.find<RechargeInvoiceHistoryController>();

  // final InvoiceController rechargeDetailController = Get.put(InvoiceController());
  final RateController rateController = Get.find<RateController>();

  final CustomerController customerController = Get.find<CustomerController>();

  final RechargeDetailController rechargeDetailController =
      Get.find<RechargeDetailController>();

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();
  TextEditingController rec_usd_controller = TextEditingController();
  TextEditingController rec_lb_controller = TextEditingController();

  TextEditingController i = TextEditingController();
  Future<void> refresh_history() async {
    rechargeInvoiceHistoryController.isDataFetched = false;
    rechargeInvoiceHistoryController.fetchrechargeInvoice();
    // productDetailController.fetchproductdetails();
  }

  Future<void> refreshRate() async {
    rateController.isDataFetched = false;
    rateController.fetchrate();
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
                      refresh_history()
                          .then((value) =>
                              rechargeCartController.isDataFetched = false)
                          .then((value) =>
                              rechargeCartController.fetch_recharge_carts())
                          .then((value) => rechargeCartController.reset())
                          .then((value) => rechargeCartController.reset())
                          .then((value) => rechargeCartController.reset())
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
    if (rechargeCartController.result == 'Invoice Sent Successfully') {
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
          refresh_history()
              .then((value) => rechargeDetailController.isDataFetched = false)
              .then((value) => rechargeDetailController.fetchrecdetails())
              .then((value) => rechargeCartController.reset())
              .then((value) => rechargeCartController.reset())
              .then((value) => rechargeCartController.reset())
              .then((value) => Navigator.of(context).pop())
              .then((value) => Navigator.of(context).pop());
        }
      } else {
        print('Already connected');
        rechargeCartController.PrintReceipt()
            .then((value) => refresh_history()
                .then((value) => rechargeCartController.isDataFetched = false)
                .then((value) => rechargeCartController.fetch_recharge_carts()))
            .then((value) => rechargeCartController.reset())
            .then((value) => rechargeCartController.reset())
            .then((value) => rechargeCartController.reset())
            .then((value) => Navigator.of(context).pop())
            .then((value) => Navigator.of(context).pop());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    rechargeCartController.ReceivedUSD.value = 0;
    rechargeCartController.ReceivedLb.value = 0;
    rechargeCartController.calculateDueLB();

    //  rechargeDetailController.reset();

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recharge Invoice'),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  //  refreshProducts();
                  refreshRate();
                },
                icon: Icon(CupertinoIcons.refresh),
              ),
            ],
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.blue.shade100,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => RechargeTypes());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Cards',
                          style: TextStyle(color: Colors.blue.shade900),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.arrow_circle_right,
                            color: Colors.blue.shade900)
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Obx(() {
                  return Column(children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Recharge Cards',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: rechargeCartController.InvoiceCards.length,
                        itemBuilder: (context, index) {
                          var card = rechargeCartController.InvoiceCards[index];
                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    card.Card_Image == null ||
                                            card.Card_Image == ''
                                        ? SizedBox(
                                            width: 50,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'No Image',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Icon(
                                                  Icons.error,
                                                ),
                                              ],
                                            ))
                                        : CachedNetworkImage(
                                            width: 50,
                                            imageUrl: card.Card_Image!,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            card.Card_Name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            addCommasToNumber(card.Card_Price)
                                                    .toString() +
                                                ' LL',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.green.shade900),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(() {
                                      return Row(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  if (card.quantity.value ==
                                                      1) {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
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
                                                                            fixedSize:
                                                                                Size(double.infinity, 20),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            side:
                                                                                BorderSide(width: 2.0, color: Colors.red),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(32.0),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
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
                                                                            fixedSize:
                                                                                Size(double.infinity, 20),
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            side:
                                                                                BorderSide(width: 2.0, color: Colors.green),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(32.0),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            rechargeCartController.InvoiceCards.removeAt(index);
                                                                            Navigator.of(context).pop();
                                                                            rechargeCartController.calculateTotalLb();
                                                                            rechargeCartController.calculateTotalQty();
                                                                            rechargeCartController.calculateDueLB();

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
                                                    rechargeCartController
                                                        .DecreaseQty(
                                                            rechargeCartController
                                                                    .InvoiceCards[
                                                                index]);
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24)),
                                                //width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    card.quantity.toString(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              rechargeCartController
                                                  .IncreaseQty(
                                                      rechargeCartController
                                                          .InvoiceCards[index]);
                                            },
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                rechargeCartController
                                                        .InvoiceCards
                                                    .removeAt(index);
                                                rechargeCartController
                                                    .calculateTotalLb();
                                                rechargeCartController
                                                    .calculateTotalQty();
                                                rechargeCartController
                                                    .calculateDueLB();
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        ],
                                      );
                                    })
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
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
                          labelText: 'Invoice Information',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Rate: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '${rateController.rateValue.value}'),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Item Count: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${rechargeCartController.totalQty.toString()}'),
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
                                    Text('Invoice Total: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      addCommasToNumber(rechargeCartController
                                              .totalLb.value) +
                                          ' \LL',
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
                                      'Invoice Total US: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      addCommasToNumber(rechargeCartController
                                                  .totalLb.value /
                                              rateController.rateValue.value) +
                                          ' \$',
                                      style: TextStyle(
                                        color: Colors.green.shade900,
                                      ),
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
                                    Text('Invoice Due LB: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    GestureDetector(
                                      onLongPress: () {
                                        // copyToClipboard(
                                        //     rechargeDetailController.DueLB.value);
                                      },
                                      child: Text(
                                        addCommasToNumber(rechargeCartController
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Invoice Due USD: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    GestureDetector(
                                      onLongPress: () {
                                        // copyToClipboard(
                                        //     rechargeDetailController.DueLB.value);
                                      },
                                      child: Text(
                                        addCommasToNumber(rechargeCartController
                                                    .DueLB.value /
                                                rateController
                                                    .rateValue.value) +
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
                                            rechargeCartController
                                                .resetRecUsd();
                                          } else {
                                            rechargeCartController
                                                    .ReceivedUSD.value =
                                                double.tryParse(Value)!;

                                            rechargeCartController
                                                .calculateDueLB();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              rec_usd_controller.clear();
                                              rechargeCartController
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
                                            rechargeCartController.resetRecLb();
                                          } else {
                                            rechargeCartController
                                                    .ReceivedLb.value =
                                                double.tryParse(value)!;
                                            rechargeCartController
                                                .calculateDueLB();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              rec_lb_controller.clear();
                                              rechargeCartController
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ));
                }),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 50),
                          backgroundColor: Colors.blue.shade100,
                          side: BorderSide(
                              width: 2.0, color: Colors.blue.shade900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          if (rechargeCartController.InvoiceCards.isNotEmpty) {
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
                              rechargeCartController
                                  .uploadInvoiceToDatabase(widget.Cus_id,
                                      widget.Cus_Name, widget.Cus_Number)
                                  .then((value) =>
                                      showToast(rechargeCartController.result))
                                  .then((value) => CheckPrinter());
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
                              rechargeCartController
                                  .uploadInvoiceToDatabase(widget.Cus_id,
                                      widget.Cus_Name, widget.Cus_Number)
                                  .then((value) =>
                                      showToast(rechargeCartController.result))
                                  .then((value) => refresh_history()
                                      .then((value) => rechargeCartController
                                          .isDataFetched = false)
                                      .then((value) => rechargeCartController
                                          .fetch_recharge_carts())
                                      .then((value) =>
                                          rechargeCartController.reset())
                                      .then((value) =>
                                          rechargeCartController.reset())
                                      .then((value) =>
                                          rechargeCartController.reset())
                                      .then(
                                          (value) => Navigator.of(context).pop())
                                      .then((value) => Navigator.of(context).pop())
                                      .then((value) => Navigator.of(context).pop())
                                      .then((value) => rechargeInvoiceHistoryController.CalTotal_fhome()));
                            }
                          } else {
                            Get.snackbar('No Products Added!', 'Add Products ');
                          }
                        },
                        child: Text(
                          'Insert Invoice',
                          style: TextStyle(color: Colors.blue.shade900),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
