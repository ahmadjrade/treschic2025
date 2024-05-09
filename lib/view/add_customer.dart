// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/insert_customer_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomer extends StatelessWidget {
  AddCustomer({super.key});

  final InsertCustomerController insertcustomerController =
      Get.put(InsertCustomerController());
  final CustomerController customerController = Get.find<CustomerController>();

  String Cus_Name = '';

  String Cus_Number = '';
  String loadingtext = 'Loading';
  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('New Customer'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                customerController.isDataFetched = false;
                customerController.fetchcustomers();

                
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              onChanged: (value) {
                Cus_Name = value;
              },
              maxLength: 50,
              keyboardType: TextInputType.name,
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Customer Name ",
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
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              onChanged: (value) {
                Cus_Number = value;
              },
              maxLength: 15,
              keyboardType: TextInputType.number,
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Customer Number ",
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal :25),
            child: GetBuilder<InsertCustomerController>(
                builder: (insertcustomerController) {
              return  OutlinedButton(
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
                    if (Cus_Number != '') {
                      if (Cus_Name != '') {
                        if (Cus_Number.length < 8) {
                          showToast(
                              'Customer Number should Have minimum 8 Digits');
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
                          insertcustomerController.UploadCus(Cus_Name, Cus_Number)
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => customerController.isDataFetched = false)
                              .then((value) => customerController.fetchcustomers())

                              .then((value) =>
                                  showToast(insertcustomerController.result));
                        }
                      } else {
                        showToast('Please add Customer Name');
                      }
                    }
                  },
                  child: Text(
                    'Insert Customer',
                    style: TextStyle(color: Colors.white,fontSize: 15 ,fontWeight: FontWeight.bold),
                  ));
            }),
          ),
        ]),
      ),
    );
  }
}
