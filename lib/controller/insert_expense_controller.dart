// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'datetime_controller.dart';

class InsertExpenseController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';

  String formattedTime = '';

  Future<void> UploadExpense(
      String Desc, String Value) async {
    try {
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_expense.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Expense_Desc": Desc,
        "Expense_Value": Value,
        "Expense_Date": formattedDate,
        "Expense_Time": formattedTime,
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
