// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/controller/expenses_controller.dart';
import 'package:treschic/controller/rate_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'datetime_controller.dart';

class InsertExpenseController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;
   final SharedPreferencesController sharedPreferencesController = Get.find<SharedPreferencesController>(); 
         RxString Username = ''.obs;
  DomainModel domainModel = DomainModel();
  String result = '';
  final DateTimeController dateController = DateTimeController();
    final ExpensesController expensesController = Get.find<ExpensesController>();
    final RateController rateController = Get.find<RateController>();

  String formattedDate = '';

  String formattedTime = '';
  String CheckCurr(String Value) {
    String New_Value;
    if(expensesController.Currency.value != 'Usd') {
      New_Value = ( double.tryParse(Value)! / rateController.rateValue.value).toString();
      return New_Value;
    } else { 
      New_Value = Value;
      return New_Value;

    }
  }
  Future<void> UploadExpense(

      String Desc, String Value,String Exp_cat_id) async {
    try { 

      

              Username = sharedPreferencesController.username;

      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_expense.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Expense_Desc": Desc,
        
        "Expense_Value": CheckCurr(Value),
         "Exp_cat_id": Exp_cat_id,

        "Expense_Date": formattedDate,
        "Expense_Time": formattedTime,
                "Username": Username.value,

      });

      var response = json.decode(json.encode(res.body));
      Desc = '';
      Value = '';
      
      print(response);
      result = response;
      if (response.toString().trim() == 'Expense inserted successfully.') {
        //  result = 'refresh';
      }
    } catch (e) {
      print(e);
    }
  }
}
