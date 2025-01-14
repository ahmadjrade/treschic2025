// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BuyAccessoriesController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';

  String formattedTime = '';
  
  Future<void> UploadPhone(int Cus_id,String Cus_Number,String Cus_Name,int Brand_id,int Phone_Model_id,int Color_id
     , String Condition,String Capacity,String IMEI,String Note,String Price) async {
    try {
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;
      String uri = '$domain' + 'buy_phone.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Cus_id": Cus_id.toString(),
         "Cus_Number": Cus_Number,
        "Cus_Name": Cus_Name,
        "Brand_id": Brand_id.toString(),
        "Phone_Model_id": Phone_Model_id.toString(),
        "Color_id": Color_id.toString(),
        "Phone_Condition": Condition,
        "Capacity": Capacity,
        "IMEI": IMEI,
        "Note": Note,
        "Price":Price,
        "Buy_Date": formattedDate,  
        "Buy_Time": formattedTime,
        
      });

      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Phone Bought successfully.') {
        //  result = 'refresh';
      }
    } catch (e) {
      print(e);
    }
  }
}
