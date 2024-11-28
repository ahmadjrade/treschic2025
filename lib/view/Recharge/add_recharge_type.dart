import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/insert_recharge_card.dart';
import 'package:fixnshop_admin/controller/insert_recharge_type.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddRechargeType extends StatelessWidget {
  AddRechargeType({
    super.key,
  });

  TextEditingController Type_Name = TextEditingController();

  final InsertRechargeType insertRechargeType = Get.put(InsertRechargeType());

  final CartTypesController cartTypesController =
      Get.find<CartTypesController>();

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
              'New Recharge Type',
              style: TextStyle(fontSize: 20),
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
                  controller: Type_Name,
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
                )
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
                    insertRechargeType.UploadCard(Type_Name.text)
                        .then((value) => showToast(insertRechargeType.result))
                        .then((value) =>
                            cartTypesController.isDataFetched = false)
                        .then((value) => cartTypesController.fetch_cart_types())
                        .then((value) => Navigator.of(context).pop())
                        .then((value) => Navigator.of(context).pop());
                  },
                  child: Text(
                    'Insert Card',
                    style: TextStyle(color: Colors.blue.shade900),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
