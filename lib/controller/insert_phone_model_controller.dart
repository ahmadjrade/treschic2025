// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertPhoneModelController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadPhoneModel(String Brand_id, String Phone_Name) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_phone_model.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Brand_id": Brand_id,
        "Phone_Name": Phone_Name,
      });

      var response = json.decode(json.encode(res.body));
      Phone_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Phone Model inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() ==
          'Phone Model  already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
