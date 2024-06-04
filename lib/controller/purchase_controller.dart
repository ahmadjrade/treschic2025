// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:get/get.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class PurchaseController extends GetxController {
  final ProductController productController = Get.find<ProductController>();

  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  final RateController rateController = Get.find<RateController>();

  RxString Username = ''.obs;
  RxList<ProductModel> purchaseItems = <ProductModel>[].obs;
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

    for (int i = 0; i < purchaseItems.length; i++) {
      purchaseItems[i].quantity.value = 1;
    }
    purchaseItems.clear();
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
    for (var item in purchaseItems) {
      totalUsd.value += item.product_Cost * item.quantity.value;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in purchaseItems) {
      totalLb.value += (item.product_Cost * item.quantity.value) *
          rateController.rateValue.value;
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in purchaseItems) {
      totalQty.value += item.quantity.value;
    }
  }

  double savedcost = 0;
  void updateItemPrice(ProductModel item, double newPrice) {
    item.product_Cost = newPrice;
    // if(savedcost != 0) {
    //   item.product_Cost = savedcost;
    //   double oldcost = item.product_Cost * item.Product_Quantity;
    // double newcost = item.quantity.value * newPrice;
    // item.product_Cost = (oldcost + newcost )/ (item.Product_Quantity + item.quantity.value);
    // //  item.product_Cost = ( (item.Product_Quantity * ) ()newPrice );
    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();
    calculateDueUSD();
    calculateDueLB();
    // } else  {
    //   savedcost = item.product_Cost;
    //    double oldcost = item.product_Cost * item.Product_Quantity;
    // double newcost = item.quantity.value * newPrice;
    // item.product_Cost = (oldcost + newcost )/ (item.Product_Quantity + item.quantity.value);
    // //  item.product_Cost = ( (item.Product_Quantity * ) ()newPrice );
    // calculateTotal();
    // calculateTotalLb();
    // calculateTotalQty();
    // calculateDueUSD();
    // calculateDueLB();
    // }
  }

  void UpdateQty(ProductModel product, qty) {
    product.quantity.value = qty;
    calculateTotalLb();
    calculateDueUSD();
    calculateDueLB();
    calculateTotal();
    calculateTotalQty();
  }

  void IncreaseQty(ProductModel product) {
    product.quantity += 1;
    calculateTotalLb();
    calculateDueUSD();
    calculateDueLB();
    calculateTotal();
    calculateTotalQty();
  }

  void DecreaseQty(ProductModel product) {
    if (product.quantity.value == 1) {
      Get.snackbar('Error', 'Product Quantity Can\'t Be Zero.');
    } else {
      product.quantity -= 1;
      calculateTotalLb();
      calculateDueUSD();
      calculateDueLB();
      calculateTotal();
      calculateTotalQty();
    }
  }

  void fetchProduct(String productCodeController) {
    ProductModel? product;
    Username = sharedPreferencesController.username;
    // Iterate through the products list to find the matching product
    for (var prod in productController.products) {
      if (prod.Product_Code == productCodeController) {
        product = prod;
        break;
      }
    }

    if (product != null) {
      // Check if the product already exists in the invoice
      if (purchaseItems.contains(product)) {
        product.quantity.value += 1;
        calculateTotalLb();
        calculateDueUSD();
        calculateDueLB();
        calculateTotal();
        calculateTotalQty();

        // Display message when the product is already in the invoice
        // Get.snackbar(
        //     'Product Already Added', 'The product is already in the invoice.',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: const Duration(seconds: 2));
      } else {
        // Add the product to the invoice
        purchaseItems.add(product);
        calculateTotal();
        calculateTotalLb();
        calculateDueUSD();
        calculateDueLB();
        calculateTotalQty();
        Get.snackbar(
            'Product Added To Purchase', 'Product Code $productCodeController',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } else {
      // Display error message when product is not found
      Get.snackbar('Product Not Found',
          'The product with the provided code does not exist.',
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
      // Prepare invoice data
      List<Map<String, dynamic>> purchaseData = [];

      for (ProductModel product in purchaseItems) {
        purchaseData.add({
          'Store_id': Username.value,
          'Product_id': product.Product_id,
          'Product_Name': product.Product_Name,
          'Product_Code': product.Product_Code,
          'Product_Color': product.Product_Color,
          'Product_Qty': product.quantity.value,
          'Product_UC': product.product_Cost,
          'Product_TC': (product.quantity.value * product.product_Cost),
        });
      }

      // Send invoice data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain' 'insert_purchase.php';
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
          'purchaseItems': purchaseData,
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
