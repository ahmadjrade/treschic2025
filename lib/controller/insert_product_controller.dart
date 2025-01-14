// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertProductController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UploadAcc(
      String Product_Name,
      String Product_Cat,
      String Product_SubCat,
      String Product_Brand,
      String Product_Code,
      String Product_Cost,
      String Product_LPrice,
      String Product_MPrice) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_product.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Product_Name": Product_Name,
        "Product_Brand": Product_Brand,
        "Product_Sub_Cat": Product_SubCat,
        "Product_Cat": Product_Cat,
        "Product_Code": Product_Code,
        "Product_Cost": Product_Cost,
        "Product_LPrice": Product_LPrice,
        "Product_MPrice": Product_MPrice,
      });

      var response = json.decode(json.encode(res.body));
      // Supplier_Number = '';
      // Supplier_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Product inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Product already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
