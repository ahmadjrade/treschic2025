// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertProductDetailController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  Future<void> UploadProductDetails(
      String Product_id,
      String Product_Quantity,
      String Product_LPrice,
      String Product_MPrice,
      String Color_id,
      String Size_id,
      String pdetail_code) async {
    try {
      Username = sharedPreferencesController.username;
      print(pdetail_code);
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_product_detail.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Product_id": Product_id,
        "Product_Quantity": Product_Quantity,
        "Product_LPrice": Product_LPrice,
        "Product_MPrice": Product_MPrice,
        "Color_id": Color_id,
        "Size_id": Size_id,
        "Store_id": Username.toString(),
        "pdetail_code": pdetail_code,
      });

      var response = json.decode(json.encode(res.body));
      // Supplier_Number = '';
      // Supplier_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() ==
          'Product Detail inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() ==
          'Product Detail already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
