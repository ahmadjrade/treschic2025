import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/transfer_controller.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class BarcodeController extends GetxController {
  RxString barcode = ''.obs;
  RxString barcode2 = ''.obs;
  RxString barcode3 = ''.obs;
  RxString barcode4 = ''.obs;
  RxString purchase_phone_barcode = ''.obs;
  RxString transfer_item_barcode = ''.obs;
  final TransferController transferController = Get.put(TransferController());

  final InvoiceController invoiceController = Get.put(InvoiceController());
  final ProductController productController = Get.find<ProductController>();
  


  Future<void> scanBarcode() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      barcode.value = result.rawContent;
      //invoiceController.fetchProduct(barcode.value);
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  Future<void> scanBarcodeInv() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      barcode2.value = result.rawContent;
      invoiceController.fetchProduct(barcode2.value);
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  Future<void> scanBarcodeTransfer() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      transfer_item_barcode.value = result.rawContent;
      transferController.fetchProduct(transfer_item_barcode.value);
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  Future<void> scanBarcodeSearch() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      barcode3.value = result.rawContent;

      //productController.products.refresh();

//invoiceController.fetchProduct(barcode2.value);
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  Future<void> scanBarcodePhone() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      barcode4.value = result.rawContent;

      //productController.products.refresh();

//invoiceController.fetchProduct(barcode2.value);
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  
}
