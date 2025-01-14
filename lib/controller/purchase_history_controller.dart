// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/rate_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/model/purchase_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

class PurchaseHistoryController extends GetxController {
  RxList<PurchaseModel> purchases = <PurchaseModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<PurchaseModel?> SelectedPurchase = Rx<PurchaseModel?>(null);
  RxString Store = 'this'.obs;
  RxString Sold = 'Yes'.obs;
  RxString Condition = 'New'.obs;
  RxBool iseditable = false.obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  final RateController rateController = Get.find<RateController>();
  RxInt itemsToShow = 20.obs;

  //RxString show = 'Yes'.obs;
  void clearSelectedCat() {
    SelectedPurchase.value = null;
    purchases.clear();
  }

  void reset() {
    total.value = 0;
    totalrec.value = 0;
    totaldue.value = 0;
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
    //  fetchpurchases();
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  List<PurchaseModel> searchPurchases(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return purchases
        .where((purchase) =>
            (purchase.Purchase_id.toString()).contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Date.contains(formattedDate) ||
            purchase.Supplier_Name!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Date.contains(formattedDate) ||
            purchase.Supplier_Number!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Date.contains(formattedDate))
        .toList();
  }

  List<PurchaseModel> SearchPurchasesYesterday(String query) {
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

    return purchases
        .where((purchase) =>
            (purchase.Purchase_id.toString()).contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Date.contains(formattedDate) ||
            purchase.Supplier_Name!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Date.contains(formattedDate) ||
            purchase.Supplier_Number!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Date.contains(formattedDate))
        .toList();
  }

  List<PurchaseModel> SearchPurchasesAll(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return purchases
        .where((purchase) =>
            (purchase.Purchase_id.toString()).contains(query.toLowerCase()) &&
                purchase.Username == Username.value ||
            purchase.Supplier_Name!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value ||
            purchase.Supplier_Number!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value)
        .toList();
  }

  List<PurchaseModel> SearchPurchasesMonth(String query) {
    DateTime now = DateTime.now(); // Get today's date
    int getMonthNumber(DateTime date) {
      return date.month;
    }

    int monthNumber = getMonthNumber(now);

    Username = sharedPreferencesController.username;

    return purchases
        .where((purchase) =>
            (purchase.Purchase_id.toString()).contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Month == (monthNumber) ||
            purchase.Supplier_Name!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Month == (monthNumber) ||
            purchase.Supplier_Number!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Month == (monthNumber))
        .toList();
  }

  List<PurchaseModel> SearchDuePurchases(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return purchases
        .where((purchase) =>
            (purchase.Purchase_id.toString()).contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Due_USD != 0 ||
            purchase.Supplier_Name!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Due_USD != 0 ||
            purchase.Supplier_Number!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                purchase.Username == Username.value &&
                purchase.Purchase_Due_USD != 0)
        .toList();
  }

  RxDouble total = 0.0.obs;
  RxDouble totalrecusd = 0.0.obs;
  RxDouble totaldue = 0.0.obs;
  RxDouble totalreclb = 0.0.obs;
  RxDouble totalrec = 0.0.obs;

  RxDouble total_yday = 0.0.obs;
  RxDouble totalrecusd_yday = 0.0.obs;
  RxDouble totaldue_yday = 0.0.obs;
  RxDouble totalreclb_yday = 0.0.obs;
  RxDouble totalrec_yday = 0.0.obs;

  RxDouble total_all = 0.0.obs;
  RxDouble totalrecusd_all = 0.0.obs;
  RxDouble totaldue_all = 0.0.obs;
  RxDouble totalreclb_all = 0.0.obs;
  RxDouble totalrec_all = 0.0.obs;

  RxDouble total_driver = 0.0.obs;
  RxDouble totalrecusd_driver = 0.0.obs;
  RxDouble totaldue_driver = 0.0.obs;
  RxDouble totalreclb_driver = 0.0.obs;
  RxDouble totalrec_driver = 0.0.obs;

  RxDouble total_month = 0.0.obs;
  RxDouble totalrecusd_month = 0.0.obs;
  RxDouble totaldue_month = 0.0.obs;
  RxDouble totalreclb_month = 0.0.obs;
  RxDouble totalrec_month = 0.0.obs;

  RxDouble total_fhome = 0.0.obs;
  RxDouble totalrecusd_fhome = 0.0.obs;
  RxDouble totaldue_fhome = 0.0.obs;
  RxDouble totalreclb_fhome = 0.0.obs;
  RxDouble totalrec_fhome = 0.0.obs;

  RxDouble total_cus = 0.0.obs;
  RxDouble totalrecusd_cus = 0.0.obs;
  RxDouble totaldue_cus = 0.0.obs;
  RxDouble totalreclb_cus = 0.0.obs;
  RxDouble totalrec_cus = 0.0.obs;
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
    totalrecusd_fhome.value = 0;
    totaldue_fhome.value = 0;
    totalreclb_fhome.value = 0;
    totalrec_fhome.value = 0;

    List<PurchaseModel> totalofinvoices = purchases
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Purchase_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_fhome.value += totalofinvoices[i].Purchase_Rec_USD +
          (totalofinvoices[i].Purchase_Rec_LB / rateController.rateValue.value);
      totalrecusd_fhome.value += totalofinvoices[i].Purchase_Rec_USD;
      totaldue_fhome.value += totalofinvoices[i].Purchase_Due_USD;
      totalreclb_fhome.value += totalofinvoices[i].Purchase_Rec_LB;
      totalrec_fhome.value +=
          totalofinvoices[i].Purchase_Rec_LB / totalofinvoices[i].Pur_Rate +
              totalofinvoices[i].Purchase_Rec_USD;
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
    totalrecusd.value = 0;
    totaldue.value = 0;
    totalreclb.value = 0;
    totalrec.value = 0;

    List<PurchaseModel> totalofinvoices = purchases
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Purchase_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].Purchase_Total_USD;
      totalrecusd.value += totalofinvoices[i].Purchase_Rec_USD;
      totaldue.value += totalofinvoices[i].Purchase_Due_USD;
      totalreclb.value += totalofinvoices[i].Purchase_Rec_LB;
      totalrec.value +=
          totalofinvoices[i].Purchase_Rec_LB / totalofinvoices[i].Pur_Rate +
              totalofinvoices[i].Purchase_Rec_USD;
    }
  }

  void CalTotalMonth() {
    total_month.value = 0;
    totaldue_month.value = 0;
    totalrecusd_month.value = 0;
    totalreclb_month.value = 0;
    totalrec_month.value = 0;
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

    List<PurchaseModel> totalofinvoices = purchases
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Month == (monthNumber))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_month.value += totalofinvoices[i].Purchase_Total_USD;
      totalrecusd_month.value += totalofinvoices[i].Purchase_Rec_USD;
      totaldue_month.value += totalofinvoices[i].Purchase_Due_USD;
      totalreclb_month.value += totalofinvoices[i].Purchase_Rec_LB;
      totalrec_month.value +=
          totalofinvoices[i].Purchase_Rec_LB / totalofinvoices[i].Pur_Rate +
              totalofinvoices[i].Purchase_Rec_USD;
    }
  }

  void CalTotalYday() {
    total_yday.value = 0;
    totaldue_yday.value = 0;
    totalrecusd_yday.value = 0;
    totalreclb_yday.value = 0;
    totalrec_yday.value = 0;
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

    List<PurchaseModel> totalofinvoices = purchases
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Purchase_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_yday.value += totalofinvoices[i].Purchase_Total_USD;
      totalrecusd_yday.value += totalofinvoices[i].Purchase_Rec_USD;
      totaldue_yday.value += totalofinvoices[i].Purchase_Due_USD;
      totalreclb_yday.value += totalofinvoices[i].Purchase_Rec_LB;
      totalrec_yday.value +=
          totalofinvoices[i].Purchase_Rec_LB / totalofinvoices[i].Pur_Rate +
              totalofinvoices[i].Purchase_Rec_USD;
    }
  }

  void CalTotalall() {
    total_all.value = 0;
    totaldue_all.value = 0;
    totalrecusd_all.value = 0;
    totalreclb_all.value = 0;
    totalrec_all.value = 0;

    Username = sharedPreferencesController.username;

    List<PurchaseModel> totalofinvoices = purchases
        .where((invoice) => invoice.Username == Username.value)
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_all.value += totalofinvoices[i].Purchase_Total_USD;
      totalrecusd_all.value += totalofinvoices[i].Purchase_Rec_USD;
      totaldue_all.value += totalofinvoices[i].Purchase_Due_USD;
      totalreclb_all.value += totalofinvoices[i].Purchase_Rec_LB;

      totalrec_all.value +=
          totalofinvoices[i].Purchase_Rec_LB / totalofinvoices[i].Pur_Rate +
              totalofinvoices[i].Purchase_Rec_USD;
    }
  }

  void fetchpurchases() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_purchases.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          purchases.assignAll(
              data.map((item) => PurchaseModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (purchases.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            total.value = 0;
            totalrec.value = 0;
            totaldue.value = 0;

            CalTotal();
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

  String result2 = '';
  Future<void> PayInvDue(
      String Pur_id, Ammount, Old_Due, New_Due, Purchase_Date) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;
      print(Pur_id +
          ' | ' +
          Ammount +
          ' | ' +
          Old_Due +
          ' | ' +
          New_Due +
          ' | ' +
          Purchase_Date +
          ' | ' +
          Username.value +
          ' | ' +
          formattedDate +
          ' | ' +
          formattedTime);

      String uri = '$domain' + 'insert_pur_payment.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Purchase_id": Pur_id,
        "Ammount": Ammount,
        "Payment_Date": formattedDate,
        "Payment_Time": formattedDate,
        "Username": Username.value,
        "Old_Due": Old_Due,
        "New_Due": New_Due,
        "Purchase_Date": Purchase_Date,
      });
      // print(Ty + Card_Name + Card_Cost + Card_Price);
      var response = json.decode(json.encode(res.body));

      print(response);
      result2 = response;
      if (response.toString().trim() == 'Payment inserted successfully.') {
        //  result = 'refresh';
      }
    } catch (e) {
      print(e);
    }
  }
}
