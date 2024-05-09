// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertColorController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadColor(String Color) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_color.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Color": Color,
      });

      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Color inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Color already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
