// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/expenses_controller.dart';
import 'package:treschic/controller/imoney_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/invoice_payment_controller.dart';
import 'package:treschic/controller/login_controller.dart';
import 'package:treschic/controller/rate_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/view/Customers/customer_list.dart';
import 'package:treschic/view/Drivers/drivers_list.dart';
import 'package:treschic/view/Expenses/expense_manage.dart';
import 'package:treschic/view/Invoices/invoice_payment_manage.dart';

import 'package:treschic/view/Invoices/invoice_sold_manage.dart';

import 'package:treschic/view/Expenses/buy_expenses.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore_for_file: prefer_const_constructors

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginController loginController = Get.find<LoginController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();

  final RateController rateController = Get.find<RateController>();
  final ExpensesController expensesController = Get.find<ExpensesController>();
  final ImoneyController imoneyController = Get.find<ImoneyController>();
  final InvoicePaymentController invoicePaymentController =
      Get.find<InvoicePaymentController>();
  int _selectedDestination = 0;
  RxString Username = ''.obs;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  TextEditingController DollarAmmount = TextEditingController();
  TextEditingController LebaneseAmmount = TextEditingController();

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  Future<void> _PrintReceipt() async {
    final profile = await CapabilityProfile.load();
    final PaperSize paper = PaperSize.mm80;

    final List<int> bytes = await ReceiptDesign(
      paper,
      profile,
    );
    if (bluetoothController!.isConnected &&
        bluetoothController!.connection != null) {
      try {
        bluetoothController!.connection!.output.add(Uint8List.fromList(bytes));
        await bluetoothController!.connection!.output.allSent;
      } catch (e) {
        print('Error printing: $e');
      }
    } else {
      print('Error: Not connected to a Bluetooth device');
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
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Available Devices'),
          content: Column(
            children: devices.map((device) {
              return Expanded(
                child: ListTile(
                  title: Text(device.name!),
                  onTap: () async {
                    await bluetoothController!.connectToDevice(device);
                    Navigator.pop(context); // Close the dialog after connecting
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
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

    bytes += ticket.text('Treschic Boutique',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += ticket.text(
        sharedPreferencesController.storeName.toUpperCase() + ' Store',
        styles: PosStyles(align: PosAlign.center, bold: true));
    //bytes += ticket.text(Store_Loc!, styles: PosStyles(align: PosAlign.center));

    bytes += ticket.text('+961/${sharedPreferencesController.storeNumber}',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += ticket.text('${sharedPreferencesController.location}',
        styles: PosStyles(align: PosAlign.center, bold: true));
    // bytes += ticket.text('Web: www.treschiclb.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 0);
    bytes += ticket.feed(1);
    bytes += ticket.row([
      PosColumn(
          text: 'Initial Money usd:',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(imoneyController.dollar_money.value) + ' USD',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Initial Money lb:',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text:
              addCommasToNumber(imoneyController.lebanese_money.value) + ' LL',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Invoice Sales:',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(invoiceHistoryController.total_fhome.value) +
              ' USD ',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Old Payments:',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(invoicePaymentController.total_fhome.value) +
              ' USD ',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Expenses:',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text:
              addCommasToNumber(expensesController.total_fhome.value) + ' USD ',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);

    bytes += ticket.text(
        'Total: ${addCommasToNumber(imoneyController.dollar_money.value + (imoneyController.lebanese_money.value / rateController.rateValue.value) + invoiceHistoryController.totalrec_fhome.value + invoicePaymentController.total_fhome.value + -expensesController.total_fhome.value)}',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += ticket.feed(3);

    return bytes;
  }

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  void selectDestination(int index) {
    if (index == 1) {
      Get.to(() => CustomerList(
            from_home: 0,
          ));
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 2) {
      Get.to(() => DriversList());

      setState(() {
        _selectedDestination = index;
      });
    } else {}
  }

  Future<void> refresh_invoice() async {
    invoiceHistoryController.isDataFetched = false;
    invoiceHistoryController.fetchinvoices();
  }

  Future<void> refresh_expense() async {
    expensesController.isDataFetched = false;
    expensesController.fetch_payments();
  }

  Future<void> refresh_imoney() async {
    imoneyController.isDataFetched = false;
    imoneyController.fetch_imoney();
  }

  Future<void> refresh_payments() async {
    invoicePaymentController.isDataFetched = false;
    invoicePaymentController.fetch_payments();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    bool checkResponse(String result) {
      print(result);
      if (result == 'success') {
        return true;
      } else {
        return false;
      }
    }

    Future<void> Close() async {
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      showToast('Logout Failed');
    }

    Future<void> Navigate() async {
      await sharedPreferencesController
          .deleteAllData(); // Delete all stored data
      Get.offAllNamed('LoginScreen');

      showToast('Logout Success');
    }

    Username = sharedPreferencesController.username;
    invoicePaymentController.CalTotal_fhome();
    invoiceHistoryController.CalTotal_fhome();
    invoiceHistoryController.CalTotal_fhome_del();
    invoicePaymentController.CalTotal_fhome();
    invoicePaymentController.CalTotal_fhome_del();

    expensesController.CalTotal_fhome();
    // rechInvoicePaymentController.ca
    // invoiceHistoryController.reset();
    //     invoiceHistoryController.isDataFetched = false;
    //     invoiceHistoryController.fetchinvoices();
    //     rechargeInvoiceHistoryController.reset();
    //     rechargeInvoiceHistoryController.isDataFetched = false;
    //     rechargeInvoiceHistoryController.fetchrechargeInvoice();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Treschic | Homescreen ',
              style: TextStyle(fontSize: 17),
            ),
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
                  IconButton(
                    onPressed: () {
                      refresh_invoice();
                      refresh_expense();
                      refresh_imoney();
                      // invoiceHistoryController.reset();
                      // invoiceHistoryController.isDataFetched = false;
                      // invoiceHistoryController.fetchinvoices();
                      // rechargeInvoiceHistoryController.reset();
                      // rechargeInvoiceHistoryController.isDataFetched = false;
                      // rechargeInvoiceHistoryController.fetchrechargeInvoice();
                    },
                    icon: Icon(Icons.refresh),
                    color: Colors.blue.shade900,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Logout?'),
                                  // content: setupAlertDialoadContainer(),

                                  actions: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      Size(double.infinity, 20),
                                                  backgroundColor: Colors.red,
                                                  side: BorderSide(
                                                      width: 2.0,
                                                      color: Colors.red),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                                  backgroundColor: Colors.green,
                                                  side: BorderSide(
                                                      width: 2.0,
                                                      color: Colors.green),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0),
                                                  ),
                                                ),
                                                onPressed: () {
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
                                                  loginController
                                                      .logoutUser()
                                                      .then((value) =>
                                                          checkResponse(
                                                                  loginController
                                                                      .result2)
                                                              ? Navigate()
                                                              : Close());

                                                  // _showeditAlertDialog(
                                                  //     context,
                                                  //     product_info[index]
                                                  //         .Product_info_id);
                                                  // Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.exit_to_app),
                        color: Colors.blue.shade900,
                      ),
                    ],
                  ),
                  IconButton(
                      color: bluetoothController!.connection == null ||
                              !bluetoothController!.connection!.isConnected
                          ? Colors.red
                          : Colors.green,
                      iconSize: 24.0,
                      icon: Icon(Icons.print),
                      onPressed: () async {
                        if (bluetoothController!.connection == null ||
                            !bluetoothController!.connection!.isConnected) {
                          List<BluetoothDevice> devices = [];
                          try {
                            devices = await FlutterBluetoothSerial.instance
                                .getBondedDevices();
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
                          //   for (int i = 0; i < 3; i++) {
                          _PrintReceipt();
                        }
                      }),
                ],
              ),
            )
          ],
        ),
        //  backgroundColor: Colors.blue.shade900.shade300,
      ),
      // backgroundColor: Colors.white,
      //drawer: Navigat,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 46,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Treschic Boutique -- ${sharedPreferencesController.userRole.value}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                      '${sharedPreferencesController.storeName.value} Store | ${sharedPreferencesController.storeNumber.value}'), // Display store name

                  Text('${sharedPreferencesController.location.value}'),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Actions',
              ),
            ),
            ListTile(
              leading: Icon(Icons.sell),
              title: Text('Create Invoice'),
              selected: _selectedDestination == 1,
              selectedTileColor: Colors.green.shade100,
              selectedColor: Colors.green.shade900,
              onTap: () => selectDestination(1),
            ),
            ListTile(
              leading: Icon(Icons.delivery_dining),
              title: Text('Create Delivery Invoice'),
              selected: _selectedDestination == 2,
              selectedTileColor: Colors.green.shade100,
              selectedColor: Colors.green.shade900,
              onTap: () => selectDestination(2),
            ),

            Divider(
              height: 1,
              thickness: 1,
            ),

            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Extras',
            //   ),
            // ),
            // // ListTile(
            //   leading: Icon(Icons.attach_money_outlined),
            //   title: Text('Recharge Balances'),
            //   selectedTileColor: Colors.green.shade100,
            //   selectedColor: Colors.green.shade900,
            //   selected: _selectedDestination == 8,
            //   onTap: () => selectDestination(8),
            // ),

            // ListTile(
            //   leading: Icon(Icons.attach_money_outlined),
            //   title: Text('Stores'),
            //   selectedTileColor: Colors.green.shade100,
            //   selectedColor: Colors.green.shade900,
            //   selected: _selectedDestination == 15,
            //   onTap: () => selectDestination(15),
            // ),
          ],
        ),
      ),

      body: PopScope(
        canPop: false,
        child: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       labelText: 'Actions',
              //       enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //           borderSide: BorderSide(color: Colors.black)),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Column(
              //           children: [
              //             IconButton(
              //                 onPressed: () {
              //                   Get.to(() => CustomerList(
              //                         from_home: 0,
              //                       ));
              //                 },
              //                 icon: Icon(
              //                   FontAwesomeIcons.fileInvoiceDollar,
              //                   color: Colors.green.shade900,
              //                 )),
              //             Text('Invoice')
              //           ],
              //         ),
              //         Column(
              //           children: [
              //             IconButton(
              //                 onPressed: () {
              //                   Get.to(() => DriversList());
              //                 },
              //                 icon: Icon(
              //                   FontAwesomeIcons.fileInvoiceDollar,
              //                   color: Colors.green.shade900,
              //                 )),
              //             Text('Delivery Invoice')
              //           ],
              //         ),
              //         Column(
              //           children: [
              //             IconButton(
              //                 onPressed: () {
              //                   Get.to(() => CustomerListFrecharge());
              //                 },
              //                 icon: Icon(
              //                   FontAwesomeIcons.moneyBillTrendUp,
              //                   color: Colors.green.shade900,
              //                 )),
              //             Text('Recharge')
              //           ],
              //         ),
              //         Column(
              //           children: [
              //             IconButton(
              //                 onPressed: () {
              //                   Get.to(() => CustomerListFrepair());
              //                 },
              //                 icon: Icon(
              //                   Icons.mobile_friendly,
              //                   color: Colors.green.shade900,
              //                 )),
              //             Text('Repair')
              //           ],
              //         ),
              //         Column(
              //           children: [
              //             IconButton(
              //                 onPressed: () {
              //                   Get.to(() => RechargeBalance());
              //                 },
              //                 icon: Icon(
              //                   FontAwesomeIcons.creditCard,
              //                   color: Colors.blue.shade900,
              //                 )),
              //             Text('Balance')
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text('Initial Money ',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Obx(() {
                            if (imoneyController.isLoading.value ||
                                imoneyController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        border: Border.all(
                                            color: Colors.blue.shade900),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Initial Money Statement '),
                                                content: Column(
                                                  children: [
                                                    TextFormField(
                                                      onChanged: (value) {
                                                        DollarAmmount.text =
                                                            value;
                                                      },
                                                      //maxLength: 15,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      //controller: Product_Name,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Dollar Ammount ",
                                                        labelStyle: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        fillColor: Colors.black,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextFormField(
                                                      onChanged: (value) {
                                                        LebaneseAmmount.text =
                                                            value;
                                                      },
                                                      //maxLength: 15,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      //controller: Product_Name,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Lebanese Ammount ",
                                                        labelStyle: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        fillColor: Colors.black,
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      DollarAmmount.clear();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (DollarAmmount.text !=
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
                                                                child: Padding(
                                                                  padding: const EdgeInsets
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
                                                        imoneyController.InsertInitialMoney(
                                                                DollarAmmount
                                                                    .text,
                                                                LebaneseAmmount
                                                                    .text)
                                                            .then((value) => showToast(
                                                                imoneyController
                                                                    .result2))
                                                            .then((value) =>
                                                                imoneyController
                                                                        .isDataFetched =
                                                                    false)
                                                            .then((value) =>
                                                                imoneyController
                                                                    .fetch_imoney())
                                                            .then((value) =>
                                                                Navigator.of(context)
                                                                    .pop())
                                                            .then((value) =>
                                                                Navigator.of(context).pop());

                                                        DollarAmmount.clear();
                                                      } else {
                                                        Get.snackbar('Error',
                                                            'Add Ammount');
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
                                        icon: Icon(Icons.add_outlined,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            border: Border.all(
                                                color: Colors.blue.shade900),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Dollar Total:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            addCommasToNumber(imoneyController
                                                                        .dollar_money
                                                                        .value)
                                                                    .toString() +
                                                                '\$',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Lebanese Total:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            addCommasToNumber(imoneyController
                                                                        .lebanese_money
                                                                        .value)
                                                                    .toString() +
                                                                ' LL',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment.spaceBetween,
                                                      //   children: [
                                                      //     Text(
                                                      //       'Recharge Payments Total:',
                                                      //       style:
                                                      //           TextStyle(fontWeight: FontWeight.bold),
                                                      //     ),
                                                      //     Text(
                                                      //       addCommasToNumber(
                                                      //                   rechInvoicePaymentController
                                                      //                       .total_fhome.value / rateController.rateValue.value)
                                                      //               .toString() +
                                                      //           '\$',
                                                      //       style: TextStyle(
                                                      //           color: Colors.green.shade900,
                                                      //           fontWeight: FontWeight.bold),
                                                      //     )
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          })),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: double.infinity,
                          lineThickness: 2.0,
                          dashLength: 4.0,
                          dashColor: Colors.black,
                          dashGradient: [Colors.black, Colors.black],
                          dashRadius: 1.0,
                          dashGapLength: 1.0,
                          dashGapColor: Colors.transparent,
                          dashGapGradient: [Colors.white, Colors.white],
                          dashGapRadius: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text('Income ',
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Obx(() {
                            if (invoiceHistoryController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => InvoiceSoldManage());
                                  },
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        border: Border.all(
                                            color: Colors.green.shade900),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Store Invoice Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  addCommasToNumber(
                                                              invoiceHistoryController
                                                                  .total_fhome
                                                                  .value)
                                                          .toString() +
                                                      '\$',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Delivery Invoice Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  addCommasToNumber(
                                                              invoiceHistoryController
                                                                  .total_fhome_del
                                                                  .value)
                                                          .toString() +
                                                      '\$',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          })),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: double.infinity,
                          lineThickness: 2.0,
                          dashLength: 4.0,
                          dashColor: Colors.black,
                          dashGradient: [Colors.black, Colors.black],
                          dashRadius: 1.0,
                          dashGapLength: 1.0,
                          dashGapColor: Colors.transparent,
                          dashGapGradient: [Colors.white, Colors.white],
                          dashGapRadius: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text('Old Payments',
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Obx(() {
                            if (invoiceHistoryController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => InvoicePaymentManage());
                                  },
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        border: Border.all(
                                            color: Colors.green.shade900),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Store Invoice Payment Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  addCommasToNumber(
                                                              invoicePaymentController
                                                                  .total_fhome
                                                                  .value)
                                                          .toString() +
                                                      '\$',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Delivery Invoice Payment Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  addCommasToNumber(
                                                              invoicePaymentController
                                                                  .total_fhome_del
                                                                  .value)
                                                          .toString() +
                                                      '\$',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          })),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: double.infinity,
                          lineThickness: 2.0,
                          dashLength: 4.0,
                          dashColor: Colors.black,
                          dashGradient: [Colors.black, Colors.black],
                          dashRadius: 1.0,
                          dashGapLength: 1.0,
                          dashGapColor: Colors.transparent,
                          dashGapGradient: [Colors.white, Colors.white],
                          dashGapRadius: 1.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text('Expenses ',
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Obx(() {
                            if (invoiceHistoryController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          border: Border.all(
                                              color: Colors.red.shade900),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Get.to(() => BuyExpenses());
                                          },
                                          icon: Icon(Icons.add_outlined,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => ExpenseManage());
                                          },
                                          child: Card(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade100,
                                                border: Border.all(
                                                    color: Colors.red.shade900),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Expenses Total:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          addCommasToNumber(
                                                                      expensesController
                                                                          .total_fhome
                                                                          .value)
                                                                  .toString() +
                                                              '\$',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red.shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment.spaceBetween,
                                                    //   children: [
                                                    //     Text(
                                                    //       'Recharge Payments Total:',
                                                    //       style:
                                                    //           TextStyle(fontWeight: FontWeight.bold),
                                                    //     ),
                                                    //     Text(
                                                    //       addCommasToNumber(
                                                    //                   rechInvoicePaymentController
                                                    //                       .total_fhome.value / rateController.rateValue.value)
                                                    //               .toString() +
                                                    //           '\$',
                                                    //       style: TextStyle(
                                                    //           color: Colors.green.shade900,
                                                    //           fontWeight: FontWeight.bold),
                                                    //     )
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       'Recharge Payments Total:',
                                  //       style:
                                  //           TextStyle(fontWeight: FontWeight.bold),
                                  //     ),
                                  //     Text(
                                  //       addCommasToNumber(
                                  //                   rechInvoicePaymentController
                                  //                       .total_fhome.value / rateController.rateValue.value)
                                  //               .toString() +
                                  //           '\$',
                                  //       style: TextStyle(
                                  //           color: Colors.green.shade900,
                                  //           fontWeight: FontWeight.bold),
                                  //     )
                                  //   ],
                                  // ),

                                  );
                            }
                          })),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Obx(() {
                    if (invoiceHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              //color: Colors.blue.shade100,
                              border: Border.all(color: Colors.grey.shade900),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        addCommasToNumber(imoneyController
                                                        .dollar_money.value +
                                                    invoiceHistoryController
                                                        .total_fhome_del.value +
                                                    invoicePaymentController
                                                        .total_fhome_del.value +
                                                    (imoneyController.lebanese_money.value /
                                                        rateController
                                                            .rateValue.value) +
                                                    invoiceHistoryController
                                                        .totalrec_fhome.value +
                                                    invoicePaymentController
                                                        .total_fhome.value +
                                                    -expensesController
                                                        .total_fhome.value)
                                                .toString() +
                                            '\$',
                                        style: TextStyle(
                                            color: Colors.black,
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
                    }
                  }),
                  SizedBox(height: 5)
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
