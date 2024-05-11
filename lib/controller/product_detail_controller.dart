// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailController extends GetxController {
  RxList<ProductDetailModel> product_detail = <ProductDetailModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<ProductDetailModel?> SelectedProductDetail = Rx<ProductDetailModel?>(null);

  void clearSelectedCat() {
    SelectedProductDetail.value = null;
    product_detail.clear();
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
    fetchproductdetails();
  }

//  List<ProductDetailModel> searchProducts(String query) {
//     return product_detail.where((product) =>
//         product.P.toLowerCase().contains(query.toLowerCase())).toList();
//   }
  void fetchproductdetails() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_pdetail.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          product_detail.assignAll(
              data.map((item) => ProductDetailModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (product_detail.isEmpty) {
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

  String result2 = '';
  Future<void> UpdateProductQty(String P_Detail_id, String Qty) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'update_product_quantity.php';

      var res = await http.post(Uri.parse(uri), body: {
        "P_Detail_id": P_Detail_id,
        "Qty": Qty,
      });

      var response = json.decode(json.encode(res.body));
      P_Detail_id = '';
      Qty = '';

      print(response);
      result2 = response;
      if (response.toString().trim() ==
          'Product Quantity Updated successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
