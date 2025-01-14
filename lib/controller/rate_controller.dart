// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/rate_model.dart';
import 'package:treschic/model/supplier_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RateController extends GetxController {
  RxList<RateModel> rate = <RateModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxInt rateValue =  0.obs;
    RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchrate();
  }

  void closeLoading() {}
  void fetchrate() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;
        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_rate.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          rate.assignAll(
              data.map((item) => RateModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          if (rate.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            rateValue.value =  (rate[0].Rate); 
            isLoading.value= false;
            //r_rate = 
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
