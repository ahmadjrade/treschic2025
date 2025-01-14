// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, non_constant_identifier_names

import 'package:treschic/controller/expense_category_controller.dart';
import 'package:treschic/controller/expenses_controller.dart';
import 'package:treschic/model/expense_category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/datetime_controller.dart';
import '../../controller/insert_expense_controller.dart';

class BuyExpenses extends StatelessWidget {
  BuyExpenses({super.key});

  final ExpenseCategoryController expenseCategoryController =
      Get.find<ExpenseCategoryController>();
  ExpenseCategoryModel? SelectedExpenseCategory;
  String SelectedExpId = '';
  final ExpensesController expensesController = Get.find<ExpensesController>();
  TextEditingController Exp_Cat_Name = TextEditingController();
  final InsertExpenseController insertexpenseController =
      Get.put(InsertExpenseController());
  final DateTimeController dateController = DateTimeController();

  String formattedDate = '';

  String formattedTime = '';

  String Expense_Desc = '';

  TextEditingController Expense_Value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    expensesController.Currency.value = 'Usd';
    formattedDate = dateController.getFormattedDate();
    formattedTime = dateController.getFormattedTime();
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Insert Expense'),
            Column(
              children: [
                // Text(
                //   formattedDate,
                //   style: TextStyle(fontSize: 15),
                // ),
                // Text(
                //   formattedTime,
                //   style: TextStyle(fontSize: 15),
                // ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Obx(() {
                    if (expenseCategoryController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      // patientsController.fetchpatients();
                    } else if (expenseCategoryController
                        .expense_category.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No Categories Found !.'),
                          ],
                        ),
                      );
                    } else {
                      return DropdownButtonFormField<ExpenseCategoryModel>(
                        decoration: InputDecoration(
                          hintText: 'Select a Category',
                          labelText: "Expense Categories",
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
                        iconDisabledColor: Colors.blue.shade900,
                        iconEnabledColor: Colors.blue.shade900,
                        //  value: categoryController.category.first,
                        onChanged: (ExpenseCategoryModel? value) {
                          expenseCategoryController.SelectedCategory.value =
                              value;

                          SelectedExpenseCategory = value;
                          SelectedExpId =
                              (SelectedExpenseCategory?.Exp_Cat_id).toString();
                          print(SelectedExpId);
                        },
                        items: expenseCategoryController.expense_category
                            .map(
                                (cat) => DropdownMenuItem<ExpenseCategoryModel>(
                                      value: cat,
                                      child: Text(cat.Exp_Cat_Name),
                                    ))
                            .toList(),
                      );
                    }
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                child: IconButton(
                  color: Colors.blueAccent,
                  iconSize: 24.0,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Expense Category'),
                          content: TextFormField(
                            //  maxLength: 15,

                            keyboardType: TextInputType.number,
                            controller: Exp_Cat_Name,
                            decoration: InputDecoration(
                                hintText: 'Enter Category Name'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                if (Exp_Cat_Name.text != '') {
                                  showDialog(
                                      // The user CANNOT close this dialog  by pressing outsite it
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_) {
                                        return Dialog(
                                          // The background color
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
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
                                  expenseCategoryController
                                          .InsertExpenseCategory(
                                              Exp_Cat_Name.text)
                                      .then((value) => expenseCategoryController
                                          .isDataFetched = false)
                                      .then((value) => expenseCategoryController
                                          .fetchcategories())
                                      .then((value) =>
                                          Navigator.of(context).pop())
                                      .then((value) =>
                                          Navigator.of(context).pop())
                                      .then((value) => Exp_Cat_Name.clear())
                                      .then((value) => showToast(
                                          expenseCategoryController.result2));
                                } else {
                                  showToast('Write Category Name');
                                }

                                // Do something with the text, e.g., save it
                                //  String enteredText = _textEditingController.text;
                                //  print('Entered text: $enteredText');
                                // Close the dialog
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    // colorController.isDataFetched = false;
                    // colorController.fetchcolors();
                    // //Quantities.clear();
                    //Quantities.add(Product_Quantity.text);
                    // print(Quantities);
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              onChanged: (value) {
                Expense_Desc = value;
              },
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Expense Description ",
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
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    //initialValue: '0',
                    controller: Expense_Value,
                    decoration: InputDecoration(
                      labelText: "Price",
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

                //Checkbox(),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RadioListTile(
                    activeColor: Colors.blue.shade900,
                    selectedTileColor: Colors.blue.shade900,
                    title: Column(
                      children: [
                        Text(
                          'USD',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    value: 'Usd',
                    groupValue: expensesController.Currency.value,
                    onChanged: (value) {
                      expensesController.Currency.value = 'Usd';

                      // setState(() {
                      //   // havePassword = false;
                      //   Condition = value.toString();
                      //   // Password.text = 'No Password';
                      // });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    activeColor: Colors.blue.shade900,
                    selectedTileColor: Colors.blue.shade900,
                    //fillColor: Colors.blue.shade900,
                    title: Column(
                      children: [
                        Text(
                          'Lebanese',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    value: 'Lb',
                    groupValue: expensesController.Currency.value,
                    onChanged: (value) {
                      expensesController.Currency.value = 'Lb';

                      // setState(() {
                      //   // havePassword = false;
                      //   Condition = value.toString();
                      //   // Password.text = 'No Password';
                      // });
                    },
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                  //final DateTimeController dateController = DateTimeController();

                  if (Expense_Desc == '') {
                    showToast('Please add Expense Description');
                  } else if (Expense_Value.text == 0) {
                    showToast('Please Increase Expense Price');
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
                    insertexpenseController.UploadExpense(Expense_Desc,
                            Expense_Value.text, SelectedExpId.toString())
                        .then((value) => Navigator.of(context).pop())
                        .then((value) => Navigator.of(context).pop());
                  }
                },
                child: Text(
                  'Buy',
                  style: TextStyle(color: Colors.blue.shade900),
                )),
          )
        ]),
      ),
    );
  }
}
