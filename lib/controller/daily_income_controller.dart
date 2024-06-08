// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/daily_income_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/rate_model.dart';
import 'package:fixnshop_admin/model/supplier_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyIncomeController extends GetxController {
  RxList<DailyIncomeModel> daily_income = <DailyIncomeModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxInt rateValue =  0.obs;
    RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchincomes();
  }

  void closeLoading() {}
  void fetchincomes() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;
        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_daily_income.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          daily_income.assignAll(
              data.map((item) => DailyIncomeModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          if (daily_income.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            //rateValue.value =  (daily_income[0].Rate); 
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
