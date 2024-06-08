// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/daily_income_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/daily_income_model.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_due.dart';
import 'package:fixnshop_admin/view/Invoices/invoice_history.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_due.dart';
import 'package:fixnshop_admin/view/Purchase/purchase_history.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_due.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_invoice_history.dart';
import 'package:fixnshop_admin/view/new_recharge_invoice.dart';
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
  RxString Username = ''.obs;
    final DailyIncomeController dailyIncomeController = Get.find<DailyIncomeController>();


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
    } else if (index == 3) {
      Get.to(() => RechargeInvoiceHistory());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 4) {
      Get.to(() => PurchaseHistory());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 5) {
      Get.to(() => InvoiceDue());
      setState(() {
        _selectedDestination = index;
      });
    } 
    else if (index == 6) {
      Get.to(() => PurchaseDue());
      setState(() {
        _selectedDestination = index;
      });
    } else if (index == 7) {
      Get.to(() => RechargeDue());
      setState(() {
        _selectedDestination = index;
      });
    } 
    else {}
  }



  @override
  Widget build(BuildContext context) {
          Username = sharedPreferencesController.username;
       
            // invoiceHistoryController.reset();
            //     invoiceHistoryController.isDataFetched = false;
            //     invoiceHistoryController.fetchinvoices();
            //     rechargeInvoiceHistoryController.reset();
            //     rechargeInvoiceHistoryController.isDataFetched = false;
            //     rechargeInvoiceHistoryController.fetchrechargeInvoice();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home Screen '),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                      dailyIncomeController.isDataFetched = false;
                      dailyIncomeController.fetchincomes();
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
              ],
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
            ),Divider(
              height: 1,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Dues',
              ),
            ),ListTile(
              leading: Icon(Icons.payment),
              title: Text('Invoice Due'),
              selectedTileColor: Color.fromRGBO(13, 134, 151, 1),
              selectedColor: Colors.white,
              selected: _selectedDestination == 5,
              onTap: () => selectDestination(5),
            ),ListTile(
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
          ],
        ),
      ),
      
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {

        },
        child: SafeArea(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Obx(
              () {
                
                if (dailyIncomeController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: dailyIncomeController.daily_income.length,
                    itemBuilder: (context, index) {
                      final DailyIncomeModel value = dailyIncomeController.daily_income[index];
                      return Container(
                        //  width: double.infinity,
                        //   height: 150.0,
                        color: Colors.grey.shade200,
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                        //     padding: EdgeInsets.all(35),
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.perm_contact_cal,
                                color: Colors.blue.shade900,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                value.Source.toUpperCase()
                                // +
                                // ' -- ' +
                                // supplier.Product_Code,
                                ,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.green.shade900,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                  value.Source
                                    // +
                                    // ' -- ' +
                                    // supplier.Product_Code,
                                    ,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: OutlinedButton(
                              onPressed: () {
                                // productController.SelectedPhone.value = product;
                                //       // subcategoryController.selectedSubCategory.value =
                                // //       //     null;

                                // Get.to(() => New_Purchase(
                                //       Supp_id: supplier.Supplier_id.toString(),
                                //       Supp_Name: supplier.Supplier_Name,
                                //       Supp_Number: supplier.Supplier_Number,
                                //     ));
                              },
                              child: Icon(
                                Icons.arrow_right,
                                color: Colors.blue.shade900,
                              )),
                        ),
                      );
                    },
                  );
                }
              },
            ),
              // Visibility(
              //   visible: true,
              //   child: Obx(() {
              //     return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //         child: Card(
              //           child: Container(
              //             width: double.infinity,
              //             //     height: double.maxFinite,
              //             child: InputDecorator(
              //               decoration: InputDecoration(
              //                 labelText: 'Recharge',
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(15.0),
              //                     borderSide: BorderSide(color: Colors.black)),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(15.0),
              //                 child: Column(
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           'Invoices Total US:',
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Row(
              //                           children: [
              //                             Visibility(
              //                                 visible:
              //                                     rechargeInvoiceHistoryController
              //                                         .isLoading.value,
              //                                 child: CircularProgressIndicator()),
              //                             Visibility(
              //                               visible:
              //                                   !rechargeInvoiceHistoryController
              //                                       .isLoading.value,
              //                               child: Text(
              //                                 addCommasToNumber(
              //                                             rechargeInvoiceHistoryController
              //                                                 .total.value)
              //                                         .toString() +
              //                                     '\$',
              //                                 style: TextStyle(
              //                                     color: Colors.blue.shade900,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           'Invoices Recieved US:',
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Row(
              //                           children: [
              //                             Visibility(
              //                                 visible:
              //                                     rechargeInvoiceHistoryController
              //                                         .isLoading.value,
              //                                 child: CircularProgressIndicator()),
              //                             Visibility(
              //                               visible:
              //                                   !rechargeInvoiceHistoryController
              //                                       .isLoading.value,
              //                               child: Text(
              //                                 addCommasToNumber(
              //                                             rechargeInvoiceHistoryController
              //                                                 .totalrec.value)
              //                                         .toString() +
              //                                     '\$',
              //                                 style: TextStyle(
              //                                     color: Colors.green.shade900,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           'Invoices Due US:',
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Row(
              //                           children: [
              //                             Visibility(
              //                                 visible:
              //                                     rechargeInvoiceHistoryController
              //                                         .isLoading.value,
              //                                 child: CircularProgressIndicator()),
              //                             Visibility(
              //                               visible:
              //                                   !rechargeInvoiceHistoryController
              //                                       .isLoading.value,
              //                               child: Text(
              //                                 addCommasToNumber(
              //                                             rechargeInvoiceHistoryController
              //                                                 .totaldue.value)
              //                                         .toString() +
              //                                     '\$',
              //                                 style: TextStyle(
              //                                     color: Colors.red.shade900,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ));
              //   }),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Visibility(
              //   visible: true,
              //   child: Obx(() {
              //     return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //         child: Card(
              //           child: Container(
              //             width: double.infinity,
              //             //     height: double.maxFinite,
              //             child: InputDecorator(
              //               decoration: InputDecoration(
              //                 labelText: 'Invoice',
              //                 enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(15.0),
              //                     borderSide: BorderSide(color: Colors.black)),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(15.0),
              //                 child: Column(
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           'Invoices Total US:',
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Row(
              //                           children: [
              //                             Visibility(
              //                                 visible: invoiceHistoryController
              //                                     .isLoading.value,
              //                                 child: CircularProgressIndicator()),
              //                             Visibility(
              //                               visible: !invoiceHistoryController
              //                                   .isLoading.value,
              //                               child: Text(
              //                                 addCommasToNumber(
              //                                             invoiceHistoryController
              //                                                 .total.value)
              //                                         .toString() +
              //                                     '\$',
              //                                 style: TextStyle(
              //                                     color: Colors.blue.shade900,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           'Invoices Recieved US:',
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Row(
              //                           children: [
              //                             Visibility(
              //                                 visible: invoiceHistoryController
              //                                     .isLoading.value,
              //                                 child: CircularProgressIndicator()),
              //                             Visibility(
              //                               visible: !invoiceHistoryController
              //                                   .isLoading.value,
              //                               child: Text(
              //                                 addCommasToNumber(
              //                                             invoiceHistoryController
              //                                                 .totalrec.value)
              //                                         .toString() +
              //                                     '\$',
              //                                 style: TextStyle(
              //                                     color: Colors.green.shade900,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text(
              //                           'Invoices Due US:',
              //                           style: TextStyle(
              //                               fontWeight: FontWeight.bold),
              //                         ),
              //                         Row(
              //                           children: [
              //                             Visibility(
              //                                 visible: invoiceHistoryController
              //                                     .isLoading.value,
              //                                 child: CircularProgressIndicator()),
              //                             Visibility(
              //                               visible: !invoiceHistoryController
              //                                   .isLoading.value,
              //                               child: Text(
              //                                 addCommasToNumber(
              //                                             invoiceHistoryController
              //                                                 .totaldue.value)
              //                                         .toString() +
              //                                     '\$',
              //                                 style: TextStyle(
              //                                     color: Colors.red.shade900,
              //                                     fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ));
              //   }),
              // ),
            ],
          ),
        )),
      ),
    );
  }
}
