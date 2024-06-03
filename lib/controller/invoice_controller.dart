// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:convert';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:get/get.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class InvoiceController extends GetxController {
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
      final PhoneController phoneController =
      Get.find<PhoneController>();
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
  void recalculateAll() {
    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();
    calculateDueUSD();
    calculateDueLB();
  }
   void fetchProduct(String productCodeController) {
    ProductDetailModel? product = _findProductDetail(productCodeController);
    PhoneModel? phone = _findPhone(productCodeController);

    if (product != null) {
      _addProductToInvoice(product);
    } 
    else if (phone != null) {
      _addPhoneToInvoice(phone);
    }
     else {
      Get.snackbar('Product Not Found', 'The product with the provided code does not exist.',
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    }
  }

  ProductDetailModel? _findProductDetail(String productCode) {
    Username.value = sharedPreferencesController.username.value;
    for (var prod in productDetailController.product_detail) {
      if (prod.Product_Code == productCode && prod.Username == Username.value) {
        return prod;
      }
    }
    return null;
  }

  PhoneModel? _findPhone(String productCode) {
    Username.value = sharedPreferencesController.username.value;
    for (var phone in phoneController.phones) {
      if (phone.IMEI == productCode && phone.Username.toLowerCase() == Username.value.toLowerCase() && phone.isSold == 0 ) { // Assuming productCode matches IMEI for PhoneModel
        return phone;
      }
    }
    return null;
  }

  void _addProductToInvoice(ProductDetailModel product) {
    if (invoiceItems.contains(product)) {
      if (product.quantity.value == product.Product_Quantity) {
        Get.snackbar('Product Already Added', 'Max Quantity Reached.',
            snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      } else {
        product.quantity.value += 1;
        recalculateAll();
      }
    } else if (product.Product_Quantity == 0) {
      Get.snackbar('Product Addition Failed', 'No More Quantity.',
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } else {
      invoiceItems.add(product);
      recalculateAll();
      Get.snackbar('Product Added To Invoice', 'Product Code ${product.Product_Code}',
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    }
  }

  void _addPhoneToInvoice(PhoneModel phone) {
    if (invoiceItems.any((item) => item.Product_Code == phone.IMEI)) {
      var existingItem = invoiceItems.firstWhere((item) => item.Product_Code == phone.IMEI);
      if (existingItem.quantity.value == existingItem.Product_Quantity) {
        Get.snackbar('Product Already Added', 'Max Quantity Reached.',
            snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      } else {
        existingItem.quantity.value += 1;
        recalculateAll();
      }
    } else {
      invoiceItems.add(ProductDetailModel(
        PD_id: 0,
         Product_id: phone.Phone_id, 
         Product_Name: phone.Phone_Name, 
         Product_Code: phone.IMEI,
          Product_Color: phone.Color,
           Product_Quantity: 1,
            Product_Max_Quantity: 1, 
            Product_Sold_Quantity: 1, 
            Product_LPrice: 0, 
            Product_MPrice: double.tryParse(phone.Sell_Price.toString())! , 
            Product_Cost: double.tryParse(phone.Price.toString())!, 
            Product_Store: phone.Username, 
            Username: phone.Username,
             quantity: 1.obs
        
        )); // Assuming quantity is represented by Sell_Price
      recalculateAll();
      Get.snackbar('Phone Added To Invoice', 'Product Code ${phone.IMEI}',
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
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
  Future<void> uploadOldInvoiceToDatabase(String Inv_id) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      // Prepare invoice data
      List<Map<String, dynamic>> invoiceData = [];

      for (ProductDetailModel product in invoiceItems) {
        invoiceData.add({
          'Invoice_id': Inv_id,
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
      String uri = '$domain' 'insert_in_oldinvoice.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
           'Inv_id': Inv_id,

          'item_count': totalQty.value,
          'Invoice_Total_USD': totalUsd.value,
          'Invoice_Total_Lb': totalLb.value,
          'Invoice_Rec_Usd': ReceivedUSD.value,
          'Invoice_Rec_Lb': ReceivedLb.value,
          'Invoice_Due_USD': DueLB.value / rateController.rateValue.value,
          'Invoice_Due_LB': DueLB.value,
          
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
