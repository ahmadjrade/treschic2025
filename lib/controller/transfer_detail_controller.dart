// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/invoice_history_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/model/transfer_details_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferDetailController extends GetxController {
  RxList<TransferDetailsModel> transfer_detail = <TransferDetailsModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<TransferDetailsModel?> SelectedTransferDetail =
      Rx<TransferDetailsModel?>(null);

  void clearSelectedCat() {
    SelectedTransferDetail.value = null;
    transfer_detail.clear();
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
    fetchinvoicesdetails();
  }

//  List<TransferDetailsModel> searchProducts(String query) {
//     return transfer_detail.where((product) =>
//         product.P.toLowerCase().contains(query.toLowerCase())).toList();
//   }
  void fetchinvoicesdetails() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_transfer_details.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          transfer_detail.assignAll(
              data.map((item) => TransferDetailsModel.fromJson(item)).toList());
          //category = data.map((item) => invoice_details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (transfer_detail.isEmpty) {
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
  Future<void> DeleteInvItem(String I_Detail_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'delete_inv_item.php';

      var res = await http.post(Uri.parse(uri), body: {
        "I_Detail_id": I_Detail_id,
      });

      var response = json.decode(json.encode(res.body));
      I_Detail_id = '';

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
