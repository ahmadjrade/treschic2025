// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertSizeController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadSize(String Size, Shortcut) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_size.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Size": Size,
        "Shortcut": Shortcut,
      });

      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Size inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Size already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
