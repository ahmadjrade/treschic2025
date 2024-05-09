// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdatePhoneController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UpdatePhone(
      String Phone_id,String IMEI,String Note,String Cost,String Sell_Price,String Capacity,String Color,String Condition) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'update_phone.php';
       print(Phone_id);
       print(IMEI);
       print(Note);
       print(Cost);
       print(Sell_Price);
       print(Capacity);
       print(Color);
       print(Condition);
      var res = await http.post(Uri.parse(uri), body: {
       

        "Phone_id": Phone_id,
        "IMEI": IMEI,
        "Note": Note,
         "Cost": Cost,
         "Sell_Price": Sell_Price,
        "Capacity": Capacity,
        "Color": Color,
        "Condition": Condition,
      });

      var response = json.decode(json.encode(res.body));
      Phone_id = '';
      IMEI = '';
      Note = '';
      Cost= '';
      Sell_Price = '';
      Capacity= '';
      Color = '';
      Condition = '';
       print(response);
      result = response;
      if (response.toString().trim() == 'Phone Updated successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
