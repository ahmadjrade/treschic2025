// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:fixnshop_admin/model/repair_product_detail_model.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class RepairController extends GetxController {
  final RepairProductDetailController repairProductDetailController =
      Get.find<RepairProductDetailController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;
  RxList<RepairProductDetailModel> repairItems =
      <RepairProductDetailModel>[].obs;
  RxDouble totalUsd = 0.0.obs;
  RxDouble totalLb = 0.0.obs;
  RxDouble Repair_due = 0.0.obs;
  RxDouble totalQty = 0.0.obs;
  RxDouble ReceivedUSD = 0.0.obs;
  RxDouble ReceivedLb = 0.0.obs;
  RxDouble ReturnUSD = 0.0.obs;
  RxDouble ReturnLB = 0.0.obs;
  RxDouble DueUSD = 0.0.obs;
  RxDouble DueLB = 0.0.obs;

  String Inv_type(isDel) {
    String type = '';
    if (isDel == '1') {
      return type = 'Delivery';
    } else {
      return type = 'Store';
    }
  }

  void reset() {
    DueLB.value = 0;
    DueUSD.value = 0;
    ReceivedUSD.value = 0;
    ReceivedLb.value = 0;
    calculateDueUSD();
    calculateDueLB();

    ReturnLB.value = 0;
    ReturnUSD.value = 0;
    Repair_due.value = 0;
    totalLb.value = 0;
    totalUsd.value = 0;
    totalQty.value = 0;

    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();

    for (int i = 0; i < repairItems.length; i++) {
      repairItems[i].quantity.value = 1;
    }
    repairItems.clear();
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
    for (var item in repairItems) {
      totalUsd.value += item.R_product_price * item.quantity.value;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in repairItems) {
      totalLb.value += (item.R_product_price * item.quantity.value) *
          rateController.rateValue.value;
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in repairItems) {
      totalQty.value += item.quantity.value;
    }
  }

  void updateItemPrice(RepairProductDetailModel item, double newPrice) {
    item.R_product_price = newPrice;
    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();
    calculateDueUSD();
    calculateDueLB();
  }

  void UpdateQty(RepairProductDetailModel product, qty) {
    if (qty > product.R_product_quantity) {
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

  void IncreaseQty(RepairProductDetailModel product) {
    product.quantity += 1;
    calculateTotalLb();
    calculateDueUSD();
    calculateDueLB();
    calculateTotal();
    calculateTotalQty();
  }

  void DecreaseQty(RepairProductDetailModel product) {
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
    RepairProductDetailModel? product =
        _findProductDetail(productCodeController);

    if (product != null) {
      _addProductToRepair(product);
    } else {
      Get.snackbar('Product Not Found',
          'The product with the provided code does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  RepairProductDetailModel? _findProductDetail(String productCode) {
    Username.value = sharedPreferencesController.username.value;
    for (var prod in repairProductDetailController.repair_product_detail) {
      if (prod.Repair_p_code == productCode &&
          prod.Username == Username.value) {
        return prod;
      }
    }
    return null;
  }

  void _addProductToRepair(RepairProductDetailModel product) {
    if (repairItems.contains(product)) {
      if (product.quantity.value == product.R_product_quantity) {
        Get.snackbar('Product Already Added', 'Max Quantity Reached.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        product.quantity.value += 1;
        recalculateAll();
      }
    } else if (product.R_product_quantity == 0) {
      Get.snackbar('Product Addition Failed', 'No More Quantity.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } else {
      repairItems.add(product);
      recalculateAll();
      Get.snackbar(
          'Product Added To Repair', 'Product Code ${product.Repair_p_code}',
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

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  Future<void> PrintReceipt() async {
    final profile = await CapabilityProfile.load();
    final PaperSize paper = PaperSize.mm80;

    final List<int> bytes = await ReceiptDesign(
      paper,
      profile,
    );

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
  ) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    
    bytes += ticket.text('AJTECH',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += ticket.text(Username.toUpperCase() + ' Store',
        styles: PosStyles(align: PosAlign.center, bold: true));
    //bytes += ticket.text(Store_Loc!, styles: PosStyles(align: PosAlign.center));

    bytes += ticket.text('+961/81214404',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += ticket.feed(1);

    bytes += ticket.text(
      'Repair ID #$lastId',
      styles: PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );
    //bytes += ticket.qrcode(lastd);
    bytes += ticket.hr(ch: '*', linesAfter: 1);
    bytes += ticket.text('Repair Type: ' + 'Store',
        styles: PosStyles(align: PosAlign.center, bold: true), linesAfter: 0);
    // bytes += ticket.text('Paid In: ' + Currency,
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    // if (Delivery_Code.text != '') {
    //   bytes += ticket.text('Delivery Code: ' + Delivery_Code.text,
    //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    // }
    // if (Delivery_Code.text != '') {
    //   bytes += ticket.text(
    //       'Delivery Company Name: ' +
    //           Cus_Name +
    //           '\nDelivery Company Number: ' +
    //           Cus_Number,
    //       styles: PosStyles(align: PosAlign.center),
    //       linesAfter: 1);

    //   bytes += ticket.text(
    //       'Reciever Name: ' +
    //           C_Customer_Name.text +
    //           '\nReciever Company Number: ' +
    //           C_Customer_Number.text,
    //       styles: PosStyles(align: PosAlign.center),
    //       linesAfter: 1);

    //   bytes += ticket.text('Reciever Address: ' + Cus_address.text,
    //       styles: PosStyles(align: PosAlign.center), linesAfter: 1);
    // }
    // if (Delivery_Code.text == '') {
    //   bytes += ticket.text(
    //       'Customer Name: ' + Cus_Name + '\nCustomer Number: ' + Cus_Number,
    //       styles: PosStyles(align: PosAlign.center),
    //       linesAfter: 1);
    // }

    bytes += ticket.text(
        'USD Rate: ' + (rateController.rateValue.value.toString()),
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0);

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

    for (int i = 0; i < repairItems.length; i++) {
      print(repairItems);
      bytes += ticket.row([
        PosColumn(
            text: repairItems[i].quantity.toString(),
            width: 1,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: repairItems[i].Repair_p_code,
            width: 5,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: repairItems[i].Color,
            width: 2,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: repairItems[i].R_product_price.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
            text:
                (repairItems[i].quantity.value * repairItems[i].R_product_price)
                    .toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: '  ' + repairItems[i].Repair_p_name.toString(),
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
          text: addCommasToNumber(totalUsd.value) + ' USD',
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
          text: addCommasToNumber(totalLb.value) + ' LL',
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
          text: addCommasToNumber(ReceivedUSD.value) + ' USD',
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
          text: addCommasToNumber(ReceivedLb.value) + ' LL',
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
          text: addCommasToNumber(DueUSD.value) + ' USD',
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
          text: addCommasToNumber(DueLB.value) + ' LL',
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

    // bytes += ticket.text('Repair #' + last_id.toString(),
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    // bytes += ticket.qrcode(last_id.toString());
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

  String lastId = '';
  Future<void> uploadRepairToDatabase(String Rep_id) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();

      // Prepare Repair data
      List<Map<String, dynamic>> RepairData = [];

      for (RepairProductDetailModel product in repairItems) {
        RepairData.add({
          'Repair_id': Rep_id,
          'Store_id': product.Product_Store,
          'R_product_id': product.R_product_id,
          'Repair_p_name': product.Repair_p_name,
          'Product_Qty': product.quantity.value,
          'Product_UP': product.R_product_price,
          'Product_TP': (product.quantity.value * product.R_product_price),
          'Repair_p_code': product.Repair_p_code,
          'Color': product.Color,
          'Product_Cost': product.R_product_cost,
        });
      }

      // Send Repair data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain/insert_repair_details.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'repairItems': RepairData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response on success
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          print('Data sent successfully. Last Inserted ID: $lastId');
          result = 'Repair Sent Successfully';
        } else {
          print('Error: ${responseData['message']}');
          result = 'Repair Sending Failed: ${responseData['message']}';
        }
      } else {
        // Handle the error response from the server (e.g., 400 Bad Request)
        Map<String, dynamic> errorData = jsonDecode(response.body);
        print('Error: ${errorData['message']}');
        result = 'Repair Sending Failed: ${errorData['message']}';
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      print('Exception: $error');
      result = 'Exception: $error';
    }
  }

  // Future<void> uploadOldRepairToDatabase(String Inv_id) async {
  //   try {
  //     Username = sharedPreferencesController.username;
  //     formattedDate = dateController.getFormattedDate();
  //     formattedTime = dateController.getFormattedTime();
  //     // Prepare Repair data
  //     List<Map<String, dynamic>> RepairData = [];

  //     for (RepairProductDetailModel product in repairItems) {
  //       RepairData.add({
  //         'Repair_id': Inv_id,
  //         'Store_id': product.Product_Store,
  //         'R_product_id': product.R_product_id,
  //         'Repair_p_name': product.Repair_p_name,
  //         'Product_Qty': product.quantity.value,
  //         'Product_UP': product.R_product_price,
  //         'Product_TP': (product.quantity.value * product.R_product_price),
  //         'Repair_p_code': product.Repair_p_code,
  //         'Color': product.Color,
  //       });
  //     }

  //     // Send Repair data to PHP script
  //     String domain = domainModel.domain;
  //     String uri = '$domain' 'insert_in_oldRepair.php';
  //     final response = await http.post(
  //       Uri.parse(uri),
  //       body: jsonEncode({
  //         'Inv_id': Inv_id,
  //         'item_count': totalQty.value,
  //         'Repair_Total_USD': totalUsd.value,
  //         'Repair_Total_Lb': totalLb.value,
  //         'Repair_Rec_Usd': ReceivedUSD.value,
  //         'Repair_Rec_Lb': ReceivedLb.value,
  //         'Repair_Due_USD': DueLB.value / rateController.rateValue.value,
  //         'Repair_Due_LB': DueLB.value,
  //         'Repair_Date': formattedDate,
  //         'Repair_Time': formattedTime,
  //         'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
  //         'repairItems': RepairData,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       // Data successfully sent to the API
  //       print('Data sent successfully');
  //       result = 'Repair Sent Successfully';

  //       // Continue with the rest of the logic if needed
  //     } else {
  //       // Error occurred while sending the data
  //       print('Error sending data. StatusCode: ${response.statusCode}');
  //       result = 'Repair Sending Failed';
  //     }
  //   } catch (error) {
  //     // Exception occurred while sending the data
  //     print('Exception: $error');
  //   }
  // }
}
