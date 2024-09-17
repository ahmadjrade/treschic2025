// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertRepairController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;
        final SharedPreferencesController sharedPreferencesController = Get.find<SharedPreferencesController>(); 
         RxString Username = ''.obs;

  DomainModel domainModel = DomainModel();
  String result = '';
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  Future<void> UploadRepair(String Cus_id,
      String Customer_Number, String Customer_Name,String Phone_Model,String Phone_Password,String IMEI,String Phone_Issue,String Note,String Receivied_Money,String Repair_Price) async {
    try {
        Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_repair.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Cus_id": Cus_id,
        "Store_id": Username.toString(),
        "Customer_Number": Customer_Number,
        "Customer_Name": Customer_Name,  
        "Phone_Model": Phone_Model,
        "Phone_Password": Phone_Password,
                "Phone_IMEI": IMEI,
        "Phone_Issue": Phone_Issue,
        "Note": Note,  
        "Receivied_Money": Receivied_Money,
                "Repair_Price": Repair_Price,

        "Repair_Rec_Date": formattedDate,     
        "Repair_Rec_Time": formattedTime,

        
      });

      var response = json.decode(json.encode(res.body));

      print(response);
      result = response;
      if (response.toString().trim() == 'Repair inserted successfully.') {
        //  result = 'refresh';
      }
    } catch (e) {
      print(e);
    }
  }
}
