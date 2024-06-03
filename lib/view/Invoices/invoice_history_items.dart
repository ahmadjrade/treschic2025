// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

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
import 'package:get/get.dart';

class InvoiceHistoryItems extends StatelessWidget {
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
  final InvoiceDetailController invoiceDetailController =
      Get.find<InvoiceDetailController>();
  TextEditingController New_Qty = TextEditingController();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
    final RxString filter = ''.obs;
  final TextEditingController filterController = TextEditingController();
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
              invoice_detail.Invoice_id == int.tryParse(Invoice_id) &&
              (invoice_detail.Product_Name.toLowerCase().contains(filterText) ||
               invoice_detail.Product_Code.toLowerCase().contains(filterText)))
          .toList();
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
          Text('Invoice #$Invoice_id Items'),
          IconButton(
            color: Color.fromRGBO(13, 134, 151, 1),
            iconSize: 24.0,
            onPressed: () {
              Get.to(() => OldInvoiceUpdate(
                    Invoice_id: Invoice_id,
                     Cus_id: Customer_id, 
                     Cus_Name: Customer_Name, 
                     Cus_Number: Customer_Number,
                  ));
            },
            icon: Icon(CupertinoIcons.add),
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
              initialValue: Customer_Name + ' || ' + Customer_Number,
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
                    initialValue: Invoice_Total_US + '\$',
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
                    initialValue: Invoice_Rec_US + '\$',
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
                    initialValue: Invoice_Due_US + '\$',
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
            ),TextFormField(
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
              },),
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                                Visibility(
                                      visible:true,
                                      child: IconButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            if(double.tryParse( Invoice_Due_US ) == 0) {
                                      showDialog(
                                      // The user CANNOT close this dialog  by pressing outsite it
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_) {
                                        return Dialog(
                                          // The background color
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.symmetric(vertical: 20),
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
                                                    invoiceDetailController.DeleteInvItem(invoice.Invoice_Detail_id.toString())
                                                    .then((value) => showToast(invoiceDetailController.result2))
                                                    .then((value) => invoiceDetailController.isDataFetched = false)
                                                    .then((value) => invoiceDetailController.fetchinvoicesdetails)
                                                    
                                                    .then((value) => Navigator.of(context).pop());
                                                    } else {
                                                      showToast('Invoice Due Must Be 0');
                                                    }
                                              
        

                                           },
                                          icon: Icon(Icons.delete)),
                                    ),
                                    ],),
                                    
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
