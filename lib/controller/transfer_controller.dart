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

class TransferController extends GetxController {
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  final PhoneController phoneController = Get.find<PhoneController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  final RateController rateController = Get.find<RateController>();
  RxString Username = ''.obs;
  RxList<ProductDetailModel> TransferItems = <ProductDetailModel>[].obs;

  RxDouble totalQty = 0.0.obs;

  void reset() {
    for (int i = 0; i < TransferItems.length; i++) {
      TransferItems[i].quantity.value = 1;
    }
    TransferItems.clear();
  }

  void calculateTotalQty() {
    totalQty.value = 0.0;
    for (var item in TransferItems) {
      totalQty.value += item.quantity.value;
    }
  }

  void UpdateQty(ProductDetailModel product, qty) {
    if (qty > product.Product_Quantity) {
      Get.snackbar('Error', 'This Quantity is not available');
    } else {
      product.quantity.value = qty;

      calculateTotalQty();
    }
  }

  void IncreaseQty(ProductDetailModel product) {
    product.quantity += 1;

    calculateTotalQty();
  }

  void DecreaseQty(ProductDetailModel product) {
    if (product.quantity.value == 1) {
      Get.snackbar('Error', 'Product Quantity Can\'t Be Zero.');
    } else {
      product.quantity -= 1;

      calculateTotalQty();
    }
  }

  void recalculateAll() {
    calculateTotalQty();
  }

  void fetchProduct(String productCodeController) {
    ProductDetailModel? product = _findProductDetail(productCodeController);
    PhoneModel? phone = _findPhone(productCodeController);

    if (product != null) {
      _addProductToTransfer(product);
    } else if (phone != null) {
      _addPhoneToTransfer(phone);
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
      if (phone.IMEI == productCode &&
          phone.Username.toLowerCase() == Username.value.toLowerCase() &&
          phone.isSold == 0) {
        // Assuming productCode matches IMEI for PhoneModel
        return phone;
      }
    }
    return null;
  }

  void _addProductToTransfer(ProductDetailModel product) {
    if (TransferItems.contains(product)) {
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
      TransferItems.add(product);
      recalculateAll();
      Get.snackbar(
          'Product Added To Transfer', 'Product Code ${product.Product_Code}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
  }

  void _addPhoneToTransfer(PhoneModel phone) {
    if (TransferItems.any((item) => item.Product_Code == phone.IMEI)) {
      var existingItem =
          TransferItems.firstWhere((item) => item.Product_Code == phone.IMEI);
      if (existingItem.quantity.value == existingItem.Product_Quantity) {
        Get.snackbar('Product Already Added', 'Max Quantity Reached.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        existingItem.quantity.value += 1;
        recalculateAll();
      }
    } else {
      TransferItems.add(ProductDetailModel(
          PD_id: 0,
          Product_id: phone.Phone_id,
          Product_Name: phone.Phone_Name,
          Product_Code: phone.IMEI,
          Product_Color: phone.Color,
          Product_Quantity: 1,
          Product_Max_Quantity: 1,
          Product_Sold_Quantity: 1,
          Product_Transfered_Qty: 1,
          Product_LPrice: 0,
          Product_MPrice: double.tryParse(phone.Sell_Price.toString())!,
          Product_Cost: double.tryParse(phone.Price.toString())!,
          Product_Store: phone.Username,
          Username: phone.Username,
          quantity: 1.obs,
          isPhone: 1)); // Assuming quantity is represented by Sell_Price
      recalculateAll();
      Get.snackbar('Phone Added To Transfer', 'Product Code ${phone.IMEI}',
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
      'Transfer ID #$lastId',
      styles: PosStyles(align: PosAlign.center, bold: true),
      linesAfter: 1,
    );
    //bytes += ticket.qrcode(lastId);
    bytes += ticket.hr(ch: '*', linesAfter: 1);
    bytes += ticket.text('Transfer Type: ' + 'Store',
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

    for (int i = 0; i < TransferItems.length; i++) {
      print(TransferItems);
      bytes += ticket.row([
        PosColumn(
            text: TransferItems[i].quantity.toString(),
            width: 1,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: TransferItems[i].Product_Code,
            width: 5,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: TransferItems[i].Product_Color,
            width: 2,
            styles: PosStyles(bold: true)),
        PosColumn(
            text: TransferItems[i].product_MPrice.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
            text: (TransferItems[i].quantity.value *
                    TransferItems[i].product_MPrice)
                .toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right, bold: true)),
      ]);
      bytes += ticket.row([
        PosColumn(
            text: '  ' + TransferItems[i].Product_Name.toString(),
            width: 12,
            styles: PosStyles(align: PosAlign.left, bold: true)),
      ]);
      bytes += ticket.hr(ch: ' ', linesAfter: 0);
    }

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

    // bytes += ticket.text('Transfer #' + last_id.toString(),
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
  Future<void> uploadTransferToDatabase(
    String Store_id,
  ) async {
    try {
      // print(Driver_id + Driver_Name + Driver_Number + isDel);
      Username = sharedPreferencesController.username;
      formattedDate = dateController.getFormattedDate();
      formattedTime = dateController.getFormattedTime();

      // Prepare Transfer data
      List<Map<String, dynamic>> TransferData = [];

      for (ProductDetailModel product in TransferItems) {
        TransferData.add({
          'Product_id': product.Product_id,
          'Product_Detail_id': product.PD_id,
          'Product_Name': product.Product_Name,
          'Product_Qty': product.quantity.value,
          'Product_Code': product.Product_Code,
          'Product_Color': product.Product_Color,
          'from_store': Username.value,
          'to_store': Store_id,
          'isPhone': product.isPhone
        });
      }

      // Send Transfer data to PHP script
      String domain = domainModel.domain;
      String uri = '$domain/insert_transfer.php';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'Transfer_FStore': Username.value,
          'Transfer_TStore': Store_id,
          'item_Count': totalQty.value,
          'Transfer_Date': formattedDate,
          'Transfer_Time': formattedTime,
          'TransferItems': TransferData,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response on success
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          lastId = responseData['lastId'].toString();
          print('Data sent successfully. Last Inserted ID: $lastId');
          result = 'Transfer Sent Successfully';
        } else {
          print('Error: ${responseData['message']}');
          result = 'Transfer Sending Failed: ${responseData['message']}';
        }
      } else {
        // Handle the error response from the server (e.g., 400 Bad Request)
        Map<String, dynamic> errorData = jsonDecode(response.body);
        print('Error: ${errorData['message']}');
        result = 'Transfer Sending Failed: ${errorData['message']}';
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      print('Exception: $error');
      result = 'Exception: $error';
    }
  }

  // Future<void> uploadOldTransferToDatabase(String Inv_id) async {
  //   try {
  //     Username = sharedPreferencesController.username;
  //     formattedDate = dateController.getFormattedDate();
  //     formattedTime = dateController.getFormattedTime();
  //     // Prepare Transfer data
  //     List<Map<String, dynamic>> TransferData = [];

  //     for (ProductDetailModel product in TransferItems) {
  //       TransferData.add({
  //         'Transfer_id': Inv_id,
  //         'Store_id': product.Product_Store,
  //         'Product_id': product.Product_id,
  //         'Product_Name': product.Product_Name,
  //         'Product_Qty': product.quantity.value,
  //         'Product_UP': product.product_MPrice,
  //         'Product_TP': (product.quantity.value * product.product_MPrice),
  //         'Product_Code': product.Product_Code,
  //         'Product_Color': product.Product_Color,
  //       });
  //     }

  //     // Send Transfer data to PHP script
  //     String domain = domainModel.domain;
  //     String uri = '$domain' 'insert_in_oldTransfer.php';
  //     final response = await http.post(
  //       Uri.parse(uri),
  //       body: jsonEncode({
  //         'Inv_id': Inv_id,
  //         'item_count': totalQty.value,

  //         'Transfer_Date': formattedDate,
  //         'Transfer_Time': formattedTime,
  //         'TransferItems': TransferData,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       // Data successfully sent to the API
  //       print('Data sent successfully');
  //       result = 'Transfer Sent Successfully';

  //       // Continue with the rest of the logic if needed
  //     } else {
  //       // Error occurred while sending the data
  //       print('Error sending data. StatusCode: ${response.statusCode}');
  //       result = 'Transfer Sending Failed';
  //     }
  //   } catch (error) {
  //     // Exception occurred while sending the data
  //     print('Exception: $error');
  //   }
  // }
}
