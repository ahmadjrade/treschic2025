// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/domain.dart';

import 'package:fixnshop_admin/model/recharge_cart_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Recharge/new_recharge_invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class RechargeCartController extends GetxController {
  RxList<RechargeCartModel> recharge_carts = <RechargeCartModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<RechargeCartModel?> SelectedRechargeCart = Rx<RechargeCartModel?>(null);
  RxList<RechargeCartModel> InvoiceCards = <RechargeCartModel>[].obs;
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;
  final CustomerController customerController = Get.find<CustomerController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController dueUsdController = TextEditingController();
  final TextEditingController duelbController = TextEditingController();

  void clearSelectedCat() {
    SelectedRechargeCart.value = null;
    recharge_carts.clear();
  }

  bool isadmin(username) {
    if (username == 'admin') {
      return true;
    } else {
      return false;
    }
  }

  int isPaid(due) {
    if (due == 0) {
      return 1;
    } else {
      return 0;
    }
  }

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetch_recharge_carts();
  }

  List<RechargeCartModel> searchcardss(String query) {
    return recharge_carts
        .where((cart) =>
            cart.Card_Name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  CustomerModel? SelectedCustomer;
  int SelectCusId = 0;
  RxDouble totalLb = 0.0.obs;
  RxDouble totalQty = 0.0.obs;
  RxDouble DueLB = 0.0.obs;
  RxDouble ReceivedLb = 0.0.obs;
  RxDouble ReceivedUSD = 0.0.obs;
  RxBool isDue = false.obs;

  void reset() {
    InvoiceCards.clear();
    SelectCusId = 0;
    totalLb.value = 0.0;
    totalQty.value = 0.0;
    DueLB.value = 0.0;
    ReceivedLb.value = 0.0;
    ReceivedUSD.value = 0.0;
    isDue.value = false;
  }

  void resetRecUsd() {
    ReceivedUSD.value = 0.0;
    calculateDueLB();
  }

  void resetRecLb() {
    ReceivedLb.value = 0.0;
    calculateDueLB();
  }

  void calculateDueLB() {
    DueLB.value = 0.0;
    DueLB.value = totalLb.value -
        (ReceivedLb.value +
            (ReceivedUSD.value * rateController.rateValue.value));
    if (DueLB.value == 0) {
      isDue.value = false;
      customerController.result3.value = '';
      customerController.result4.value = '';
      idController.text = '';
      nameController.text = '';
      numberController.text = '';
      duelbController.text = '';
    } else {
      isDue.value = true;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in InvoiceCards) {
      totalLb.value += (item.Card_Price * item.quantity.value);
      calculateDueLB();
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in InvoiceCards) {
      totalQty.value += item.quantity.value;
      calculateDueLB();
    }
  }

  void DecreaseQty(RechargeCartModel recharge) {
    recharge.quantity -= 1;
    calculateTotalLb();
    calculateTotalQty();
  }

  void IncreaseQty(RechargeCartModel recharge) {
    recharge.quantity += 1;
    calculateTotalLb();
    calculateTotalQty();
  }

  void fetchcards(String cardName) {
    RechargeCartModel? cards;
    // Username = sharedPreferencesController.username;
    // Iterate through the cardss list to find the matching cards
    for (var card in recharge_carts) {
      if (card.Card_Name == cardName) {
        cards = card;
        break;
      }
    }

    if (cards != null) {
      // Check if the cards already exists in the invoice
      if (InvoiceCards.contains(cards)) {
        cards.quantity.value += 1;
        calculateTotalLb();
        calculateTotalQty();

        print(InvoiceCards);
        // Get.snackbar('cards Qty Increased', 'Code $cardName',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: const Duration(seconds: 1));

        // Display message when the cards is already in the invoice
        // Get.snackbar(
        //     'cards Already Added', 'The cards is already in the invoice.',
        //     snackPosition: SnackPosition.BOTTOM,
        //     duration: const Duration(seconds: 2));
      } else {
        // Add the cards to the invoice
        InvoiceCards.add(cards);
        print(InvoiceCards);

        calculateTotalLb();

        calculateTotalQty();
        Get.snackbar('cards Added To Invoice', 'cards Code $cardName',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } else {
      // Display error message when cards is not found
      Get.snackbar(
          'cards Not Found', 'The cards with the provided code does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  void fetch_recharge_carts() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_recharge_carts.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          recharge_carts.assignAll(
              data.map((item) => RechargeCartModel.fromJson(item)).toList());
          //category = data.map((item) => cards_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (recharge_carts.isEmpty) {
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

  // String result2 = '';
  // Future<void> UpdatecardsQty(String P_Detail_id, String Qty) async {
  //   try {
  //     String domain = domainModel.domain;
  //     String uri = '$domain' + 'update_cards_quantity.php';

  //     var res = await http.post(Uri.parse(uri), body: {
  //       "P_Detail_id": P_Detail_id,
  //       "Qty": Qty,
  //     });

  //     var response = json.decode(json.encode(res.body));
  //     P_Detail_id = '';
  //     Qty = '';

  //     print(response);
  //     result2 = response;
  //     if (response.toString().trim() ==
  //         'cards Quantity Updated successfully.') {
  //       //  result = 'refresh';
  //     } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  String addCommasToNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  Future<void> PrintReceipt() async {
    final profile = await CapabilityProfile.load();
    final PaperSize paper = PaperSize.mm80;

    final List<int> bytes = await ReceiptDesign(paper, profile);
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
      PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    //List Name = ['123', '1234', '12345'];

    ////final ByteData data = await rootBundle.load('images/test.png');
    ///final Uint8List imageBytes = data.buffer.asUint8List();
    //final im.Image? image = im.decodeImage(imageBytes);
    // bytes += ticket.image(image!); // Add the image to the bytes list
    bytes += ticket.text('AJTECH',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += ticket.text(Username.toUpperCase() + ' Store',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ));
    //bytes += ticket.text(Store_Loc!, styles: PosStyles(align: PosAlign.center, bold:  true));

    bytes += ticket.text('+961/81214404',
        styles: PosStyles(align: PosAlign.center, bold: true));
    // bytes += ticket.text('Web: www.treschiclb.com',
    //     styles: PosStyles(align: PosAlign.center, bold:  true), linesAfter: 0);
    bytes += ticket.feed(1);
    bytes += ticket.text(
      'Recharge Invoice ID #$lastId',
      styles: PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );
    //bytes += ticket.qrcode(lastId);
    bytes += ticket.hr(
      ch: '*',
      linesAfter: 1,
    );

    // bytes += ticket.text('Invoice Type: ' + 'Store',
    //     styles: PosStyles(align: PosAlign.center, bold:  true), linesAfter: 0);
    // bytes += ticket.text('Paid In: ' + Currency,
    //     styles: PosStyles(align: PosAlign.center, bold:  true), linesAfter: 1);
    // if (Delivery_Code.text != '') {
    //   bytes += ticket.text('Delivery Code: ' + Delivery_Code.text,
    //       styles: PosStyles(align: PosAlign.center, bold:  true), linesAfter: 1);
    // }
    // if (Delivery_Code.text != '') {
    //   bytes += ticket.text(
    //       'Delivery Company Name: ' +
    //           Cus_Name +
    //           '\nDelivery Company Number: ' +
    //           Cus_Number,
    //       styles: PosStyles(align: PosAlign.center, bold:  true),
    //       linesAfter: 1);

    //   bytes += ticket.text(
    //       'Reciever Name: ' +
    //           C_Customer_Name.text +
    //           '\nReciever Company Number: ' +
    //           C_Customer_Number.text,
    //       styles: PosStyles(align: PosAlign.center, bold:  true),
    //       linesAfter: 1);

    //   bytes += ticket.text('Reciever Address: ' + Cus_address.text,
    //       styles: PosStyles(align: PosAlign.center, bold:  true), linesAfter: 1);
    // }
    if (DueLB.value != 0) {
      bytes += ticket.text(
          'Customer Name: ' +
              nameController.text +
              '\nCustomer Number: ' +
              numberController.text,
          styles: PosStyles(align: PosAlign.center, bold: true),
          linesAfter: 1);
      bytes += ticket.text(
          'UNPAID DUES: ' +
              addCommasToNumber(double.tryParse(duelbController.text)!) +
              'LL',
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
          ),
          linesAfter: 1);
    }
    bytes += ticket.text(
        'USD Rate: ' + (rateController.rateValue.value.toString()),
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0);

    // bytes += ticket.beep();
    //   bytes += ticket.image();

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: 'Qty', width: 1, styles: PosStyles(bold: true)),
      PosColumn(text: 'Item', width: 5, styles: PosStyles(bold: true)),
      PosColumn(
          text: 'Unit Price',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'Total Price',
          width: 3,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += ticket.hr(ch: '=', linesAfter: 1);

    for (int i = 0; i < InvoiceCards.length; i++) {
      print(InvoiceCards);
      if (InvoiceCards[i].Card_Price != 0) {
        bytes += ticket.row([
          PosColumn(
              text: InvoiceCards[i].quantity.toString(),
              width: 1,
              styles: PosStyles(bold: true)),
          PosColumn(
              text: InvoiceCards[i].Card_Name,
              width: 5,
              styles: PosStyles(bold: true)),
          // PosColumn(
          //     text: InvoiceCards[i]., width: 2, styles: PosStyles()),
          PosColumn(
              text: InvoiceCards[i].Card_Price.toString(),
              width: 3,
              styles: PosStyles(align: PosAlign.right, bold: true)),
          PosColumn(
              text:
                  (InvoiceCards[i].quantity.value * InvoiceCards[i].Card_Price)
                      .toString(),
              width: 3,
              styles: PosStyles(align: PosAlign.right, bold: true)),
        ]);
      }

      // bytes += ticket.row([
      //   PosColumn(
      //       text: '  ' + InvoiceCards[i].Product_Name.toString(),
      //       width: 12,
      //       styles: PosStyles(align: PosAlign.left)),
      // ]);
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
          text: addCommasToNumber(
                  totalLb.value / rateController.rateValue.value) +
              ' USD',
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
          text:
              addCommasToNumber(DueLB.value / rateController.rateValue.value) +
                  ' USD',
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
              bold: true,
              width: PosTextSize.size1)),
    ]);
    bytes += ticket.hr(ch: '=', linesAfter: 1);
    if (DueLB.value != 0) {
      bytes += ticket.row([
        PosColumn(
            text: 'New Due',
            width: 6,
            styles: PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                bold: true)),
        PosColumn(
            text: addCommasToNumber(
                    DueLB.value + double.tryParse(duelbController.text)!) +
                ' LL',
            width: 6,
            styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                bold: true,
                width: PosTextSize.size1)),
      ]);
    }

    bytes += ticket.hr(ch: '=', linesAfter: 1);

    bytes += ticket.feed(2);
    bytes += ticket.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center, bold: true), linesAfter: 2);

    // bytes += ticket.text('Invoice #' + last_id.toString(),
    //     styles: PosStyles(align: PosAlign.center, bold:  true), linesAfter: 1);

    // bytes += ticket.qrcode(last_id.toString());
    bytes += ticket.feed(1);
    bytes += ticket.cut();

    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';
  String lastId = '';

  Future<void> uploadInvoiceToDatabase() async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      // Prepare invoice data
      List<Map<String, dynamic>> invoiceData = [];

      for (RechargeCartModel product in InvoiceCards) {
        invoiceData.add({
          'Store_id': Username.value,
          'Card_id': product.Card_id,
          'Card_Name': product.Card_Name,
          'Card_Qty': product.quantity.value,
          'Card_UP': product.Card_Price,
          'Card_TP': (product.quantity.value * product.Card_Price),
          'Card_Amount': (product.Card_Amount.toString()),
        });
      }

      // Send invoice data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain/insert_rech_invoice.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Invoice_Store': Username.value,
          'item_count': totalQty.value,
          'Invoice_Total_Usd': (totalLb.value / rateController.rateValue.value),
          'Invoice_Total_Lb': totalLb.value,
          'Invoice_Rec_Usd': ReceivedUSD.value,
          'Invoice_Rec_Lb': ReceivedLb.value,
          'Invoice_Due_USD': DueLB.value / rateController.rateValue.value,
          'Invoice_Due_LB': DueLB.value,
          'Cus_id': idController.text,
          'Cus_Name': nameController.text,
          'Cus_Number': numberController.text,
          'Invoice_Date': formattedDate,
          'Invoice_Time': formattedTime,
          'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
          'Invoice_Rate': rateController.rateValue.value,

          'invoiceItems': invoiceData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          // Data successfully sent to the API
          lastId = responseData['lastId'].toString();
          print('Data sent successfully. Last Inserted ID: $lastId');
          result = 'Invoice Sent Successfully';

          // Continue with the rest of the logic if needed
        } else {
          // Handle the error returned by the PHP script
          print('Error: ${responseData['message']}');
          result = 'Invoice Sending Failed: ${responseData['message']}';
        }
      } else {
        // Error occurred while sending the data
        print('Error sending data. StatusCode: ${response.statusCode}');
        result = 'Invoice Sending Failed';
      }
    } catch (error) {
      // Exception occurred while sending the data
      print('Exception: $error');
      result = 'Exception: $error';
    }
  }
}
