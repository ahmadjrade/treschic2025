// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/credit_balance_controller.dart';
import 'package:fixnshop_admin/controller/expenses_controller.dart';
import 'package:fixnshop_admin/controller/imoney_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/login_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/rech_invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/recharge_balance_model.dart';
import 'package:fixnshop_admin/view/Customers/customer_list.dart';
import 'package:fixnshop_admin/view/Drivers/customer_list_delivery.dart';
import 'package:fixnshop_admin/view/Drivers/drivers_list.dart';
import 'package:fixnshop_admin/view/Expenses/expense_manage.dart';
import 'package:fixnshop_admin/view/Invoices/customer_list_finvhistory.dart';
import 'package:fixnshop_admin/view/Invoices/driver_list_finvhistory.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_due.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_by_customer.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_by_driver.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_sold_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_today_items.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_due.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history11.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/customer_list_frecharge.dart';
import 'package:fixnshop_admin/view/Recharge/rech_invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_balances.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_due.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_invoice_history.dart';
import 'package:fixnshop_admin/view/Repairs/customer_list_frepair.dart';
import 'package:fixnshop_admin/view/Repairs/repair_manage.dart';
import 'package:fixnshop_admin/view/Repairs/repair_product_list.dart';
import 'package:fixnshop_admin/view/Transfer/stores_list_ftransfer.dart';
import 'package:fixnshop_admin/view/Transfer/transfer_history_manage.dart';
import 'package:fixnshop_admin/view/buy_expenses.dart';
import 'package:fixnshop_admin/view/Recharge/new_recharge_invoice.dart';
import 'package:fixnshop_admin/view/Repairs/pending_repair.dart';
import 'package:fixnshop_admin/view/stores_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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
  final RechargeInvoiceHistoryController rechargeInvoiceHistoryController =
      Get.find<RechargeInvoiceHistoryController>();
  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();
  final RechargeBalanceController rechargeBalanceController =
      Get.find<RechargeBalanceController>();
  final RechInvoicePaymentController rechInvoicePaymentController =
      Get.find<RechInvoicePaymentController>();
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
    bytes += ticket.text('Mile To Smile',
        styles: PosStyles(
          align: PosAlign.center,
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
    } else if (index == 3) {
      Get.to(() => CustomerListFrecharge());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 4) {
      Get.to(() => CustomerListFrepair());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 5) {
      Get.to(() => RepairManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 6) {
      Get.to(() => RechargeBalance());
      setState(() {
        _selectedDestination = index;
      });
    } else {}
  }

  Future<void> refresh_recharge() async {
    rechargeInvoiceHistoryController.isDataFetched = false;
    rechargeInvoiceHistoryController.fetchrechargeInvoice();
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
    rechInvoicePaymentController.CalTotal_fhome();
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
            Text('Home Screen '),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    rechargeBalanceController.isDataFetched = false;
                    rechargeBalanceController.fetch_cart_types();
                    refresh_recharge();
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
                  color: Colors.deepPurple,
                ),
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
                                                width: 2.0, color: Colors.red),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
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
                                            backgroundColor: Colors.green,
                                            side: BorderSide(
                                                width: 2.0,
                                                color: Colors.green),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
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
                                            loginController.logoutUser().then(
                                                (value) => checkResponse(
                                                        loginController.result2)
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
                  },
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.deepPurple,
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
            )
          ],
        ),
        //  backgroundColor: Colors.deepPurple.shade300,
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
                    'AJTECH -- ${sharedPreferencesController.userRole.value}',
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
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Create Recharge Invoice'),
              selected: _selectedDestination == 3,
              selectedTileColor: Colors.green.shade100,
              selectedColor: Colors.green.shade900,
              onTap: () => selectDestination(3),
            ),
            ListTile(
              leading: Icon(Icons.mobile_off),
              title: Text('Create Repair Invoice'),
              selected: _selectedDestination == 4,
              selectedTileColor: Colors.green.shade100,
              selectedColor: Colors.green.shade900,
              onTap: () => selectDestination(4),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Manage',
              ),
            ),
            ListTile(
              leading: Icon(Icons.mobile_friendly_sharp),
              title: Text('Repairs'),
              selected: _selectedDestination == 5,
              selectedTileColor: Colors.green.shade100,
              selectedColor: Colors.green.shade900,
              onTap: () => selectDestination(5),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Recharge Balance'),
              selected: _selectedDestination == 6,
              selectedTileColor: Colors.green.shade100,
              selectedColor: Colors.green.shade900,
              onTap: () => selectDestination(6),
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
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                                              TextInputType
                                                                  .number,
                                                          //controller: Product_Name,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Dollar Ammount ",
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            fillColor:
                                                                Colors.black,
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .black,
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
                                                                color: Colors
                                                                    .black,
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
                                                            LebaneseAmmount
                                                                .text = value;
                                                          },
                                                          //maxLength: 15,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          //controller: Product_Name,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Lebanese Ammount ",
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            fillColor:
                                                                Colors.black,
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .black,
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
                                                                color: Colors
                                                                    .black,
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
                                                          if (DollarAmmount
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
                                                            imoneyController.InsertInitialMoney(
                                                                    DollarAmmount
                                                                        .text,
                                                                    LebaneseAmmount
                                                                        .text)
                                                                .then((value) =>
                                                                    showToast(imoneyController
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

                                                            DollarAmmount
                                                                .clear();
                                                          } else {
                                                            Get.snackbar(
                                                                'Error',
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
                                                color: Colors.green.shade900),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      addCommasToNumber(
                                                                  imoneyController
                                                                      .dollar_money
                                                                      .value)
                                                              .toString() +
                                                          '\$',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue.shade900,
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
                                                      'Lebanese Total:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      addCommasToNumber(
                                                                  imoneyController
                                                                      .lebanese_money
                                                                      .value)
                                                              .toString() +
                                                          ' LL',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue.shade900,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                            if (rechargeBalanceController.isLoading.value ||
                                invoiceHistoryController.isLoading.value) {
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                                  'Invoice Total:',
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
                                                  'Recharge Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  addCommasToNumber(
                                                              rechargeInvoiceHistoryController
                                                                  .totalrec_fhome
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
                            if (rechargeBalanceController.isLoading.value ||
                                invoiceHistoryController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Invoice Payment Total:',
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Recharge Payments Total:',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                addCommasToNumber(
                                                            rechInvoicePaymentController
                                                                    .total_fhome
                                                                    .value /
                                                                rateController
                                                                    .rateValue
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
                            if (rechargeBalanceController.isLoading.value ||
                                invoiceHistoryController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => BuyExpenses());
                                  },
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                                  'Expenses Total:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  addCommasToNumber(
                                                              expensesController
                                                                  .total_fhome
                                                                  .value)
                                                          .toString() +
                                                      '\$',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade900,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                    if (rechargeBalanceController.isLoading.value ||
                        invoiceHistoryController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Card(
                          child: Container(
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
                                                    (imoneyController.lebanese_money.value /
                                                        rateController
                                                            .rateValue.value) +
                                                    rechargeInvoiceHistoryController
                                                        .totalrec_fhome.value +
                                                    invoiceHistoryController
                                                        .totalrec_fhome.value +
                                                    invoicePaymentController
                                                        .total_fhome.value +
                                                    (rechInvoicePaymentController
                                                            .total_fhome.value /
                                                        rateController
                                                            .rateValue.value) -
                                                    expensesController
                                                        .total_fhome.value)
                                                .toString() +
                                            '\$',
                                        style: TextStyle(
                                            color: Colors.green.shade900,
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
