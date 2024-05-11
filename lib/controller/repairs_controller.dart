// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'dart:ffi';
import 'dart:ui';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/repairs_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepairsController extends GetxController {
  RxList<RepairsModel> repairs = <RepairsModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<RepairsModel?> SelectedRepair = Rx<RepairsModel?>(null);
  RxString Store = 'this'.obs;
  RxString Sold = 'Yes'.obs;
  RxString Condition = 'New'.obs;
  RxBool iseditable = false.obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;

  //RxString show = 'Yes'.obs;
  void clearSelectedCat() {
    SelectedRepair.value = null;
    repairs.clear();
  }

  void reset() {
    total.value = 0;
    totalrec.value = 0;
    totaldue.value = 0;
  }

  RxBool isShown = false.obs;

  bool isshow(int val) {
    if (val == 0) {
      isShown.value == false;
      return false;
    } else {
      isShown.value == true;
      return true;
    }
  }

  Color getcolor(String Status) {
  //red is just a sample color
  Color color;
  if (Status == 'Pending') {
          color = Colors.red.shade100;

    } else if (Status == 'Finished'){
          color = Colors.grey.shade300;
    }
      else {
          color = Colors.green.shade100;

      }
        return color;

}

  bool ispaid(String Status) {
    if (Status == 'Pending') {
      return false;
    } else if (Status == 'Finished'){
        return true;
    }
      else {
        return false;

      }
  
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
    fetchrepairs();
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  List<RepairsModel> searchrepairs(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    // print(formattedDate);
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;
    // formattedDate = dateController.getFormattedDate();
    //   formattedTime = dateController.getFormattedTime();

    return repairs
        .where((invoice) =>
            (invoice.Repair_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Cus_Name.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Cus_Number.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value)
        .toList();
    // if (Store.value == 'this') {
    //   if (Sold.value == 'Yes') {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 1 ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 1)
    //           .toList();
    //     }
    //   } else if(Sold.value == 'No'){
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 0 ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&
    //                   invoice.isSold == 0)
    //           .toList();
    //     }
    //   } else {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&

    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&

    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&

    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username &&

    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username == username
    //                   ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username == username
    //                   )
    //           .toList();
    //     }
    //   }
    // }
    // else if(Store.value == 'other') {
    //   if (Sold.value == 'Yes') {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 1 ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 1)
    //           .toList();
    //     }
    //   } else if(Sold.value == 'No') {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 0 ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.isSold == 0)
    //           .toList();
    //     }
    //   } else {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Username != username  ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Username != username )
    //           .toList();
    //     }
    //   }
    // } else  {
    //   if (Sold.value == 'Yes') {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&

    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.isSold == 1 &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.isSold == 1 ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.isSold == 1)
    //           .toList();
    //     }
    //   } else if(Sold.value == 'No') {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.isSold == 0 &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.isSold == 0 ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.isSold == 0)
    //           .toList();
    //     }
    //   } else {
    //     if (Condition.value == 'New') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Phone_Condition == 'New' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Phone_Condition == 'New')
    //           .toList();
    //     } else if (Condition.value == 'Used') {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //                   invoice.Phone_Condition == 'Used' ||
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase()) &&
    //                   invoice.Phone_Condition == 'Used')
    //           .toList();
    //     } else {
    //       return repairs
    //           .where((invoice) =>
    //               (invoice.Brand_Name +
    //                           ' ' +
    //                           invoice.Phone_Name +
    //                           ' ' +
    //                           invoice.Capacity)
    //                       .toLowerCase()
    //                       .contains(query.toLowerCase()) &&
    //               invoice.IMEI.toLowerCase().contains(query.toLowerCase())
    //                   )
    //           .toList();
    //     }
    //   }
  }

  RxDouble total = 0.0.obs;
  RxDouble totalrec = 0.0.obs;
  RxDouble totaldue = 0.0.obs;

  void CalTotal() {
    Username = sharedPreferencesController.username;
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    // print(formattedDate);
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;
    total.value = 0;

    List<RepairsModel> totalofrepairs = repairs
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Repair_Rec_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofrepairs.length; i++) {
      total.value += totalofrepairs[i].Repair_Price;
      totalrec.value += totalofrepairs[i].Received_Money;
      totaldue.value += totalofrepairs[i].Repair_Cost;
    }
  }

  void fetchrepairs() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_repairs.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          repairs.assignAll(
              data.map((item) => RepairsModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (repairs.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            total.value = 0;
            totalrec.value = 0;
            totaldue.value = 0;

            CalTotal();
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
