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
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/phone_model.dart';
import 'package:fixnshop_admin/model/product_detail_model.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class InvoiceController extends GetxController {
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  final PhoneController phoneController = Get.find<PhoneController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;
  RxList<ProductDetailModel> invoiceItems = <ProductDetailModel>[].obs;
  RxDouble totalUsd = 0.0.obs;
  RxDouble totalLb = 0.0.obs;
  RxDouble invoice_due = 0.0.obs;
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
    invoice_due.value = 0;
    totalLb.value = 0;
    totalUsd.value = 0;
    totalQty.value = 0;

    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();

    for (int i = 0; i < invoiceItems.length; i++) {
      invoiceItems[i].quantity.value = 1;
    }
    invoiceItems.clear();
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
    for (var item in invoiceItems) {
      totalUsd.value += item.product_MPrice * item.quantity.value;
    }
  }

  void calculateTotalLb() {
    totalLb.value = 0.0;
    for (var item in invoiceItems) {
      totalLb.value += (item.product_MPrice * item.quantity.value) *
          rateController.rateValue.value;
    }
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in invoiceItems) {
      totalQty.value += item.quantity.value;
    }
  }

  void updateItemPrice(ProductDetailModel item, double newPrice) {
    item.product_MPrice = newPrice;
    calculateTotal();
    calculateTotalLb();
    calculateTotalQty();
    calculateDueUSD();
    calculateDueLB();
  }

  void UpdateQty(ProductDetailModel product, qty) {
    if (qty > product.Product_Quantity) {
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

  void IncreaseQty(ProductDetailModel product) {
    product.quantity += 1;
    calculateTotalLb();
    calculateDueUSD();
    calculateDueLB();
    calculateTotal();
    calculateTotalQty();
  }

  void DecreaseQty(ProductDetailModel product) {
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
    ProductDetailModel? product = _findProductDetail(productCodeController);
    PhoneModel? phone = _findPhone(productCodeController);

    if (product != null) {
      _addProductToInvoice(product);
    } else if (phone != null) {
      _addPhoneToInvoice(phone);
    } else {
      Get.snackbar('Product Not Found',
          'The product with the provided code does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  ProductDetailModel? _findProductDetail(String productCode) {
    Username.value = sharedPreferencesController.username.value;
    for (var prod in productDetailController.product_detail) {
      if (prod.Product_Code == productCode && prod.Username == Username.value) {
        return prod;
      }
    }
    return null;
  }

  PhoneModel? _findPhone(String productCode) {
    Username.value = sharedPreferencesController.username.value;
    for (var phone in phoneController.phones) {
      if (phone.Phone_IMEI == productCode &&
          phone.Username.toLowerCase() == Username.value.toLowerCase() &&
          phone.isSold == 0) {
        // Assuming productCode matches Phone_IMEI for PhoneModel
        return phone;
      }
    }
    return null;
  }

  void _addProductToInvoice(ProductDetailModel product) {
    if (invoiceItems.contains(product)) {
      if (product.quantity.value == product.Product_Quantity) {
        Get.snackbar('Product Already Added', 'Max Quantity Reached.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        product.quantity.value += 1;
        recalculateAll();
      }
    } else if (product.Product_Quantity == 0) {
      Get.snackbar('Product Addition Failed', 'No More Quantity.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } else {
      invoiceItems.add(product);
      recalculateAll();
      Get.snackbar(
          'Product Added To Invoice', 'Product Code ${product.Product_Code}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  void _addPhoneToInvoice(PhoneModel phone) {
    if (invoiceItems.any((item) => item.Product_Code == phone.Phone_IMEI)) {
      var existingItem = invoiceItems
          .firstWhere((item) => item.Product_Code == phone.Phone_IMEI);
      if (existingItem.quantity.value == existingItem.Product_Quantity) {
        Get.snackbar('Product Already Added', 'Max Quantity Reached.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        existingItem.quantity.value += 1;
        recalculateAll();
      }
    } else {
      invoiceItems.add(ProductDetailModel(
          PD_id: 0,
          Product_id: phone.Phone_id,
          Product_Name: phone.Phone_Name,
          Product_Code: phone.Phone_IMEI,
          Product_Color: phone.Color,
          Product_Quantity: 1,
          Product_Max_Quantity: 1,
          Product_Sold_Quantity: 1,
          Product_Transfered_Qty: 1,
          Product_LPrice: 0,
          Product_MPrice: double.tryParse(phone.Sell_Price.toString())!,
          Product_Cost: double.tryParse(phone.Phone_Price.toString())!,
          Product_Store: phone.Username,
          Username: phone.Username,
          quantity: 1.obs,
          isPhone: 1)); // Assuming quantity is represented by Sell_Price
      recalculateAll();
      Get.snackbar('Phone Added To Invoice', 'Product Code ${phone.Phone_IMEI}',
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

  Future<void> PrintReceipt(Cus_Name, Cus_Number, Cus_Due) async {
    final profile = await CapabilityProfile.load();
    final PaperSize paper = PaperSize.mm80;

    final List<int> bytes =
        await ReceiptDesign(paper, profile, Cus_Name, Cus_Number, Cus_Due);
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

  Future<List<int>> ReceiptDesign(PaperSize paper, CapabilityProfile profile,
      Cus_Name, Cus_Number, Cus_Due) async {
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
        styles: PosStyles(align: PosAlign.center, bold: true));
    //bytes += ticket.text(Store_Loc!, styles: PosStyles(align: PosAlign.center));

    bytes += ticket.text('+961/81214404',
        styles: PosStyles(align: PosAlign.center, bold: true));
    // bytes += ticket.text('Web: www.treschiclb.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 0);
    bytes += ticket.feed(1);
    bytes += ticket.text(
      'Invoice ID #$lastId',
      styles: PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );
    //bytes += ticket.qrcode(lastId);
    bytes += ticket.hr(ch: '*', linesAfter: 1);
    bytes += ticket.text('Invoice Type: ' + 'Store',
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
    if (Cus_Number != '000000') {
      bytes += ticket.text(
          'Customer Name: ' + Cus_Name + '\nCustomer Number: ' + Cus_Number,
          styles: PosStyles(align: PosAlign.center, bold: true),
          linesAfter: 1);
      bytes += ticket.text(
          'UNPAID DUES: ' + addCommasToNumber(double.tryParse(Cus_Due)!) + '\$',
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

    for (int i = 0; i < invoiceItems.length; i++) {
      print(invoiceItems);
      bytes += ticket.row([
        PosColumn(
            text: invoiceItems[i].quantity.toString(),
            width: 1,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: invoiceItems[i].Product_Code,
            width: 5,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: invoiceItems[i].Product_Color,
            width: 2,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: invoiceItems[i].product_MPrice.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
            text: (invoiceItems[i].quantity.value *
                    invoiceItems[i].product_MPrice)
                .toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: '  ' + invoiceItems[i].Product_Name.toString(),
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
    bytes += ticket.row([
      PosColumn(
          text: 'New Due',
          width: 6,
          styles: PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true)),
      PosColumn(
          text: addCommasToNumber(DueUSD.value + double.tryParse(Cus_Due)!) +
              ' USD',
          width: 6,
          styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              bold: true,
              width: PosTextSize.size1)),
    ]);
    bytes += ticket.hr(ch: '=', linesAfter: 1);
    bytes += ticket.feed(2);
    bytes += ticket.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));
    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    // bytes += ticket.text('Invoice #' + last_id.toString(),
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
  Future<void> uploadInvoiceToDatabase(
      String Cus_id,
      String Cus_Name,
      String Cus_Number,
      String Driver_id,
      String Driver_Name,
      String Driver_Number,
      String isDel,
      String Delivery_Code) async {
    try {
      print(Driver_id + Driver_Name + Driver_Number + isDel);
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();

      // Prepare invoice data
      List<Map<String, dynamic>> invoiceData = [];

      for (ProductDetailModel product in invoiceItems) {
        invoiceData.add({
          'Store_id': product.Product_Store,
          'Product_id': product.Product_id,
          'Product_Name': product.Product_Name,
          'Product_Qty': product.quantity.value,
          'Product_UP': product.product_MPrice,
          'Product_TP': (product.quantity.value * product.product_MPrice),
          'Product_Code': product.Product_Code,
          'Product_Color': product.Product_Color,
          'Product_Cost': product.product_Cost,
          'isPhone': product.isPhone
        });
      }

      // Send invoice data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain/insert_invoice.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Invoice_Store': Username.value,
          'item_count': totalQty.value,
          'Invoice_Total_USD': totalUsd.value,
          'Invoice_Total_Lb': totalLb.value,
          'Invoice_Rec_Usd': ReceivedUSD.value,
          'Invoice_Rec_Lb': ReceivedLb.value,
          'Invoice_Due_USD': DueLB.value / rateController.rateValue.value,
          'Invoice_Due_LB': DueLB.value,
          'Cus_id': Cus_id,
          'Cus_Name': Cus_Name,
          'Cus_Number': Cus_Number,
          'Invoice_Date': formattedDate,
          'Invoice_Time': formattedTime,
          'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
          'Invoice_Type': Inv_type(isDel),
          'Driver_id': Driver_id,
          'Invoice_Rate': rateController.rateValue.value,
          'Driver_Name': Driver_Name,
          'Driver_Number': Driver_Number,
          'isDelivery': isDel,
          'Delivery_Code': Delivery_Code,
          'invoiceItems': invoiceData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response on success
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          lastId = responseData['lastId'].toString();
          print('Data sent successfully. Last Inserted ID: $lastId');
          result = 'Invoice Sent Successfully';
        } else {
          print('Error: ${responseData['message']}');
          result = 'Invoice Sending Failed: ${responseData['message']}';
        }
      } else {
        // Handle the error response from the server (e.g., 400 Bad Request)
        Map<String, dynamic> errorData = jsonDecode(response.body);
        print('Error: ${errorData['message']}');
        result = 'Invoice Sending Failed: ${errorData['message']}';
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      print('Exception: $error');
      result = 'Exception: $error';
    }
  }

  Future<void> uploadOldInvoiceToDatabase(String Inv_id) async {
    try {
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();
      // Prepare invoice data
      List<Map<String, dynamic>> invoiceData = [];

      for (ProductDetailModel product in invoiceItems) {
        invoiceData.add({
          'Invoice_id': Inv_id,
          'Store_id': product.Product_Store,
          'Product_id': product.Product_id,
          'Product_Name': product.Product_Name,
          'Product_Qty': product.quantity.value,
          'Product_UP': product.product_MPrice,
          'Product_TP': (product.quantity.value * product.product_MPrice),
          'Product_Code': product.Product_Code,
          'Product_Color': product.Product_Color,
        });
      }

      // Send invoice data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain' 'insert_in_oldinvoice.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Inv_id': Inv_id,
          'item_count': totalQty.value,
          'Invoice_Total_USD': totalUsd.value,
          'Invoice_Total_Lb': totalLb.value,
          'Invoice_Rec_Usd': ReceivedUSD.value,
          'Invoice_Rec_Lb': ReceivedLb.value,
          'Invoice_Due_USD': DueLB.value / rateController.rateValue.value,
          'Invoice_Due_LB': DueLB.value,
          'Invoice_Date': formattedDate,
          'Invoice_Time': formattedTime,
          'isPaid': isPaid(DueLB.value / rateController.rateValue.value),
          'invoiceItems': invoiceData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Data successfully sent to the API
        print('Data sent successfully');
        result = 'Invoice Sent Successfully';

        // Continue with the rest of the logic if needed
      } else {
        // Error occurred while sending the data
        print('Error sending data. StatusCode: ${response.statusCode}');
        result = 'Invoice Sending Failed';
      }
    } catch (error) {
      // Exception occurred while sending the data
      print('Exception: $error');
    }
  }
}
