// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolation, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoiceHistoryController extends GetxController {
  RxList<InvoiceModel> invoices = <InvoiceModel>[].obs;
  RxList<InvoiceModel> displayedInvoices =
      <InvoiceModel>[].obs; // Displayed invoices
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs; // To track loading more data
  Rx<InvoiceModel?> SelectedInvoice = Rx<InvoiceModel?>(null);
  RxString Store = 'this'.obs;
  RxString Sold = 'Yes'.obs;
  RxString Condition = 'New'.obs;
  RxBool iseditable = false.obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  RxInt itemsToShow = 20.obs;
  final RateController rateController = Get.find<RateController>();

  final int itemsPerPage = 20; // Number of items to load per page
  int currentPage = 1; // To track the current page

  void clearSelectedCat() {
    SelectedInvoice.value = null;
    invoices.clear();
    displayedInvoices.clear(); // Clear displayed invoices as well
  }

  void onClose() {
    itemsToShow.value = 20;
    super.onClose();
  }

  void resetItemsToShow() {
    itemsToShow.value = 20;
  }

  void reset() {
    total.value = 0;
    totalrecusd.value = 0;
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
    fetchinvoices();
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  List<InvoiceModel> SearchInvoices(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate))
        .toList();
  }

  List<InvoiceModel> SearchInvoicesYesterday(String query) {
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

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate))
        .toList();
  }

  List<InvoiceModel> SearchInvoicesAll(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value)
        .toList();
  }

  List<InvoiceModel> SearchInvoicesAllForCustomer(String query, cus_id) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Cus_Name == cus_id ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Cus_Name == cus_id ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Cus_Name == cus_id)
        .toList();
  }

  List<InvoiceModel> SearchInvoicesAllForDriver(String query, driver_id) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Driver_id == int.tryParse(driver_id) &&
                invoice.isPaid == 0 ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Driver_id == int.tryParse(driver_id) &&
                invoice.isPaid == 0 ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Driver_id == int.tryParse(driver_id) &&
                invoice.isPaid == 0)
        .toList();
  }

  List<InvoiceModel> SearchInvoicesMonth(String query) {
    DateTime now = DateTime.now(); // Get today's date
    int getMonthNumber(DateTime date) {
      return date.month;
    }

    int monthNumber = getMonthNumber(now);

    Username = sharedPreferencesController.username;

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber) ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber) ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber))
        .toList();
  }

  List<InvoiceModel> SearchDueInvoices(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoices
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Due_USD != 0 ||
            invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Due_USD != 0 ||
            invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Due_USD != 0)
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

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_fhome.value += totalofinvoices[i].Invoice_Rec_Usd +
          (totalofinvoices[i].Invoice_Rec_Lb / rateController.rateValue.value);
      totalrecusd_fhome.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue_fhome.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb_fhome.value += totalofinvoices[i].Invoice_Rec_Lb;
      totalrec_fhome.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
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

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrecusd.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb.value += totalofinvoices[i].Invoice_Rec_Lb;
      totalrec.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
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

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Month == (monthNumber))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_month.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrecusd_month.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue_month.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb_month.value += totalofinvoices[i].Invoice_Rec_Lb;
      totalrec_month.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
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

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_yday.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrecusd_yday.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue_yday.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb_yday.value += totalofinvoices[i].Invoice_Rec_Lb;
      totalrec_yday.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
    }
  }

  void CalTotalall() {
    total_all.value = 0;
    totaldue_all.value = 0;
    totalrecusd_all.value = 0;
    totalreclb_all.value = 0;
    totalrec_all.value = 0;

    Username = sharedPreferencesController.username;

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) => invoice.Username == Username.value)
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_all.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrecusd_all.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue_all.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb_all.value += totalofinvoices[i].Invoice_Rec_Lb;

      totalrec_all.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
    }
  }

  void CalDueForDriver(driver_name) {
    total_driver.value = 0;
    totaldue_driver.value = 0;
    totalrecusd_driver.value = 0;
    totalreclb_driver.value = 0;
    totalrec_driver.value = 0;

    Username = sharedPreferencesController.username;

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Driver_Name == driver_name &&
            invoice.isPaid == 0)
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_driver.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrecusd_driver.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue_driver.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb_driver.value += totalofinvoices[i].Invoice_Rec_Lb;

      totalrec_driver.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
    }
  }

  void CalTotalallforcustomer(cus_name) {
    total_all.value = 0;
    totaldue_all.value = 0;
    totalrecusd_all.value = 0;
    totalreclb_all.value = 0;
    totalrec_all.value = 0;

    Username = sharedPreferencesController.username;

    List<InvoiceModel> totalofinvoices = invoices
        .where((invoice) =>
            invoice.Username == Username.value && invoice.Cus_Name == cus_name)
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_all.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrecusd_all.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue_all.value += totalofinvoices[i].Invoice_Due_USD;
      totalreclb_all.value += totalofinvoices[i].Invoice_Rec_Lb;

      totalrec_all.value +=
          totalofinvoices[i].Invoice_Rec_Lb / totalofinvoices[i].Inv_Rate +
              totalofinvoices[i].Invoice_Rec_Usd;
    }
  }

  void fetchinvoices() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_invoices.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          invoices.assignAll(
              data.map((item) => InvoiceModel.fromJson(item)).toList());
          isDataFetched = true;
          // Initially display the first batch of invoices
          displayedInvoices.assignAll(invoices.take(itemsPerPage));
          currentPage = 1; // Reset page count
          isLoading.value = false;

          if (invoices.isEmpty) {
            print(0);
          } else {
            CalTotal();
            CalTotalMonth();
            CalTotal_fhome();
            CalTotalYday();
            CalTotalall();
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
    if (!isFetchingMore.value && displayedInvoices.length < invoices.length) {
      isFetchingMore.value = true;
      int startIndex = currentPage * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (endIndex > invoices.length) {
        endIndex = invoices.length;
      }

      // Simulate a delay for loading more data
      await Future.delayed(Duration(seconds: 2));

      displayedInvoices.addAll(invoices.sublist(startIndex, endIndex));
      currentPage++;
      isFetchingMore.value = false;
    }
  }

  String result2 = '';
  Future<void> PayInvDue(
      String Inv_id, Ammount, Old_Due, New_Due, Cus_id, String Date) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;

      String uri = '$domain' + 'insert_inv_payment.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Invoice_id": Inv_id,
        "Ammount": Ammount,
        "Payment_Date": formattedDate,
        "Payment_Time": formattedDate,
        "Username": Username.value,
        "Old_Due": Old_Due,
        "New_Due": New_Due,
        "Cus_id": Cus_id,
        "Invoice_Date": Date,
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
