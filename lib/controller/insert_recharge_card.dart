// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertRechargeCard extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  Future<void> UploadCard(
      String Type_id,
      String Card_Name,
      String Card_Cost,
      String Card_Price,
      Balance_Deduction,
      SelectedBalanceId,
      Balance_required) async {
    try {
      Username = sharedPreferencesController.username;
      // formattedDate = dateController.getFormattedDate();
      // formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;

      String uri = '$domain' + 'insert_recharge_card.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Type_id": Type_id,
        "Username": Username.value,
        "Card_Name": Card_Name,
        "Card_Cost": Card_Cost,
        "Card_Price": Card_Price,
        "Balance_Deduction": Balance_Deduction,
        "SelectedBalanceId": SelectedBalanceId,
        "Balance_required": Balance_required
      });
      print(Type_id + Card_Name + Card_Cost + Card_Price);
      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Card inserted successfully.') {
        //  result = 'refresh';
      }
    } catch (e) {
      print(e);
    }
  }
}
