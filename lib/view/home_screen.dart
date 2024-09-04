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
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/rech_invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/recharge_balance_model.dart';
import 'package:fixnshop_admin/view/Customers/customer_list.dart';
import 'package:fixnshop_admin/view/Expenses/expense_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_due.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history_manage.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_due.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history_manage.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/rech_invoice_payment_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_balances.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_due.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_history_manage.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_invoice_history.dart';
import 'package:fixnshop_admin/view/Repairs/repair_product_list.dart';
import 'package:fixnshop_admin/view/buy_expenses.dart';
import 'package:fixnshop_admin/view/new_recharge_invoice.dart';
import 'package:fixnshop_admin/view/Repairs/repair_history.dart';
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
    if (index == 0) {
      Get.to(() => InvoiceHistoryManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 1) {
      Get.to(() => RepairHistory());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 2) {
      Get.to(() => NewRechargeInvoice());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 3) {
      Get.to(() => RechargeHistoryManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 4) {
      Get.to(() => PurchaseHistoryManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 5) {
      Get.to(() => InvoiceDue());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 6) {
      Get.to(() => PurchaseDue());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 7) {
      Get.to(() => RechargeDue());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 8) {
      Get.to(() => RechargeBalance());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 9) {
      Get.to(() => RepairProductList(
            isPur: 1,
          ));
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 10) {
      Get.to(() => InvoicePaymentManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 10) {
      Get.to(() => InvoicePaymentManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 11) {
      Get.to(() => PurchasePaymentManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 12) {
      Get.to(() => RechInvoicePaymentManage());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 13) {
      Get.to(() => ExpenseManage());
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
        backgroundColor: Colors.white,
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
                    Navigator.of(context).pop();
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
      backgroundColor: Colors.white,
      //drawer: Navigat,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 75,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'AJTech | $Username Store',
                //style: textTheme.headline6,
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
            ListTile(
              leading: Icon(Icons.phonelink_setup_sharp),
              title: Text('Repairs'),
              selected: _selectedDestination == 1,
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              onTap: () => selectDestination(1),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Recharge'),
              selected: _selectedDestination == 2,
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              onTap: () => selectDestination(2),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'History',
              ),
            ),
            ListTile(
              leading: Icon(Icons.history_outlined),
              title: Text('Invoice History'),
              selected: _selectedDestination == 0,
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              onTap: () => selectDestination(0),
            ),
            ListTile(
              leading: Icon(Icons.history_outlined),
              title: Text('Recharge History'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 3,
              onTap: () => selectDestination(3),
            ),
            ListTile(
              leading: Icon(Icons.history_outlined),
              title: Text('Purchase History'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 4,
              onTap: () => selectDestination(4),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Dues',
              ),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Invoice Due'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 5,
              onTap: () => selectDestination(5),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Purchase Due'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 6,
              onTap: () => selectDestination(6),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Recharge Due'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 7,
              onTap: () => selectDestination(7),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Payments',
              ),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Invoice Payments'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 10,
              onTap: () => selectDestination(10),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Purchase Payments'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 11,
              onTap: () => selectDestination(11),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Recharge Payments'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 12,
              onTap: () => selectDestination(12),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Extras',
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.attach_money_outlined),
            //   title: Text('Recharge Balances'),
            //   selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
            //   selectedColor: Colors.white,
            //   selected: _selectedDestination == 8,
            //   onTap: () => selectDestination(8),
            // ),
            ListTile(
              leading: Icon(Icons.attach_money_outlined),
              title: Text('Repair Prodcuts'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 9,
              onTap: () => selectDestination(9),
            ),
            ListTile(
              leading: Icon(Icons.attach_money_outlined),
              title: Text('Expenses'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 13,
              onTap: () => selectDestination(13),
            ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Actions',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => CustomerList());
                              },
                              icon: Icon(
                                FontAwesomeIcons.fileInvoiceDollar,
                                color: Colors.green.shade700,
                              )),
                          Text('Invoice')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => NewRechargeInvoice());
                              },
                              icon: Icon(
                                FontAwesomeIcons.moneyBillTrendUp,
                                color: Colors.green.shade700,
                              )),
                          Text('Recharge')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => BuyExpenses());
                              },
                              icon: Icon(
                                FontAwesomeIcons.dollarSign,
                                color: Colors.red.shade700,
                              )),
                          Text('Expense')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(() => RechargeBalance());
                              },
                              icon: Icon(
                                FontAwesomeIcons.creditCard,
                                color: Colors.blue.shade700,
                              )),
                          Text('Balance')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // SizedBox(height: 12,),
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //     child: InputDecorator(
                      //             decoration: InputDecoration(
                      //               labelText: 'Recharge Balances',
                      //               enabledBorder: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.circular(15.0),
                      //                   borderSide: BorderSide(color: Colors.black)),
                      //             ),
                      //       child: Obx(
                      //       () {
                      //         final List<RechargeBalanceModel> filteredcarts =
                      //             rechargeBalanceController.searchTypes(Username.value);
                      //         if (rechargeBalanceController.isLoading.value) {
                      //           return Center(child: CircularProgressIndicator());
                      //         } else if (rechargeBalanceController.balance.isEmpty) {
                      //           return Center(
                      //               child: Text('No Recharge Balances Yet ! Add Some '));
                      //         } else {
                      //           return ListView.builder(

                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             itemCount: filteredcarts.length,
                      //             itemBuilder: (context, index) {
                      //               final RechargeBalanceModel balance = filteredcarts[index];
                      //               return Padding(
                      //                 padding: const EdgeInsets.symmetric(horizontal:  10.0),
                      //                 child: Card(
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.blue.shade100,
                      //                       borderRadius: BorderRadius.circular(10)
                      //                     ),

                      //                     alignment: Alignment.center,
                      //                     child:

                      //                           Padding(
                      //                             padding: const EdgeInsets.all(15.0),
                      //                             child: Row(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment.spaceBetween,
                      //                               children: [
                      //                                 Row(
                      //                                   children: [

                      //                                     Text(
                      //                                       balance.Credit_Type

                      //                                       ,
                      //                                       style: TextStyle(
                      //                                           fontWeight: FontWeight.bold,
                      //                                            ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                                 Text(
                      //                                   addCommasToNumber(balance.Credit_Balance)
                      //                                       .toString()
                      //                                   // +
                      //                                   // ' -- ' +
                      //                                   // balance.cart_Code,
                      //                                   ,
                      //                                   style: TextStyle(
                      //                               color: Colors.blue.shade900,
                      //                               fontWeight: FontWeight.bold),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),

                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //           );
                      //         }
                      //       },
                      //                         ),
                      //     ),
                      //   ),
                      SizedBox(
                        height: 15,
                      ),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Initial Money',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              child: Obx(() {
                                if (imoneyController.isLoading.value ||
                                    imoneyController.isLoading.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                                            SizedBox(height: 20,),
                                                            TextFormField(
                                                          onChanged: (value) {
                                                            LebaneseAmmount.text =
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              DollarAmmount
                                                                  .clear();
                                                            },
                                                            child:
                                                                Text('Cancel'),
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
                                                                    builder:
                                                                        (_) {
                                                                      return Dialog(
                                                                        // The background color
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 20),
                                                                          child:
                                                                              Column(
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
                                                                imoneyController.InsertInitialMoney(
                                                                       
                                                                        DollarAmmount
                                                                            .text,LebaneseAmmount.text)
                                                                    .then((value) =>
                                                                        showToast(
                                                                            imoneyController
                                                                                .result2))
                                                                    .then((value) =>
                                                                        imoneyController.isDataFetched =
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
                                                    color:
                                                        Colors.green.shade900),
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
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          addCommasToNumber(
                                                                      imoneyController
                                                                          .dollar_money
                                                                          .value)
                                                                  .toString() +
                                                              '\$',
                                                          style: TextStyle(
                                                              color: Colors.blue
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
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          addCommasToNumber(
                                                                      imoneyController
                                                                          .lebanese_money
                                                                          .value)
                                                                  .toString() +
                                                              ' LL',
                                                          style: TextStyle(
                                                              color: Colors.blue
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
                                  );
                                }
                              }))),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Income',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              child: Obx(() {
                                if (rechargeBalanceController.isLoading.value ||
                                    invoiceHistoryController.isLoading.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                                        color: Colors
                                                            .green.shade900,
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
                                                        color: Colors
                                                            .green.shade900,
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
                              }))),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Old Payments',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              child: Obx(() {
                                if (rechargeBalanceController.isLoading.value ||
                                    invoiceHistoryController.isLoading.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                        color: Colors
                                                            .green.shade900,
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
                                                    'Recharge Payments Total:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    addCommasToNumber(rechInvoicePaymentController
                                                                    .total_fhome
                                                                    .value /
                                                                rateController
                                                                    .rateValue
                                                                    .value)
                                                            .toString() +
                                                        '\$',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green.shade900,
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
                              }))),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Expenses',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                              child: Obx(() {
                                if (rechargeBalanceController.isLoading.value ||
                                    invoiceHistoryController.isLoading.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
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
                                  );
                                }
                              }))),
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
