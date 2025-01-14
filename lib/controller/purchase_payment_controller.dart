// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolation, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/model/invoice_payment_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/model/purchase_payment_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchasePaymentController extends GetxController {
  RxList<PurchasePaymentModel> payments = <PurchasePaymentModel>[].obs;
  RxList<PurchasePaymentModel> displayedPayments = <PurchasePaymentModel>[].obs; // Displayed payments
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs; // To track loading more data
  Rx<PurchasePaymentModel?> SelectedPayment = Rx<PurchasePaymentModel?>(null);
  RxString Store = 'this'.obs;
  RxString Sold = 'Yes'.obs;
  RxString Condition = 'New'.obs;
  RxBool iseditable = false.obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
   RxInt itemsToShow = 20.obs; 

  final int itemsPerPage = 20; // Number of items to load per page
  int currentPage = 1; // To track the current page

  void clearSelectedCat() {
    SelectedPayment.value = null;
    payments.clear();
    displayedPayments.clear(); // Clear displayed payments as well
  }
  void onClose(){ 
     itemsToShow.value = 20;
    super.onClose();
  }
   void resetItemsToShow() {
    itemsToShow.value = 20;
  }
  void reset() {
    total.value = 0;
   
  }

  RxBool isShown = false.obs;

  bool isshow(int val) {
    if (val == 0) {
      isShown.value == false;
      return false;
    } else {
      isShown.value == true;
      return true;
    }
  }

  bool ispaid(int isSold) {
    if (isSold == 1) {
      return true;
    } else {
      return false;
    }
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
    fetch_payments();
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  

  List<PurchasePaymentModel> SearchPayments(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return payments
        .where((payment) =>
            (payment.Purchase_id.toString()).contains(query.toLowerCase()) &&
                payment.Username == Username.value &&
                payment.Payment_Date.contains(formattedDate) ||
            payment.Supplier_Name!.toLowerCase().contains(query.toLowerCase()) &&
                payment.Username == Username.value &&
                payment.Payment_Date.contains(formattedDate) ||
            payment.Supplier_Number!.toLowerCase().contains(query.toLowerCase()) &&
                payment.Username == Username.value &&
                payment.Payment_Date.contains(formattedDate))
        .toList();
  }
  List<PurchasePaymentModel> SearchInvoicesYesterday(String query) {
  // Get the date for yesterday
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));

  // Format the date for yesterday
  String day = yesterday.day.toString().padLeft(2, '0');
  String month = yesterday.month.toString().padLeft(2, '0');
  String year = yesterday.year.toString();

  formattedDate = '$year-$month-$day';
  formattedTime = dateController.getFormattedTime();
  Username = sharedPreferencesController.username;

  return payments
      .where((payment) =>
          (payment.Purchase_id.toString()).contains(query.toLowerCase()) &&
              payment.Username == Username.value &&
              payment.Payment_Date.contains(formattedDate) ||
          payment.Supplier_Name!.toLowerCase().contains(query.toLowerCase()) &&
              payment.Username == Username.value &&
              payment.Payment_Date.contains(formattedDate) ||
          payment.Supplier_Number!.toLowerCase().contains(query.toLowerCase()) &&
              payment.Username == Username.value &&
              payment.Payment_Date.contains(formattedDate))
      .toList();
}
  List<PurchasePaymentModel> SearchInvoicesAll(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return payments
        .where((payment) =>
            (payment.Purchase_id.toString()).contains(query.toLowerCase()) &&
                payment.Username == Username.value  ||
            payment.Supplier_Name!.toLowerCase().contains(query.toLowerCase()) &&
                payment.Username == Username.value ||
            payment.Supplier_Number!.toLowerCase().contains(query.toLowerCase()) &&
                payment.Username == Username.value )
        .toList();
  }

List<PurchasePaymentModel> SearchInvoicesMonth(String query) {
  DateTime now = DateTime.now(); // Get today's date
  int getMonthNumber(DateTime date) {
  return date.month;
}
  int monthNumber = getMonthNumber(now);
  

  Username = sharedPreferencesController.username;

  return payments
      .where((payment) =>
          (payment.Purchase_id.toString()).contains(query.toLowerCase()) &&
              payment.Username == Username.value &&
              payment.Payment_Month == (monthNumber) ||
          payment.Supplier_Name!.toLowerCase().contains(query.toLowerCase()) &&
              payment.Username == Username.value &&
              payment.Payment_Month == (monthNumber) ||
          payment.Supplier_Number!.toLowerCase().contains(query.toLowerCase()) &&
              payment.Username == Username.value &&
             payment.Payment_Month == (monthNumber))
      .toList();
  }


  RxDouble total = 0.0.obs;
  


  RxDouble total_yday = 0.0.obs;
  

   RxDouble total_all = 0.0.obs;
  


     RxDouble total_month = 0.0.obs;

  
    RxDouble total_fhome = 0.0.obs;
  
     void CalTotal_fhome() {
    Username = sharedPreferencesController.username;
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    // print(formattedDate);
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;
    total_fhome.value = 0;
  

    List<PurchasePaymentModel> totalofinvoices = payments
        .where((payment) =>
            payment.Username == Username.value &&
            payment.Payment_Date.contains(formattedDate) && !payment.Purchase_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_fhome.value += totalofinvoices[i].Ammount;
      // totalrecusd_fhome.value += totalofinvoices[i].Invoice_Rec_Usd;
      // totaldue_fhome.value += totalofinvoices[i].Invoice_Due_USD;
      // totalreclb_fhome.value += totalofinvoices[i].Invoice_Rec_Lb;
      // totalrec_fhome.value += totalofinvoices[i].Invoice_Rec_Lb/totalofinvoices[i].Inv_Rate + totalofinvoices[i].Invoice_Rec_Usd;
    }
  } 
  
  void CalTotal() {
    Username = sharedPreferencesController.username;
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    // print(formattedDate);
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;
    total.value = 0;
    

    List<PurchasePaymentModel> totalofinvoices = payments
        .where((payment) =>
            payment.Username == Username.value &&
            payment.Payment_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].Ammount;
    }
  } 


   void CalTotalMonth() {
    total_month.value = 0;
    
    Username = sharedPreferencesController.username;
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
  
    // print(formattedDate);
   DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));
  int getMonthNumber(DateTime date) {
  return date.month;
}
  int monthNumber = getMonthNumber(now);
  // Format the date for yesterday
  String day = yesterday.day.toString().padLeft(2, '0');
  String month = yesterday.month.toString().padLeft(2, '0');
  String year = yesterday.year.toString();

  formattedDate = '$year-$month-$day';
  formattedTime = dateController.getFormattedTime();

    List<PurchasePaymentModel> totalofinvoices = payments
        .where((payment) =>
            payment.Username == Username.value &&
            payment.Payment_Month == (monthNumber))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_month .value += totalofinvoices[i].Ammount;


    }
  }

  void CalTotalYday() {
    total_yday.value = 0;
   
    Username = sharedPreferencesController.username;
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
  
    // print(formattedDate);
   DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));

  // Format the date for yesterday
  String day = yesterday.day.toString().padLeft(2, '0');
  String month = yesterday.month.toString().padLeft(2, '0');
  String year = yesterday.year.toString();

  formattedDate = '$year-$month-$day';
  formattedTime = dateController.getFormattedTime();

    List<PurchasePaymentModel> totalofinvoices = payments
        .where((payment) =>
            payment.Username == Username.value &&
            payment.Purchase_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_yday .value += totalofinvoices[i].Ammount;


    }
  }
  void CalTotalall() {
    total_all.value = 0;
   
    Username = sharedPreferencesController.username;


  
    List<PurchasePaymentModel> totalofinvoices = payments
        .where((payment) =>
            payment.Username == Username.value 
          )
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_all .value += totalofinvoices[i].Ammount;
      

    }
  }
  void fetch_payments() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_purchases_payments.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          payments.assignAll(
              data.map((item) => PurchasePaymentModel.fromJson(item)).toList());
          isDataFetched = true;
          // Initially display the first batch of payments
          displayedPayments.assignAll(payments.take(itemsPerPage));
          currentPage = 1; // Reset page count
          isLoading.value = false;

          if (payments.isEmpty) {
            print(0);
          } else {
        //    CalTotal();
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

  Future<void> loadMoreInvoices() async {
    if (!isFetchingMore.value && displayedPayments.length < payments.length) {
      isFetchingMore.value = true;
      int startIndex = currentPage * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (endIndex > payments.length) {
        endIndex = payments.length;
      }

      // Simulate a delay for loading more data
      await Future.delayed(Duration(seconds: 2));

      displayedPayments.addAll(payments.sublist(startIndex, endIndex));
      currentPage++;
      isFetchingMore.value = false;
    }
  }

  String result2 = '';

  
}
