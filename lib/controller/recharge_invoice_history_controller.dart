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
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RechargeInvoiceHistoryController extends GetxController {
  RxList<InvoiceModel> recharge_invoices = <InvoiceModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<InvoiceModel?> SelectedRechargeInvoice = Rx<InvoiceModel?>(null);
  RxString Store = 'this'.obs;
  RxString Sold = 'Yes'.obs;
  RxString Condition = 'New'.obs;
  RxBool iseditable = false.obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;

  //RxString show = 'Yes'.obs;
  void clearSelectedCat() {
    SelectedRechargeInvoice.value = null;
    recharge_invoices.clear();
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
    fetchrechargeInvoice();
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  List<InvoiceModel> searchPhones(String query) {
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

    return recharge_invoices
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
  List<InvoiceModel> SearchDuePurchases(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return recharge_invoices
        .where((recharge) =>
            (recharge.Invoice_id.toString()).contains(query.toLowerCase()) &&
                recharge.Username == Username.value &&
                recharge.Invoice_Due_USD != 0 ||
            recharge.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
                 recharge.Username == Username.value &&
                recharge.Invoice_Due_USD != 0 || 
            recharge.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
                 recharge.Username == Username.value &&
                recharge.Invoice_Due_USD != 0)
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

    List<InvoiceModel> totalofinvoices = recharge_invoices
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].Invoice_Total_Usd;
      totalrec.value += totalofinvoices[i].Invoice_Rec_Usd;
      totaldue.value += totalofinvoices[i].Invoice_Due_USD;
    }
  }

  void fetchrechargeInvoice() async {
    Username = sharedPreferencesController.username;

    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' 'fetch_recharge_invoices.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          recharge_invoices.assignAll(
              data.map((item) => InvoiceModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (recharge_invoices.isEmpty) {
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
  Future<void> PayInvDue(String RInv_id,Ammount) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      String domain = domainModel.domain;

      String uri = '$domain' + 'insert_rech_payment.php';
      var res = await http.post(Uri.parse(uri), body: {
        "RInvoice_id": RInv_id,
        "Ammount": Ammount,
        "Payment_Date":formattedDate,
        "Payment_Time":formattedDate,
        "Username":Username.value,
      

        
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
