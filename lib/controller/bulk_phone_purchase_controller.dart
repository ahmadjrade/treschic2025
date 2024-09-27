// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/phonemodels_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class BulkPhonePurchaseController extends GetxController {
  final PhoneModelController phoneModelController = Get.find<PhoneModelController>();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  final RateController rateController = Get.find<RateController>();

  RxString Username = ''.obs;
  RxList<PhoneModelsModel> phonepurchase_items = <PhoneModelsModel>[].obs;
  RxDouble totalUsd = 0.0.obs;
  RxDouble totalLb = 0.0.obs;
  RxDouble invoice_due = 0.0.obs;
  RxDouble totalQty = 0.0.obs;
  RxDouble ReceivedUSD = 0.0.obs;
  RxDouble ReceivedLb = 0.0.obs;
  RxDouble ReturnUSD = 0.0.obs;
  RxDouble ReturnLB = 0.0.obs;
  RxDouble DueUSD = 0.0.obs;
  RxDouble DueLB = 0.0.obs;

  void reset() {
    DueLB.value = 0;
    DueUSD.value = 0;
    ReceivedUSD.value = 0;
    ReceivedLb.value = 0;
    calculateDueUSD();
    calculateDueLB();

    ReturnLB.value = 0;
    ReturnUSD.value = 0;
    invoice_due.value = 0;
    totalLb.value = 0;
    totalUsd.value = 0;
    totalQty.value = 0;

    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();

    // for (int i = 0; i < phonepurchase_items.length; i++) {
    //   phonepurchase_items[i].quantity.value = 1;
    // }
    phonepurchase_items.clear();
  }

  void resetRecUsd() {
    ReceivedUSD.value = 0.0;
    calculateDueUSD();
    calculateDueLB();
  }

  void resetRecLb() {
    ReceivedLb.value = 0.0;
    calculateDueUSD();
    calculateDueLB();
  }

  void calculateDueUSD() {
    DueUSD.value = 0.0;
    DueUSD.value = totalUsd.value -
        (ReceivedUSD.value +
            (ReceivedLb.value / rateController.rateValue.value));
  }

  void calculateDueLB() {
    DueLB.value = 0.0;
    DueLB.value = totalLb.value -
        (ReceivedLb.value +
            (ReceivedUSD.value * rateController.rateValue.value));
  }

  void calculateTotal() {
    totalUsd.value = 0.0;
    for (var item in phonepurchase_items) {
      totalUsd.value += item.Purchase_Price;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in phonepurchase_items) {
      totalLb.value += (item.Purchase_Price ) *
          rateController.rateValue.value;
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in phonepurchase_items) {
      totalQty.value += item.quantity.value;
    }
  }

  double savedcost = 0;
  void UpdatePhonePrice(int ind, String price) {
  // Copy the phone model at the specified index with the updated capacity
  var updatedPhone = phonepurchase_items[ind].copyWith(Purchase_Price: double.tryParse(price));

  // Replace the original phone model at the index with the updated phone
  phonepurchase_items[ind] = updatedPhone;

  // Optionally refresh if using GetX
  phonepurchase_items.refresh();

  // Recalculate totals after the update
  calculateTotal();
  calculateTotalLb();
  calculateTotalQty();
  calculateDueUSD();
  calculateDueLB();
}


  void UpdatePhoneImei(int ind, String imei) {
  // Copy the phone model at the specified index with the updated capacity
  var updatedPhone = phonepurchase_items[ind].copyWith(IMEI: imei);

  // Replace the original phone model at the index with the updated phone
  phonepurchase_items[ind] = updatedPhone;

  // Optionally refresh if using GetX
  phonepurchase_items.refresh();

  // Recalculate totals after the update
  calculateTotal();
  calculateTotalLb();
  calculateTotalQty();
  calculateDueUSD();
  calculateDueLB();
}


  void UpdatePhoneCapacity(int ind, String capacity) {
  // Copy the phone model at the specified index with the updated capacity
  var updatedPhone = phonepurchase_items[ind].copyWith(Capacity: capacity);

  // Replace the original phone model at the index with the updated phone
  phonepurchase_items[ind] = updatedPhone;

  // Optionally refresh if using GetX
  phonepurchase_items.refresh();

  // Recalculate totals after the update
  calculateTotal();
  calculateTotalLb();
  calculateTotalQty();
  calculateDueUSD();
  calculateDueLB();
}


  void UpdatePhoneColor(int ind, int color,String color_name) {
  // Copy the phone model at the specified index with the updated capacity
  var updatedPhone = phonepurchase_items[ind].copyWith(Color_id: color,ColorName: color_name);

  // Replace the original phone model at the index with the updated phone
  phonepurchase_items[ind] = updatedPhone;

  phonepurchase_items.refresh();

  calculateTotal();
  calculateTotalLb();
  calculateTotalQty();
  calculateDueUSD();
  calculateDueLB();
}


  void FetchPhone(String phone_name) {
    PhoneModelsModel? phone;
    Username = sharedPreferencesController.username;
    for (var prod in phoneModelController.phone_model) {
      if (prod.Phone_Name == phone_name) {
        phone = prod;
        break;
      }
    }

    if (phone != null) {
      
        phonepurchase_items.add(phone);
        calculateTotal();
        calculateTotalLb();
        calculateDueUSD();
        calculateDueLB();
        calculateTotalQty();
        Get.snackbar(
            'Phone Added To Purchase', 'Phone IMEI $phone_name',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      
    } else {
      // Display error message when phone is not found
      Get.snackbar('Phone Not Found',
          'The phone with the provided IMEI does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  String result = '';
  DomainModel domainModel = DomainModel();
  int isPaid(due) {
    if (due == 0) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<void> uploadPurchaseToDatabase(
      String Supplier_id, String Supplier_Name, String Supplier_Number) async {
    try {
       Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      List<Map<String, dynamic>> purchaseData = [];

      for (PhoneModelsModel phone in phonepurchase_items) {
        purchaseData.add({
          'Store_id': Username.value,
          'Brand_id': phone.Brand_id,
          'Phone_Model_id': phone.Phone_Model_id,
          'Phone_Name': phone.Phone_Name,
          'Phone_IMEI': phone.IMEI,
          'Phone_Color_id': phone.Color_id,
          'Phone_Capacity': phone.Capacity,
          'Phone_Price': phone.Purchase_Price,
        });
      }

      String domain = domainModel.domain;
      String uri = '$domain' 'insert_phone_purchase.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Purchase_Store': Username.value,
          'Supplier_id': Supplier_id,
          'Supplier_Name': Supplier_Name,
          'Supplier_Number': Supplier_Number,
          'item_count': totalQty.toString(),
          'Purchase_Total_USD': totalUsd.value,
          'Purchase_Total_LB': totalLb.value,
          'Purchase_Rec_Usd': ReceivedUSD.value,
          'Purchase_Rec_LB': ReceivedLb.value,
          'Purchase_Due_USD': DueLB.value / rateController.rateValue.value,
          'Purchase_Due_LB': DueLB.value,
          'Purchase_Date': formattedDate,
          'Purchase_Time': formattedTime,
          'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
          'phonepurchase_items': purchaseData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Data successfully sent to the API
        print('Data sent successfully');
        result = 'Purchase Sent Successfully';
        // Continue with the rest of the logic if needed
      } else {
        // Error occurred while sending the data
        print('Error sending data. StatusCode: ${response.statusCode}');
        result = 'Purchase Sending Failed';
      }
    } catch (error) {
      // Exception occurred while sending the data
      print('Exception: $error');
    }
  }
  
}
