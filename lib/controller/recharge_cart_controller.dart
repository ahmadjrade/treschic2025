// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';

import 'package:fixnshop_admin/model/recharge_cart_model.dart';
import 'package:fixnshop_admin/view/buy_accessories.dart';
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
            cart.Cart_Name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  RxDouble totalLb = 0.0.obs;
  RxDouble totalQty = 0.0.obs;

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in InvoiceCards) {
      totalLb.value += (item.Cart_Sell * item.quantity.value);
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in InvoiceCards) {
      totalQty.value += item.quantity.value;
    }
  }

  void DecreaseQty(RechargeCartModel recharge) {
    recharge.quantity-= 1;
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
      if (card.Cart_Name == cardName ) {
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
        Get.snackbar(
            'cards Added To Invoice', 'cards Code $cardName',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } else {
      // Display error message when cards is not found
      Get.snackbar('cards Not Found',
          'The cards with the provided code does not exist.',
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
}
