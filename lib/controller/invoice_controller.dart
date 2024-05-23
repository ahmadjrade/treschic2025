// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:get/get.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class InvoiceController extends GetxController {
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;
  RxList<ProductDetailModel> invoiceItems = <ProductDetailModel>[].obs;
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

    for (int i = 0; i < invoiceItems.length; i++) {
      invoiceItems[i].quantity.value = 1;
    }
    invoiceItems.clear();
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
    for (var item in invoiceItems) {
      totalUsd.value += item.product_MPrice * item.quantity.value;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in invoiceItems) {
      totalLb.value += (item.product_MPrice * item.quantity.value) *
          rateController.rateValue.value;
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in invoiceItems) {
      totalQty.value += item.quantity.value;
    }
  }

  void updateItemPrice(ProductDetailModel item, double newPrice) {
    item.product_MPrice = newPrice;
    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();
    calculateDueUSD();
    calculateDueLB();
  }

  void UpdateQty(ProductDetailModel product, qty) {
    if (qty > product.Product_Quantity) {
      Get.snackbar('Error', 'This Quantity is not available');
    } else {
      product.quantity.value = qty;
      calculateTotalLb();
      calculateDueUSD();
      calculateDueLB();
      calculateTotal();
      calculateTotalQty();
    }
  }

  void IncreaseQty(ProductDetailModel product) {
    product.quantity += 1;
    calculateTotalLb();
    calculateDueUSD();
    calculateDueLB();
    calculateTotal();
    calculateTotalQty();
  }

  void DecreaseQty(ProductDetailModel product) {
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
    ProductDetailModel? product;
    Username = sharedPreferencesController.username;
    // Iterate through the products list to find the matching product
    for (var prod in productDetailController.product_detail) {
      if (prod.Product_Code == productCodeController &&
          prod.Username == Username.value) {
        product = prod;
        break;
      }
    }

    if (product != null) {
      // Check if the product already exists in the invoice
      if (invoiceItems.contains(product)) {
        if (product.quantity.value == product.Product_Quantity) {
          Get.snackbar('Product Already Added', 'Max Quantity Reached.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2));
        } else {
          product.quantity.value += 1;
          calculateTotalLb();
          calculateDueUSD();
          calculateDueLB();
          calculateTotal();
          calculateTotalQty();
          // Get.snackbar('Product Qty Increased', 'Code $productCodeController',
          //     snackPosition: SnackPosition.BOTTOM,
          //     duration: const Duration(seconds: 1));
        }
        // Display message when the product is already in the invoice
        // Get.snackbar(
        //     'Product Already Added', 'The product is already in the invoice.',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: const Duration(seconds: 2));
      } else if (product.Product_Quantity == 0) {
        Get.snackbar('Product Addition Failed', 'No More Quantity.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        // Add the product to the invoice
        invoiceItems.add(product);
        calculateTotal();
        calculateTotalLb();
        calculateDueUSD();
        calculateDueLB();
        calculateTotalQty();
        Get.snackbar(
            'Product Added To Invoice', 'Product Code $productCodeController',
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

  Future<void> uploadInvoiceToDatabase(
      String Cus_id, String Cus_Name, String Cus_Number) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      // Prepare invoice data
      List<Map<String, dynamic>> invoiceData = [];

      for (ProductDetailModel product in invoiceItems) {
        invoiceData.add({
          'Store_id': product.Product_Store,
          'Product_id': product.Product_id,
          'Product_Name': product.Product_Name,
          'Product_Qty': product.quantity.value,
          'Product_UP': product.product_MPrice,
          'Product_TP': (product.quantity.value * product.product_MPrice),
          'Product_Code': product.Product_Code,
          'Product_Color': product.Product_Color,
        });
      }

      // Send invoice data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain' 'insert_invoice.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Invoice_Store': Username.value,
          'item_count': totalQty.value,
          'Invoice_Total_USD': totalUsd.value,
          'Invoice_Total_Lb': totalLb.value,
          'Invoice_Rec_Usd': ReceivedUSD.value,
          'Invoice_Rec_Lb': ReceivedLb.value,
          'Invoice_Due_USD': DueLB.value / rateController.rateValue.value,
          'Invoice_Due_LB': DueLB.value,
          'Cus_id': Cus_id,
          'Cus_Name': Cus_Name,
          'Cus_Number': Cus_Number,
          'Invoice_Date': formattedDate,
          'Invoice_Time': formattedTime,
          'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
          'Invoice_Type': 'Store',
          'Invoice_Rate': rateController.rateValue.value,
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
