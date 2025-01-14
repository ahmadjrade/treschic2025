// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/stores_model.dart';
import 'package:treschic/model/supplier_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoresController extends GetxController {
  RxList<StoresModel> stores = <StoresModel>[].obs;
  bool isDataFetched = false;
  String result = '';
    RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchstores();
  }

  List<StoresModel> searchStores(String query) {
    return stores
        .where((store) =>
            store.Store_Number.toLowerCase().contains(query.toLowerCase()) || store.Store_Name.toLowerCase().contains(query.toLowerCase()))
        .toList()  ;
  }
  void closeLoading() {}
  String result2 = '';
  Future<void> DeleteStore(String S_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'delete_store.php';

      var res = await http.post(Uri.parse(uri), body: {
        "S_id": S_id,
      });

      var response = json.decode(json.encode(res.body));
      S_id = '';

      print(response);
      result2 = response;
      if (response.toString().trim() == 'Store Deleted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }
  Future<void> UploadStore(String Store_Name, String Store_Number,String Store_Loc) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_store.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Store_Name": Store_Name,
        "Store_Number": Store_Number,
          "Store_Loc": Store_Loc,

      });

      var response = json.decode(json.encode(res.body));
      Store_Name = '';
            Store_Number = '';

      Store_Loc = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Store inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Store already exists.') {}
    } catch (e) {
      print(e);
    }
  }


  void fetchstores() async {
    if (!isDataFetched) {
      try {
                isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_stores.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          stores.assignAll(
              data.map((item) => StoresModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
                    isLoading.value = false;

          if (stores.isEmpty) {
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
