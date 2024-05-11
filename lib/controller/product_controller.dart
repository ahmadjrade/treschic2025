// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  RxList<ProductModel> products = <ProductModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  RxBool iseditable = false.obs;
  Rx<ProductModel?> SelectedPhone = Rx<ProductModel?>(null);

  void clearSelectedCat() {
    SelectedPhone.value = null;
    products.clear();
  }
  bool isadmin(username) {
    if (username == 'admin') {
      return true;
    } else {
      return false;
    }
  }
  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchproducts();
  }


  List<ProductModel> searchProducts(String query) {
    return products
        .where((product) =>
            product.Product_Name.toLowerCase().contains(query.toLowerCase()) ||
            product.Product_Code.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void fetchproducts() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_products.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          products.assignAll(
              data.map((item) => ProductModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (products.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            // print('cat');
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
