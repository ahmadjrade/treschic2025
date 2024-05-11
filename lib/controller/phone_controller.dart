// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneController extends GetxController {
  RxList<PhoneModel> phones = <PhoneModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<PhoneModel?> SelectedPhone = Rx<PhoneModel?>(null);
  RxString Store = 'this'.obs;
  RxString Sold = 'Yes'.obs;
  RxString Condition = 'New'.obs;
  RxBool iseditable = false.obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
        RxString Username = ''.obs;

  //RxString show = 'Yes'.obs;
  void clearSelectedCat() {
    SelectedPhone.value = null;
    phones.clear();
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

  bool issold(int isSold) {
    if (isSold == 1) {
      return true;
    } else {
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
    fetchphones();
  }

  List<PhoneModel> searchPhones(String query, String username) {
    if (Store.value == 'this') {
      if (Sold.value == 'Yes') {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 1 ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 1)
              .toList();
        }
      } else if(Sold.value == 'No'){
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 0 ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      product.isSold == 0)
              .toList();
        }
      } else {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                     
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username &&
                      
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username &&
                      
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username == username 
                      ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username == username 
                      )
              .toList();
        }
      }
    } else if(Store.value == 'other') {
      if (Sold.value == 'Yes') {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 1 ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 1)
              .toList();
        }
      } else if(Sold.value == 'No') {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 0 ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.isSold == 0)
              .toList();
        }
      } else {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Username != username  ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Username != username )
              .toList();
        }
      }
    } else  {
      if (Sold.value == 'Yes') {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      
                      product.isSold == 1 &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.isSold == 1 &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.isSold == 1 ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.isSold == 1)
              .toList();
        }
      } else if(Sold.value == 'No') {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.isSold == 0 &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.isSold == 0 ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.isSold == 0)
              .toList();
        }
      } else {
        if (Condition.value == 'New') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Phone_Condition == 'New' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Phone_Condition == 'New')
              .toList();
        } else if (Condition.value == 'Used') {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                      product.Phone_Condition == 'Used' ||
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) &&
                      product.Phone_Condition == 'Used')
              .toList();
        } else {
          return phones
              .where((product) =>
                  (product.Brand_Name +
                              ' ' +
                              product.Phone_Name +
                              ' ' +
                              product.Capacity)
                          .toLowerCase()
                          .contains(query.toLowerCase()) &&
                  product.IMEI.toLowerCase().contains(query.toLowerCase()) 
                      )
              .toList();
        }
      }
    }
  }
  RxDouble total = 0.0.obs;
  void CalTotal() {
    Username = sharedPreferencesController.username;

    total.value = 0;
    List<PhoneModel> unsoldPhones = phones.where((phone) => phone.isSold == 0).toList();
    for(int i = 0; i < unsoldPhones.length; i++) {
      total.value += unsoldPhones[i].Price;
    }
  }
  void fetchphones() async {
        Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_phones.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          phones.assignAll(
              data.map((item) => PhoneModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (phones.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
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
