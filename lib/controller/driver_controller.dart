// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/driver_model.dart';
import 'package:treschic/model/supplier_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverController extends GetxController {
  RxList<DriverModel> drivers = <DriverModel>[].obs;
  bool isDataFetched = false;
  String result = '';
    RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetch_drivers();
  }

  List<DriverModel> searchDrivers(String query) {
    return drivers
        .where((driver) =>
            driver.Driver_Name.toLowerCase().contains(query.toLowerCase()) || driver.Driver_Number.toLowerCase().contains(query.toLowerCase()))
        .toList()  ;
  }
  void closeLoading() {}

  String result2 = '';
   Future<void> UploadDriver(
      String Driver_Name, String Driver_Number) async {
    try {
      print(Driver_Name + Driver_Number);
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_driver.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Driver_Name": Driver_Name,
        "Driver_Number": Driver_Number,
      });

      var response = json.decode(json.encode(res.body));
      Driver_Name = '';
      Driver_Number = '';
      print(response);
      result2 = response;
      if (response.toString().trim() == 'Driver inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Driver already exists.') {}
    } catch (e) {
      print(e);
    }
  }

  void fetch_drivers() async {
    if (!isDataFetched) {
      try {
                isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_drivers.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          drivers.assignAll(
              data.map((item) => DriverModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
                    isLoading.value = false;

          if (drivers.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            print('drivers');
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
