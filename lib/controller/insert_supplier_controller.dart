// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertSupplierController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadSupplier(
      String Supplier_Number, String Supplier_Name) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_supplier.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Supplier_Name": Supplier_Number,
        "Supplier_Number": Supplier_Name,
      });

      var response = json.decode(json.encode(res.body));
      Supplier_Number = '';
      Supplier_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Supplier inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Supplier already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
