import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/credit_balance_controller.dart';
import 'package:fixnshop_admin/controller/insert_recharge_balance.dart';
import 'package:fixnshop_admin/controller/insert_recharge_card.dart';
import 'package:fixnshop_admin/controller/insert_recharge_type.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddRechargeBalance extends StatelessWidget {
  AddRechargeBalance({
    super.key,
  });

  TextEditingController Balance_Name = TextEditingController();
  TextEditingController Credit_Balance = TextEditingController();
  TextEditingController Credit_Price = TextEditingController();

  final InsertRechargeBalance insertRechargeBalance =
      Get.put(InsertRechargeBalance());

  final RechargeBalanceController rechargeBalanceController =
      Get.find<RechargeBalanceController>();

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
          children: [
            Text(
              'New Recharge Balance',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: false,
                  //   maxLength: 50,
                  //   initialValue: Product_Code,
                  keyboardType: TextInputType.name,
                  controller: Balance_Name,
                  decoration: InputDecoration(
                    labelText: "Type Name ",
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
                  height: 10,
                ),
                TextFormField(
                  readOnly: false,
                  //   maxLength: 50,
                  //   initialValue: Product_Code,
                  keyboardType: TextInputType.name,
                  controller: Credit_Balance,
                  decoration: InputDecoration(
                    labelText: "Current Balance ",
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
                  height: 10,
                ),
                TextFormField(
                  readOnly: false,
                  //   maxLength: 50,
                  //   initialValue: Product_Code,
                  keyboardType: TextInputType.name,
                  controller: Credit_Price,
                  decoration: InputDecoration(
                    labelText: "Credit Price ",
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
                  height: 10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 50),
                    backgroundColor: Colors.blue.shade100,
                    side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
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
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                    insertRechargeBalance.UploadRBalance(Balance_Name.text,
                            Credit_Balance.text, Credit_Price.text)
                        .then(
                            (value) => showToast(insertRechargeBalance.result))
                        .then((value) =>
                            rechargeBalanceController.isDataFetched = false)
                        .then((value) =>
                            rechargeBalanceController.fetch_cart_types())
                        .then((value) => Navigator.of(context).pop())
                        .then((value) => Navigator.of(context).pop());
                  },
                  child: Text(
                    'Insert Balance',
                    style: TextStyle(color: Colors.blue.shade900),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
