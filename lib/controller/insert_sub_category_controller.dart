// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertSubCategoryController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadSubCat(String SCat_Name, Cat_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_sub_category.php';
      var res = await http.post(Uri.parse(uri), body: {
        "SCat_Name": SCat_Name,
        "Cat_id": Cat_id,
      });

      var response = json.decode(json.encode(res.body));
      SCat_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Sub-Category inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() ==
          'Sub-Category already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
