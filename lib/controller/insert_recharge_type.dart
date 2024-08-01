// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertRechargeType extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  Future<void> UploadCard(String Type_Name) async {
    //     .then((value) => showToast(
    //         productDetailController
    //             .result2))
    try {
      //   Username = sharedPreferencesController.username;
      // formattedDate = dateController.getFormattedDate();
      // formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;

      String uri = '$domain' + 'insert_recharge_type.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Type_Name": Type_Name,
      });
      // print(Ty + Card_Name + Card_Cost + Card_Price);
      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Card Type inserted successfully.') {
        //  result = 'refresh';
      }
    } catch (e) {
      print(e);
    }
  }
}
