// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/supplier_model.dart';
import 'package:fixnshop_admin/view/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupplierController extends GetxController {
  RxList<SupplierModel> suppliers = <SupplierModel>[].obs;
  bool isDataFetched = false;
  String result = '';
    RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchsuppliers();
  }

  List<SupplierModel> searchProducts(String query) {
    return suppliers
        .where((supplier) =>
            supplier.Supplier_Number.toLowerCase().contains(query.toLowerCase()) || supplier.Supplier_Name.toLowerCase().contains(query.toLowerCase()))
        .toList()  ;
  }
  void closeLoading() {}
  void fetchsuppliers() async {
    if (!isDataFetched) {
      try {
                isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_suppliers.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          suppliers.assignAll(
              data.map((item) => SupplierModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
                    isLoading.value = false;

          if (suppliers.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            print('supp');
          }
        } else {
          result == 'fail';
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
