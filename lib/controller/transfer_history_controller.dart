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
import 'package:fixnshop_admin/model/transfer_history_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferHistoryController extends GetxController {
  RxList<TransferHistoryModel> transfers = <TransferHistoryModel>[].obs;
  RxList<TransferHistoryModel> displayedTransfer =
      <TransferHistoryModel>[].obs; // Displayed transfers
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs; // To track loading more data
  Rx<TransferHistoryModel?> SelectedTransfer = Rx<TransferHistoryModel?>(null);
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
    SelectedTransfer.value = null;
    transfers.clear();
    displayedTransfer.clear(); // Clear displayed transfers as well
  }

  void onClose() {
    itemsToShow.value = 20;
    super.onClose();
  }

  void resetItemsToShow() {
    itemsToShow.value = 20;
  }

  void reset() {
    // total.value = 0;
    // totalrecusd.value = 0;
    // totaldue.value = 0;
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
    fetchtransfer();
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  List<TransferHistoryModel> searchTransfer(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return transfers
        .where((transfer) =>
            (transfer.Transfer_id.toString()).contains(query.toLowerCase()) &&
            transfer.Transfer_Date.contains(formattedDate) &&
            transfer.Username == Username.value)
        .toList();
  }

  List<TransferHistoryModel> searchTransferYday(String query) {
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

    return transfers
        .where((transfer) =>
            (transfer.Transfer_id.toString()).contains(query.toLowerCase()) &&
            transfer.Transfer_Date.contains(formattedDate) &&
            transfer.Username == Username.value)
        .toList();
  }

  List<TransferHistoryModel> searchTransferAll(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return transfers
        .where((transfer) =>
            (transfer.Transfer_id.toString()).contains(query.toLowerCase()) &&
            transfer.Username == Username.value)
        .toList();
  }
  // List<TransferHistoryModel> SearchInvoicesAllForCustomer(String query,cus_id) {
  //   String dateString = dateController.getFormattedDate();
  //   List<String> dateParts = dateString.split('-');
  //   String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
  //   String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
  //   String formattedDate = '${dateParts[0]}-$month-$day';
  //   formattedTime = dateController.getFormattedTime();
  //   Username = sharedPreferencesController.username;

  //   return transfers
  //       .where((transfer) =>
  //           (transfer.Transfer_id.toString()).contains(query.toLowerCase()) &&
  //               transfer.Username == Username.value && transfer.Cus_Name == cus_id  ||
  //           transfer.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
  //               transfer.Username == Username.value && transfer.Cus_Name == cus_id ||
  //           transfer.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
  //               transfer.Username == Username.value  && transfer.Cus_Name == cus_id )
  //       .toList();
  // }

  List<TransferHistoryModel> searchTransfersMonth(String query) {
    DateTime now = DateTime.now(); // Get today's date
    int getMonthNumber(DateTime date) {
      return date.month;
    }

    int monthNumber = getMonthNumber(now);

    Username = sharedPreferencesController.username;

    return transfers
        .where((transfer) =>
            (transfer.Transfer_id.toString()).contains(query.toLowerCase()) &&
            transfer.Username == Username.value &&
            transfer.month == (monthNumber))
        .toList();
  }

  // List<TransferHistoryModel> SearchDueInvoices(String query) {
  //   String dateString = dateController.getFormattedDate();
  //   List<String> dateParts = dateString.split('-');
  //   String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
  //   String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
  //   String formattedDate = '${dateParts[0]}-$month-$day';
  //   formattedTime = dateController.getFormattedTime();
  //   Username = sharedPreferencesController.username;

  //   return transfers
  //       .where((transfer) =>
  //           (transfer.Transfer_id.toString()).contains(query.toLowerCase()) &&
  //               transfer.Username == Username.value &&
  //               transfer.Invoice_Due_USD != 0 ||
  //           transfer.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
  //                transfer.Username == Username.value &&
  //               transfer.Invoice_Due_USD != 0 ||
  //           transfer.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
  //                transfer.Username == Username.value &&
  //               transfer.Invoice_Due_USD != 0)
  //       .toList();
  // }

  void fetchtransfer() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_transfers.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          transfers.assignAll(
              data.map((item) => TransferHistoryModel.fromJson(item)).toList());
          isDataFetched = true;
          // Initially display the first batch of transfers
          displayedTransfer.assignAll(transfers.take(itemsPerPage));
          currentPage = 1; // Reset page count
          isLoading.value = false;

          if (transfers.isEmpty) {
            print(0);
          } else {
            // CalTotal();
            // CalTotalMonth();
            // CalTotal_fhome();
            // CalTotalYday();
            // CalTotalall();
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
    if (!isFetchingMore.value && displayedTransfer.length < transfers.length) {
      isFetchingMore.value = true;
      int startIndex = currentPage * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (endIndex > transfers.length) {
        endIndex = transfers.length;
      }

      // Simulate a delay for loading more data
      await Future.delayed(Duration(seconds: 2));

      displayedTransfer.addAll(transfers.sublist(startIndex, endIndex));
      currentPage++;
      isFetchingMore.value = false;
    }
  }

  String result2 = '';
  // Future<void> PayInvDue(
  //     String Inv_id, Ammount, Old_Due, New_Due, Cus_id, String Date) async {
  //   try {
  //     Username = sharedPreferencesController.username;
  //     formattedDate = dateController.getFormattedDate();
  //     formattedTime = dateController.getFormattedTime();
  //     String domain = domainModel.domain;

  //     String uri = '$domain' + 'insert_inv_payment.php';
  //     var res = await http.post(Uri.parse(uri), body: {
  //       "Transfer_id": Inv_id,
  //       "Ammount": Ammount,
  //       "Payment_Date": formattedDate,
  //       "Payment_Time": formattedDate,
  //       "Username": Username.value,
  //       "Old_Due": Old_Due,
  //       "New_Due": New_Due,
  //       "Cus_id": Cus_id,
  //       "Transfer_Date": Date,
  //     });
  //     // print(Ty + Card_Name + Card_Cost + Card_Price);
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
