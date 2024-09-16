// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/domain.dart';

import 'package:fixnshop_admin/model/recharge_cart_model.dart';
import 'package:fixnshop_admin/model/topup_history_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Recharge/new_recharge_invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class TopupHistoryController extends GetxController {
  RxList<TopupHistoryModel> topup_history = <TopupHistoryModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<TopupHistoryModel?> SelectedTopup = Rx<TopupHistoryModel?>(null);
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;

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
  }

  List<TopupHistoryModel> searchcardss(String query) {
    return topup_history
        .where((topup) =>
            topup.Balance_id.toString().contains(query.toLowerCase()))
        .toList();
  }

  void fetch_topup_history() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_topup_history.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          topup_history.assignAll(
              data.map((item) => TopupHistoryModel.fromJson(item)).toList());
          //category = data.map((item) => cards_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (topup_history.isEmpty) {
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
