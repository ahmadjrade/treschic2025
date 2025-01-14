// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertBrandController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadBrand(String Brand_Name) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_brand.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Brand_Name": Brand_Name,
      });

      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Brand inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Brand already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
