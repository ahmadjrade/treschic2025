// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/domain.dart';

import 'package:fixnshop_admin/model/recharge_cart_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/new_recharge_invoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RechargeCartController extends GetxController {
  RxList<RechargeCartModel> recharge_carts = <RechargeCartModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<RechargeCartModel?> SelectedRechargeCart = Rx<RechargeCartModel?>(null);
  RxList<RechargeCartModel> InvoiceCards = <RechargeCartModel>[].obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;
  final CustomerController customerController = Get.find<CustomerController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  void clearSelectedCat() {
    SelectedRechargeCart.value = null;
    recharge_carts.clear();
  }

  bool isadmin(username) {
    if (username == 'admin') {
      return true;
    } else {
      return false;
    }
  }

  int isPaid(due) {
    if (due == 0) {
      return 1;
    } else {
      return 0;
    }
  }

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetch_recharge_carts();
  }

  List<RechargeCartModel> searchcardss(String query) {
    return recharge_carts
        .where((cart) =>
            cart.Card_Name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  CustomerModel? SelectedCustomer;
  int SelectCusId = 0;
  RxDouble totalLb = 0.0.obs;
  RxDouble totalQty = 0.0.obs;
  RxDouble DueLB = 0.0.obs;
  RxDouble ReceivedLb = 0.0.obs;
  RxDouble ReceivedUSD = 0.0.obs;
  RxBool isDue = false.obs;

  void reset() {
    InvoiceCards.clear();
    SelectCusId = 0;
    totalLb.value = 0.0;
    totalQty.value = 0.0;
    DueLB.value = 0.0;
    ReceivedLb.value = 0.0;
    ReceivedUSD.value = 0.0;
    isDue.value = false;
  }

  void resetRecUsd() {
    ReceivedUSD.value = 0.0;
    calculateDueLB();
  }

  void resetRecLb() {
    ReceivedLb.value = 0.0;
    calculateDueLB();
  }

  void calculateDueLB() {
    DueLB.value = 0.0;
    DueLB.value = totalLb.value -
        (ReceivedLb.value +
            (ReceivedUSD.value * rateController.rateValue.value));
    if (DueLB.value == 0) {
      isDue.value = false;
      customerController.result3.value = '';
      customerController.result4.value = '';
      idController.text = '';
      nameController.text = '';
      numberController.text = '';
    } else {
      isDue.value = true;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in InvoiceCards) {
      totalLb.value += (item.Card_Price * item.quantity.value);
      calculateDueLB();
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in InvoiceCards) {
      totalQty.value += item.quantity.value;
      calculateDueLB();
    }
  }

  void DecreaseQty(RechargeCartModel recharge) {
    recharge.quantity -= 1;
    calculateTotalLb();
    calculateTotalQty();
  }

  void IncreaseQty(RechargeCartModel recharge) {
    recharge.quantity += 1;
    calculateTotalLb();
    calculateTotalQty();
  }

  void fetchcards(String cardName) {
    RechargeCartModel? cards;
    // Username = sharedPreferencesController.username;
    // Iterate through the cardss list to find the matching cards
    for (var card in recharge_carts) {
      if (card.Card_Name == cardName) {
        cards = card;
        break;
      }
    }

    if (cards != null) {
      // Check if the cards already exists in the invoice
      if (InvoiceCards.contains(cards)) {
        cards.quantity.value += 1;
        calculateTotalLb();
        calculateTotalQty();

        print(InvoiceCards);
        // Get.snackbar('cards Qty Increased', 'Code $cardName',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: const Duration(seconds: 1));

        // Display message when the cards is already in the invoice
        // Get.snackbar(
        //     'cards Already Added', 'The cards is already in the invoice.',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: const Duration(seconds: 2));
      } else {
        // Add the cards to the invoice
        InvoiceCards.add(cards);
        print(InvoiceCards);

        calculateTotalLb();

        calculateTotalQty();
        Get.snackbar('cards Added To Invoice', 'cards Code $cardName',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } else {
      // Display error message when cards is not found
      Get.snackbar(
          'cards Not Found', 'The cards with the provided code does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  void fetch_recharge_carts() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_recharge_carts.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          recharge_carts.assignAll(
              data.map((item) => RechargeCartModel.fromJson(item)).toList());
          //category = data.map((item) => cards_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (recharge_carts.isEmpty) {
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

  // String result2 = '';
  // Future<void> UpdatecardsQty(String P_Detail_id, String Qty) async {
  //   try {
  //     String domain = domainModel.domain;
  //     String uri = '$domain' + 'update_cards_quantity.php';

  //     var res = await http.post(Uri.parse(uri), body: {
  //       "P_Detail_id": P_Detail_id,
  //       "Qty": Qty,
  //     });

  //     var response = json.decode(json.encode(res.body));
  //     P_Detail_id = '';
  //     Qty = '';

  //     print(response);
  //     result2 = response;
  //     if (response.toString().trim() ==
  //         'cards Quantity Updated successfully.') {
  //       //  result = 'refresh';
  //     } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  Future<void> uploadRechargeInvoice() async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      // Prepare invoice data
      List<Map<String, dynamic>> invoiceData = [];

      for (RechargeCartModel cards in InvoiceCards) {
        invoiceData.add({
          'Store_id': Username.value,
          'Card_id': cards.Card_id,
          'Card_Name': cards.Card_Name,
          'Card_Qty': cards.quantity.value,
          'Card_UP': cards.Card_Price,
          'Card_TP': (cards.quantity.value * cards.Card_Price),
           'Card_Amount': (cards.Card_Amount.toString()),

          // 'Product_Code': cards.Product_Code,
          // 'Product_Color': cards.Product_Color,
        });
      }
      print(Username.value);
      // Send invoice data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain' 'insert_recharge_invoice.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Invoice_Store': Username.value,
          'item_count': totalQty.value,
          'Invoice_Total_Usd': (totalLb.value / rateController.rateValue.value),
          'Invoice_Total_Lb': totalLb.value,
          'Invoice_Rec_Usd': ReceivedUSD.value,
          'Invoice_Rec_Lb': ReceivedLb.value,
          'Invoice_Due_USD': DueLB.value / rateController.rateValue.value,
          'Invoice_Due_LB': DueLB.value,
          'Cus_id': idController.text,
          'Cus_Name': nameController.text,
          'Cus_Number': numberController.text,
          'Invoice_Date': formattedDate,
          'Invoice_Time': formattedTime,
          'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
          'invoiceItems': invoiceData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Data successfully sent to the API
        print('Data sent successfully');
        result = 'Invoice Sent Successfully';
        // Continue with the rest of the logic if needed
      } else {
        // Error occurred while sending the data
        print('Error sending data. StatusCode: ${response.statusCode}');
        result = 'Invoice Sending Failed';
      }
    } catch (error) {
      // Exception occurred while sending the data
      print('Exception: $error');
    }
  }
}
