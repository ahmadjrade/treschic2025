// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertCategoryController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadCat(String Cat_Name) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_category.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Cat_Name": Cat_Name,
      });

      var response = json.decode(json.encode(res.body));
      Cat_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Category inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Category already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
