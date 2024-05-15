// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_invoice_history.dart';
import 'package:fixnshop_admin/view/new_recharge_invoice.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_types.dart';
import 'package:fixnshop_admin/view/Repairs/repair_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  int _selectedDestination = 0;

    String addCommasToNumber(double value) {
      final formatter = NumberFormat('#,##0.00');
      return formatter.format(value);
    }
  void selectDestination(int index) {
    if (index == 0) {
      Get.to(() => InvoiceHistory());
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
    }  else if (index == 3) {
      Get.to(() => RechargeInvoiceHistory());
      setState(() {
        _selectedDestination = index;
      });
    } else {}
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home Screen'),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.exit_to_app),
              color: Colors.deepPurple,
            )
          ],
        ),
        //  backgroundColor: Colors.deepPurple.shade300,
      ),
      backgroundColor: Colors.grey.shade100,
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
                'AJTech',
                //style: textTheme.headline6,
              ),
            ),
            Divider(
              height: 1,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Invoice History'),
              selected: _selectedDestination == 0,
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              onTap: () => selectDestination(0),
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
                'Label',
              ),
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Recharge History'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 3,
              onTap: () => selectDestination(3),
            ),
          ],
        ),
      ),
      // body: GridView.count(
      //   crossAxisCount: 2,
      //   crossAxisSpacing: 20,
      //   mainAxisSpacing: 20,
      //   padding: EdgeInsets.all(20),
      //   childAspectRatio: 3 / 2,
      //   children: [
      //     Image.asset('assets/nav-drawer-1.jpg'),
      //     Image.asset('assets/nav-drawer-2.jpg'),
      //     Image.asset('assets/nav-drawer-3.jpg'),
      //     Image.asset('assets/nav-drawer-4.jpg'),
      //   ],
      // ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),

            Visibility(
                visible: true,
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      child: Container(
                            width: double.infinity,
                            //     height: double.maxFinite,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Recharge',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(color: Colors.black)),
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
                                    'Invoices Total US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(rechargeInvoiceHistoryController
                                                .total.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Recieved US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(rechargeInvoiceHistoryController
                                                .totalrec.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Due US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(rechargeInvoiceHistoryController
                                                .totaldue.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
                }),
              ),

              SizedBox(height: 20,),
              Visibility(
                visible: true,
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      child: Container(
                            width: double.infinity,
                            //     height: double.maxFinite,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Recharge',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(color: Colors.black)),
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
                                    'Invoices Total US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(invoiceHistoryController
                                                .total.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Recieved US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(invoiceHistoryController
                                                .totalrec.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Invoices Due US:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    addCommasToNumber(invoiceHistoryController
                                                .totaldue.value)
                                            .toString() +
                                        '\$',
                                    style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
                }),
              ),
            
            ],
        ),
      )),
    );
  }
}
