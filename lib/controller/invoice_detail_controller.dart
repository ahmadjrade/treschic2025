// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/datetime_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/invoice_history_model.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class InvoiceDetailController extends GetxController {
  RxList<InvoiceHistoryModel> invoice_detail = <InvoiceHistoryModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<InvoiceHistoryModel?> SelectedInvoiceDetail =
      Rx<InvoiceHistoryModel?>(null);
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  void clearSelectedCat() {
    SelectedInvoiceDetail.value = null;
    invoice_detail.clear();
  }

  RxBool iseditable = false.obs;

  RxString Username = ''.obs;
  RxInt itemsToShow = 20.obs;

  final int itemsPerPage = 20; // Number of items to load per page
  int currentPage = 1;
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
    fetchinvoicesdetails();
  }

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  Future<void> PrintReceipt(Cus_Name, Cus_Number, Cus_Due, inv_id, rate,
      total_usd, total_lb, rec_usd, rec_lb, due_usd, due_lb, items) async {
    final profile = await CapabilityProfile.load();
    final PaperSize paper = PaperSize.mm80;

    final List<int> bytes = await ReceiptDesign(
        paper,
        profile,
        Cus_Name,
        Cus_Number,
        Cus_Due,
        inv_id,
        rate,
        total_usd,
        total_lb,
        rec_usd,
        rec_lb,
        due_usd,
        due_lb,
        items);
    if (bluetoothController!.isConnected &&
        bluetoothController!.connection != null) {
      try {
        bluetoothController!.connection!.output.add(Uint8List.fromList(bytes));
        await bluetoothController!.connection!.output.allSent;
      } catch (e) {
        print('Error printing: $e');
      }
    } else {
      print('Error: Not connected to a Bluetooth device');
    }
  }

  Future<List<int>> ReceiptDesign(
      PaperSize paper,
      CapabilityProfile profile,
      Cus_Name,
      Cus_Number,
      Cus_Due,
      inv_id,
      rate,
      total_usd,
      total_lb,
      rec_usd,
      rec_lb,
      due_usd,
      due_lb,
      items) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    //List Name = ['123', '1234', '12345'];

    ////final ByteData data = await rootBundle.load('images/test.png');
    ///final Uint8List imageBytes = data.buffer.asUint8List();
    //final im.Image? image = im.decodeImage(imageBytes);
    // bytes += ticket.image(image!); // Add the image to the bytes list
    bytes += ticket.text('Treschic Boutique',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += ticket.text(
        sharedPreferencesController.storeName.toUpperCase() + ' Store',
        styles: PosStyles(align: PosAlign.center, bold: true));
    //bytes += ticket.text(Store_Loc!, styles: PosStyles(align: PosAlign.center));

    bytes += ticket.text('+961/${sharedPreferencesController.storeNumber}',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += ticket.text('${sharedPreferencesController.location}',
        styles: PosStyles(align: PosAlign.center, bold: true));
    // bytes += ticket.text('Web: www.treschiclb.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 0);
    bytes += ticket.feed(1);
    bytes += ticket.text(
      'Invoice ID #$inv_id',
      styles: PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );
    //bytes += ticket.qrcode(lastId);
    bytes += ticket.hr(ch: '*', linesAfter: 1);
    bytes += ticket.text('Invoice Type: ' + 'Store',
        styles: PosStyles(align: PosAlign.center, bold: true), linesAfter: 0);

    if (Cus_Number != '000000') {
      bytes += ticket.text(
          'Customer Name: ' + Cus_Name + '\nCustomer Number: ' + Cus_Number,
          styles: PosStyles(align: PosAlign.center, bold: true),
          linesAfter: 1);
      // bytes += ticket.text(
      //     'UNPAID DUES: ' + addCommasToNumber(double.tryParse(Cus_Due)!) + '\$',
      //     styles: PosStyles(
      //       align: PosAlign.center,
      //       bold: true,
      //     ),
      //     linesAfter: 1);
    }
    bytes += ticket.text('USD Rate: ' + (rate),
        styles: PosStyles(align: PosAlign.center, bold: true), linesAfter: 0);

    // bytes += ticket.beep();
    //   bytes += ticket.image();

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(
          text: 'Qty',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Color',
          width: 2,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'UP',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'TP',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += ticket.hr(ch: '=', linesAfter: 1);

    for (int i = 0; i < items.length; i++) {
      final item = items[i]; // Access individual item
      bytes += ticket.row([
        PosColumn(
            text: item.Product_Quantity.toString(), // Use item instead of items
            width: 1,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: item.Product_Code, width: 5, styles: PosStyles(bold: true)),
        PosColumn(
            text: item.Product_Color, width: 2, styles: PosStyles(bold: true)),
        PosColumn(
            text: item.product_UP.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
            text: item.product_TP.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: '  ' + item.Product_Name.toString(),
            width: 12,
            styles: PosStyles(align: PosAlign.left, bold: true)),
      ]);
      bytes += ticket.hr(ch: ' ', linesAfter: 0);
    }
    bytes += ticket.hr(ch: '=', linesAfter: 1);

    bytes += ticket.row([
      PosColumn(
          text: 'TOTAL USD',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(double.tryParse(total_usd)!) + ' USD',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);

    bytes += ticket.row([
      PosColumn(
          text: 'TOTAL LL',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(double.tryParse(total_lb)!) + ' LL',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);

    bytes += ticket.row([
      PosColumn(
          text: 'Received Usd',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(double.tryParse(rec_usd)!) + ' USD',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Received LL',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(double.tryParse(rec_lb)!) + ' LL',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);

    bytes += ticket.row([
      PosColumn(
          text: 'Due Usd',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(double.tryParse(due_usd)!) + ' USD',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.row([
      PosColumn(
          text: 'Due LL',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(double.tryParse(due_lb)!) + ' LL',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true)),
    ]);
    bytes += ticket.hr(ch: '=', linesAfter: 1);

    bytes += ticket.hr(ch: '=', linesAfter: 1);
    bytes += ticket.feed(2);
    bytes += ticket.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    bytes += ticket.feed(1);
    bytes += ticket.cut();

    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  List<InvoiceHistoryModel> SearchInvoices(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoice_detail
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Product_Name.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Product_Code.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Invoice_Detail_id.toString()
                    .contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate))
        .toList();
  }

  List<InvoiceHistoryModel> SearchInvoicesYesterday(String query) {
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

    return invoice_detail
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Product_Name.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Product_Code.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate) ||
            invoice.Invoice_Detail_id.toString()
                    .contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Date.contains(formattedDate))
        .toList();
  }

  List<InvoiceHistoryModel> SearchInvoicesAll(String query) {
    String dateString = dateController.getFormattedDate();
    List<String> dateParts = dateString.split('-');
    String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
    String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
    String formattedDate = '${dateParts[0]}-$month-$day';
    formattedTime = dateController.getFormattedTime();
    Username = sharedPreferencesController.username;

    return invoice_detail
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Product_Name.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Product_Code.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value ||
            invoice.Invoice_Detail_id.toString()
                    .contains(query.toLowerCase()) &&
                invoice.Username == Username.value)
        .toList();
  }

  List<InvoiceHistoryModel> SearchInvoicesMonth(String query) {
    DateTime now = DateTime.now(); // Get today's date
    int getMonthNumber(DateTime date) {
      return date.month;
    }

    int monthNumber = getMonthNumber(now);

    Username = sharedPreferencesController.username;

    return invoice_detail
        .where((invoice) =>
            (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber) ||
            invoice.Product_Name.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber) ||
            invoice.Product_Code.toLowerCase().contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber) ||
            invoice.Invoice_Detail_id.toString()
                    .contains(query.toLowerCase()) &&
                invoice.Username == Username.value &&
                invoice.Invoice_Month == (monthNumber))
        .toList();
  }

  // List<InvoiceHistoryModel> SearchDueInvoices(String query) {
  //   String dateString = dateController.getFormattedDate();
  //   List<String> dateParts = dateString.split('-');
  //   String month = dateParts[1].length == 1 ? '0${dateParts[1]}' : dateParts[1];
  //   String day = dateParts[2].length == 1 ? '0${dateParts[2]}' : dateParts[2];
  //   String formattedDate = '${dateParts[0]}-$month-$day';
  //   formattedTime = dateController.getFormattedTime();
  //   Username = sharedPreferencesController.username;

  //   return invoice_detail
  //       .where((invoice) =>
  //           (invoice.Invoice_id.toString()).contains(query.toLowerCase()) &&
  //               invoice.Username == Username.value &&
  //               invoice.Invoice_Due_USD != 0 ||
  //           invoice.Cus_Name!.toLowerCase().contains(query.toLowerCase()) &&
  //                invoice.Username == Username.value &&
  //               invoice.Invoice_Due_USD != 0 ||
  //           invoice.Cus_Number!.toLowerCase().contains(query.toLowerCase()) &&
  //                invoice.Username == Username.value &&
  //               invoice.Invoice_Due_USD != 0)
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

    List<InvoiceHistoryModel> totalofinvoices = invoice_detail
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate) &&
            !invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_fhome.value += totalofinvoices[i].product_TP;
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

    List<InvoiceHistoryModel> totalofinvoices = invoice_detail
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total.value += totalofinvoices[i].product_TP;
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

    List<InvoiceHistoryModel> totalofinvoices = invoice_detail
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Month == (monthNumber))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_month.value += totalofinvoices[i].product_TP;
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

    List<InvoiceHistoryModel> totalofinvoices = invoice_detail
        .where((invoice) =>
            invoice.Username == Username.value &&
            invoice.Invoice_Date.contains(formattedDate))
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_yday.value += totalofinvoices[i].product_TP;
    }
  }

  void CalTotalall() {
    total_all.value = 0;

    Username = sharedPreferencesController.username;

    List<InvoiceHistoryModel> totalofinvoices = invoice_detail
        .where((invoice) => invoice.Username == Username.value)
        .toList();
    for (int i = 0; i < totalofinvoices.length; i++) {
      total_all.value += totalofinvoices[i].product_TP;
    }
  }

  void fetchinvoicesdetails() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_inv_detail.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          invoice_detail.assignAll(
              data.map((item) => InvoiceHistoryModel.fromJson(item)).toList());
          //category = data.map((item) => invoice_details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (invoice_detail.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
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
  Future<void> DeleteInvItem(String I_Detail_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'delete_inv_item.php';

      var res = await http.post(Uri.parse(uri), body: {
        "I_Detail_id": I_Detail_id,
      });

      var response = json.decode(json.encode(res.body));
      I_Detail_id = '';

      print(response);
      result2 = response;
      if (response.toString().trim() ==
          'Product Quantity Updated successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
