// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/invoice_history_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/model/purchase_history_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseDetailController extends GetxController {
  RxList<PurchaseHistoryModel> purchase_details = <PurchaseHistoryModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<PurchaseHistoryModel?> SelectedPurchaseDetail = Rx<PurchaseHistoryModel?>(null);

  void clearSelectedCat() {
    SelectedPurchaseDetail.value = null;
    purchase_details.clear();
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
    fetchpurchasedetails();
  }

//  List<PurchaseHistoryModel> searchProducts(String query) {
//     return purchase_details.where((product) =>
//         product.P.toLowerCase().contains(query.toLowerCase())).toList();
//   }
  void fetchpurchasedetails() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_pur_detail.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          purchase_details.assignAll(
              data.map((item) => PurchaseHistoryModel.fromJson(item)).toList());
          //category = data.map((item) => invoice_details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (purchase_details.isEmpty) {
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
  // Future<void> UpdateProductQty(String P_Detail_id, String Qty) async {
  //   try {
  //     String domain = domainModel.domain;
  //     String uri = '$domain' + 'update_product_quantity.php';

  //     var res = await http.post(Uri.parse(uri), body: {
  //       "P_Detail_id": P_Detail_id,
  //       "Qty": Qty,
  //     });

  //     var response = json.decode(json.encode(res.body));
  //     P_Detail_id = '';
  //     Qty = '';

  //     print(response);
  //     result2 = response;
  //     if (response.toString().trim() ==
  //         'Product Quantity Updated successfully.') {
  //       //  result = 'refresh';
  //     } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
