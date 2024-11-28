import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/credit_balance_controller.dart';
import 'package:fixnshop_admin/controller/insert_recharge_card.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/recharge_balance_model.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_balances.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AddRechargeCard extends StatefulWidget {
  int Type_id;

  AddRechargeCard({super.key, required this.Type_id});

  @override
  State<AddRechargeCard> createState() => _AddRechargeCardState();
}

class _AddRechargeCardState extends State<AddRechargeCard> {
  TextEditingController Card_Cost = TextEditingController();

  bool isRequired = false;

  TextEditingController Card_Name = TextEditingController();

  TextEditingController Card_Price = TextEditingController();

  TextEditingController Balance_Deduction = TextEditingController();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  final InsertRechargeCard insertRechargeCard = Get.put(InsertRechargeCard());

  final RechargeBalanceController rechargeBalanceController =
      Get.find<RechargeBalanceController>();

  RechargeBalanceModel? SelectedBalance;

  int SelectedBalanceId = 0;
  int Balance_Required = 1;
  final RechargeCartController rechargeCartController =
      Get.find<RechargeCartController>();

  @override
  Widget build(BuildContext context) {
    void copyToClipboard(CopiedText) {
      Clipboard.setData(ClipboardData(text: CopiedText));
      // Show a snackbar or any other feedback that the text has been copied.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard'),
        ),
      );
    }

    Username = sharedPreferencesController.username;
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('New Recharge Card'),
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

                  controller: Card_Name,
                  decoration: InputDecoration(
                    labelText: "Card Name ",
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
                TextFormField(
                  readOnly: false,
                  //   maxLength: 50,
                  //   initialValue: Product_Code,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  // sad
                  controller: Card_Cost,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (Card_Cost.text != '') {
                            copyToClipboard(Card_Cost.text);
                          }
                        },
                        icon: Icon(Icons.copy)),
                    labelText: "Card Cost ",
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
                TextFormField(
                  readOnly: false,
                  //   maxLength: 50,
                  //   initialValue: Product_Code,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: Card_Price,
                  decoration: InputDecoration(
                    labelText: "Card Price ",
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
                Visibility(
                  visible: !isRequired,
                  child: TextFormField(
                    readOnly: false,
                    //   maxLength: 50,
                    //   initialValue: Product_Code,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    // sad
                    controller: Balance_Deduction,
                    decoration: InputDecoration(
                      labelText: "Balance Deduction ",
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
                Visibility(
                  visible: !isRequired,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Obx(
                            () => rechargeBalanceController.balance.isEmpty
                                ? Center(
                                    child: Column(
                                      children: [
                                        // Text('Fetching Rate! Please Wait'),
                                        CircularProgressIndicator(),
                                      ],
                                    ),
                                  )
                                : DropdownButtonFormField<RechargeBalanceModel>(
                                    decoration: InputDecoration(
                                      labelText: "Balance",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.black,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    iconDisabledColor: Colors.blue.shade900,
                                    iconEnabledColor: Colors.blue.shade900,
                                    //  value: categoryController.category.first,
                                    onChanged: (RechargeBalanceModel? value) {
                                      SelectedBalance = value;
                                      SelectedBalanceId =
                                          (SelectedBalance?.Credit_id)!;
                                    },
                                    items: rechargeBalanceController.balance
                                        .where((balance) =>
                                            balance.Username == Username.value)
                                        .map((balance) => DropdownMenuItem<
                                                RechargeBalanceModel>(
                                              value: balance,
                                              child: Text(balance.Credit_Type),
                                            ))
                                        .toList(),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IconButton(
                          color: Colors.blue.shade900,
                          iconSize: 24.0,
                          onPressed: () {
                            Get.to(RechargeBalance());
                            // rechargeBalanceController.isDataFetched = false;
                            // rechargeBalanceController.fetchcolors();
                            // //Quantities.clear();
                            //Quantities.add(Product_Quantity.text);
                            //  print(Quantities);
                          },
                          icon: Icon(CupertinoIcons.add),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CheckboxListTile(
                  activeColor: Colors.blue.shade100,
                  checkColor: Colors.blue.shade900,
                  title: Text("No Balance ? "),
                  value: isRequired,
                  onChanged: (newValue) {
                    setState(() {
                      if (isRequired == false) {
                        isRequired = newValue!;
                        Balance_Required = 0;
                        //    print(Balance_Required);
                      } else {
                        Balance_Required = 1;
                        isRequired = newValue!;
                        Balance_Deduction.clear();
                        SelectedBalanceId == null;
                        SelectedBalance = null;

                        //print(Balance_Required);
                      }
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
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
                    insertRechargeCard.UploadCard(
                            widget.Type_id.toString(),
                            Card_Name.text,
                            Card_Cost.text,
                            Card_Price.text,
                            isRequired ? '0' : Balance_Deduction.text,
                            isRequired ? '0' : SelectedBalanceId.toString(),
                            Balance_Required.toString())
                        .then((value) => showToast(insertRechargeCard.result))
                        .then((value) =>
                            rechargeCartController.isDataFetched = false)
                        .then((value) =>
                            rechargeCartController.fetch_recharge_carts())
                        .then((value) => Navigator.of(context).pop())
                        .then((value) => Navigator.of(context).pop());
                  },
                  child: Text(
                    'Insert Card',
                    style: TextStyle(color: Colors.blue.shade900),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
