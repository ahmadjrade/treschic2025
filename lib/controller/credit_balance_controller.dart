// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/cart_types_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/recharge_balance_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RechargeBalanceController extends GetxController {
  RxList<RechargeBalanceModel> balance = <RechargeBalanceModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  RxBool iseditable = false.obs;
  Rx<RechargeBalanceModel?> SelectedBalance = Rx<RechargeBalanceModel?>(null);

  void clearSelectedCat() {
    SelectedBalance.value = null;
    balance.clear();
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
    fetch_cart_types();
  }

  List<RechargeBalanceModel> searchTypes(String query) {
    return balance
        .where((balance) =>
            balance.Username.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void fetch_cart_types() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response = await http
            .get(Uri.parse('$domain' + 'fetch_recharge_balances.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          balance.assignAll(
              data.map((item) => RechargeBalanceModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (balance.isEmpty) {
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

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  String result2 = '';
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  Future<void> UpdateRechargeBalance(String Balance_id, String ammount) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();

      String domain = domainModel.domain;
      String uri = '$domain' + 'update_recharge_balance.php';

      var res = await http.post(Uri.parse(uri), body: {
        "Balance_id": Balance_id,
        "ammount": ammount,
        "Username": Username.value,
        "Date": formattedDate,
        "Time": formattedTime,
      });

      var response = json.decode(json.encode(res.body));
      Balance_id = '';
      ammount = '';

      print(response);
      result2 = response;
      if (response.toString().trim() ==
          'Recharge Balance Updated successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == '') {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> EditRechargeBalance(String Balance_id, String ammount) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();

      String domain = domainModel.domain;
      String uri = '$domain' + 'edit_recharge_balance.php';

      var res = await http.post(Uri.parse(uri), body: {
        "Balance_id": Balance_id,
        "ammount": ammount,
      });

      var response = json.decode(json.encode(res.body));
      Balance_id = '';
      ammount = '';

      print(response);
      result2 = response;
      if (response.toString().trim() ==
          'Recharge Balance Updated successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == '') {}
    } catch (e) {
      print(e);
    }
  }
}
