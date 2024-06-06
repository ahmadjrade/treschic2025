// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertCustomerController extends GetxController {

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadCus(String Cus_Name, String Cus_Number) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_cus.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Cus_Name": Cus_Name,
        "Cus_Number": Cus_Number,
      });

      var response = json.decode(json.encode(res.body));
      Cus_Name = '';
      Cus_Number = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Customer inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Customer already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
