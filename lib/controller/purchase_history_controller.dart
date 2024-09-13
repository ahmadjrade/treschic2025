// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/invoice_model.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/purchase_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseHistoryController extends GetxController {
  RxList<PurchaseModel> pruchases = <PurchaseModel>[].obs;
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

  //RxString show = 'Yes'.obs;
  void clearSelectedCat() {
    SelectedPurchase.value = null;
    pruchases.clear();
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
    // print(formattedDate);
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;
    // formattedDate = dateController.getFormattedDate();
    //   formattedTime = dateController.getFormattedTime();

    return pruchases
        .where((pruchase) =>
            (pruchase.Purchase_id.toString()).contains(query.toLowerCase()) &&
                pruchase.Username == Username.value ||
            pruchase.Supplier_Name!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                pruchase.Username == Username.value ||
            pruchase.Supplier_Number!
                    .toLowerCase()
                    .contains(query.toLowerCase()) &&
                pruchase.Username == Username.value)
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

    return pruchases
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
  RxDouble totalrec = 0.0.obs;
  RxDouble totaldue = 0.0.obs;

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

    List<PurchaseModel> totalofinvoices = pruchases
        .where((pruchase) => pruchase.Username == Username.value)
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].Purchase_Total_USD;
      totalrec.value += totalofinvoices[i].Purchase_Rec_USD;
      totaldue.value += totalofinvoices[i].Purchase_Due_USD;
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
          pruchases.assignAll(
              data.map((item) => PurchaseModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (pruchases.isEmpty) {
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
