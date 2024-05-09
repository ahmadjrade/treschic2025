import 'dart:convert';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:http/http.dart' as http;

class InsertInovice {
  DomainModel domainModel = DomainModel();

  Future<bool> uploadInvoiceToDatabase(Map<String, dynamic> invoiceData) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' 'insert_invoice.php';
      String jsonData = json.encode(invoiceData);
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        return true;
      } else {
        print('Failed to upload data. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while uploading data: $e');
      return false;
    }
  }
}
