// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolation, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/expenses_model.dart';
import 'package:treschic/model/invoice_model.dart';
import 'package:treschic/model/invoice_payment_model.dart';
import 'package:treschic/model/product_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpensesController extends GetxController {
  RxList<ExpensesModel> expenses = <ExpensesModel>[].obs;
  RxList<ExpensesModel> displayedExpenses = <ExpensesModel>[].obs; // Displayed expenses
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs; // To track loading more data
  Rx<ExpensesModel?> SelectedExpense = Rx<ExpensesModel?>(null);
  RxString Currency = 'Usd'.obs;
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
    SelectedExpense.value = null;
    expenses.clear();
    displayedExpenses.clear(); // Clear displayed expenses as well
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
  

  List<ExpensesModel> SearchExpenses(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return expenses
        .where((expense) =>
            (expense.Expense_id.toString()).contains(query.toLowerCase()) &&
                expense.Username == Username.value &&
                expense.Expense_Date.contains(formattedDate) ||
            expense.Expense_Desc!.toLowerCase().contains(query.toLowerCase()) &&
                expense.Username == Username.value &&
                expense.Expense_Date.contains(formattedDate) ||
            expense.Exp_Cat_Name!.toLowerCase().contains(query.toLowerCase()) &&
                expense.Username == Username.value &&
                expense.Expense_Date.contains(formattedDate))
        .toList();
  }
  List<ExpensesModel> SearchExpensesYday(String query) {
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

  return expenses
      .where((expense) =>
          (expense.Expense_id.toString()).contains(query.toLowerCase()) &&
              expense.Username == Username.value &&
              expense.Expense_Date.contains(formattedDate) ||
          expense.Expense_Desc!.toLowerCase().contains(query.toLowerCase()) &&
              expense.Username == Username.value &&
              expense.Expense_Date.contains(formattedDate) ||
          expense.Exp_Cat_Name!.toLowerCase().contains(query.toLowerCase()) &&
              expense.Username == Username.value &&
              expense.Expense_Date.contains(formattedDate))
      .toList();
}
  List<ExpensesModel> searchExpensesAll(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return expenses
        .where((expense) =>
            (expense.Expense_id.toString()).contains(query.toLowerCase()) &&
                expense.Username == Username.value  ||
            expense.Expense_Desc!.toLowerCase().contains(query.toLowerCase()) &&
                expense.Username == Username.value ||
            expense.Exp_Cat_Name!.toLowerCase().contains(query.toLowerCase()) &&
                expense.Username == Username.value )
        .toList();
  }

List<ExpensesModel> searchExpensesMonth(String query) {
  DateTime now = DateTime.now(); // Get today's date
  int getMonthNumber(DateTime date) {
  return date.month;
}
  int monthNumber = getMonthNumber(now);
  

  Username = sharedPreferencesController.username;

  return expenses
      .where((expense) =>
          (expense.Expense_id.toString()).contains(query.toLowerCase()) &&
              expense.Username == Username.value &&
              expense.Expense_Month == (monthNumber) ||
          expense.Expense_Desc!.toLowerCase().contains(query.toLowerCase()) &&
              expense.Username == Username.value &&
              expense.Expense_Month == (monthNumber) ||
          expense.Exp_Cat_Name!.toLowerCase().contains(query.toLowerCase()) &&
              expense.Username == Username.value &&
             expense.Expense_Month == (monthNumber))
      .toList();
  }

  // List<ExpensesModel> SearchDueInvoices(String query) {
  //   String dateString = dateController.getFormattedDate();
  //   List<String> dateParts = dateString.split('-');
  //   String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
  //   String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
  //   String formattedDate = '${dateParts[0]}-$month-$day';
  //   formattedTime = dateController.getFormattedTime();
  //   Username = sharedPreferencesController.username;

  //   return expenses
  //       .where((expense) =>
  //           (expense.Expense_id.toString()).contains(query.toLowerCase()) &&
  //               expense.Username == Username.value &&
  //               expense.Invoice_Due_USD != 0 ||
  //           expense.Expense_Desc!.toLowerCase().contains(query.toLowerCase()) &&
  //                expense.Username == Username.value &&
  //               expense.Invoice_Due_USD != 0 || 
  //           expense.Exp_Cat_Name!.toLowerCase().contains(query.toLowerCase()) &&
  //                expense.Username == Username.value &&
  //               expense.Invoice_Due_USD != 0)
  //       .toList();
  // }

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
  

    List<ExpensesModel> totalofinvoices = expenses
        .where((expense) =>
            expense.Username == Username.value &&
            expense.Expense_Date.contains(formattedDate) )
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_fhome.value += totalofinvoices[i].Expense_Value;
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
    

    List<ExpensesModel> totalofinvoices = expenses
        .where((expense) =>
            expense.Username == Username.value &&
            expense.Expense_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].Expense_Value;
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

    List<ExpensesModel> totalofinvoices = expenses
        .where((expense) =>
            expense.Username == Username.value &&
            expense.Expense_Month == (monthNumber))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_month .value += totalofinvoices[i].Expense_Value;


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

    List<ExpensesModel> totalofinvoices = expenses
        .where((expense) =>
            expense.Username == Username.value &&
            expense.Expense_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_yday .value += totalofinvoices[i].Expense_Value;


    }
  }
  void CalTotalall() {
    total_all.value = 0;
   
    Username = sharedPreferencesController.username;


  
    List<ExpensesModel> totalofinvoices = expenses
        .where((expense) =>
            expense.Username == Username.value 
          )
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_all .value += totalofinvoices[i].Expense_Value;
      

    }
  }
  void fetch_payments() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_expenses.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          expenses.assignAll(
              data.map((item) => ExpensesModel.fromJson(item)).toList());
          isDataFetched = true;
          // Initially display the first batch of expenses
          displayedExpenses.assignAll(expenses.take(itemsPerPage));
          currentPage = 1; // Reset page count
          isLoading.value = false;

          if (expenses.isEmpty) {
            print(0);
          } else {
        //    CalTotal();
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
    if (!isFetchingMore.value && displayedExpenses.length < expenses.length) {
      isFetchingMore.value = true;
      int startIndex = currentPage * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (endIndex > expenses.length) {
        endIndex = expenses.length;
      }

      // Simulate a delay for loading more data
      await Future.delayed(Duration(seconds: 2));

      displayedExpenses.addAll(expenses.sublist(startIndex, endIndex));
      currentPage++;
      isFetchingMore.value = false;
    }
  }

  String result2 = '';

  // Future<void> PayInvDue(String Inv_id,Ammount,Old_Due,New_Due,Cus_id,String Date) async {
  //   try {
  //     Username = sharedPreferencesController.username;
  //     formattedDate = dateController.getFormattedDate();
  //     formattedTime = dateController.getFormattedTime();
  //     String domain = domainModel.domain;

  //     String uri = '$domain' + 'insert_inv_payment.php';
  //     var res = await http.post(Uri.parse(uri), body: {
  //       "Expense_id": Inv_id,
  //       "Ammount": Ammount,
  //       "Expense_Date":formattedDate,
  //       "Payment_Time":formattedDate,
  //       "Username":Username.value,
  //       "Old_Due":Old_Due,
  //       "New_Due":New_Due,
  //       "Cus_id":Cus_id,
  //               "Invoice_Date":Date,

  //     });
  //    // print(Ty + Card_Name + Card_Cost + Card_Price);
  //     var response = json.decode(json.encode(res.body));

  //     print(response);
  //     result2 = response;
  //     if (response.toString().trim() == 'Payment inserted successfully.') {
  //       //  result = 'refresh';
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
