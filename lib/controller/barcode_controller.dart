import 'package:fixnshop_admin/controller/bulk_phone_purchase_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class BarcodeController extends GetxController {
  RxString barcode = ''.obs;
  RxString barcode2 = ''.obs;
  RxString barcode3 = ''.obs;
  RxString barcode4 = ''.obs;
  RxString purchase_phone_barcode = ''.obs;

  final InvoiceController invoiceController = Get.put(InvoiceController());
  final ProductController productController = Get.find<ProductController>();
  final BulkPhonePurchaseController bulkPhonePurchaseController = Get.put(BulkPhonePurchaseController());

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
    Future<void> scanBarcodePhonePurchase(item) async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      purchase_phone_barcode.value = result.rawContent;
      if(purchase_phone_barcode.value != '') {
          if(purchase_phone_barcode.value.length ==15 ) {
                    bulkPhonePurchaseController.UpdatePhoneImei(item, purchase_phone_barcode.value);
                    purchase_phone_barcode.value == '';

          } else {
                    Get.snackbar('Error', 'IMEI MUST HAVE 15 NUMBERS');

          }
      } else {
        Get.snackbar('Error', 'Couldn\'t Read IMEI');
      }
      //productController.products.refresh();

//invoiceController.fetchProduct(barcode2.value);
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }
  
}
