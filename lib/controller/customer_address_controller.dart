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
import 'package:fixnshop_admin/model/customer_address_model.dart';
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

class CustomerAddressController extends GetxController {
  RxList<CustomerAddressModel> address = <CustomerAddressModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<CustomerAddressModel?> SelectedAddress = Rx<CustomerAddressModel?>(null);
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
    fetch_addresses();
  }

  List<CustomerAddressModel> searchAddress(String query) {
    return address
        .where((address) =>
            address.Cus_id.toString().contains(query.toLowerCase()))
        .toList();
  }

  void fetch_addresses() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_customer_address.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          address.assignAll(
              data.map((item) => CustomerAddressModel.fromJson(item)).toList());
          //category = data.map((item) => cards_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (address.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            print('123123');
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
  Future<void> DeleteAddress(String Address_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'delete_customer_address.php';

      var res = await http.post(Uri.parse(uri), body: {
        "Address_id": Address_id,
      });

      var response = json.decode(json.encode(res.body));
      Address_id = '';

      print(response);
      result2 = response;
      if (response.toString().trim() ==
          'Customer Address Deleted Successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
