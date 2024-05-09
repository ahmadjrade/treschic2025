// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertProductDetailController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final SharedPreferencesController sharedPreferencesController = Get.find<SharedPreferencesController>(); 
         RxString Username = ''.obs;
  Future<void> UploadProductDetails(String Product_id,
       String Product_Quantity,String Product_LPrice,String Product_MPrice) async {
    try {
      Username = sharedPreferencesController.username;

      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_product_detail.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Product_id": Product_id,
         "Product_Quantity": Product_Quantity,
         "Product_LPrice": Product_LPrice,
        "Product_MPrice": Product_MPrice,

         "Store_id": Username.toString(),


      });

      var response = json.decode(json.encode(res.body));
      // Supplier_Number = '';
      // Supplier_Name = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Product Detail inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Product Detail already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
