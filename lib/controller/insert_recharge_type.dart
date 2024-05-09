import 'dart:convert';
import 'dart:io';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertRechargeType extends GetxController {
  DomainModel domainModel = DomainModel();
  String result = '';
  
  Future<void> uploadType(String Type_name, File imageFile) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_recharge_type.php';
      
      // Create a multipart request for uploading both text and image data
      var request = http.MultipartRequest('POST', Uri.parse(uri));
      
      // Add category name as a field in the request
      request.fields['Type_Name'] = Type_name;
      
      // Add image file to the request
      request.files.add(http.MultipartFile('image', imageFile.readAsBytes().asStream(), imageFile.lengthSync(), filename: '$Type_name.png'));
      
      // Send the request
      var res = await request.send();
      
      // Get response from the server
      var response = await res.stream.bytesToString();
      
      // Decode the response JSON
      var responseData = json.decode(response);
      
      // Clear the category name field
      Type_name = '';
      
      // Print the response
      print(responseData);
      
      // Store the response message
      result = responseData.toString();
      
      if (result.trim() == 'Type inserted successfully.') {
        // Category inserted successfully, perform necessary actions
      } else if (result.trim() == 'Type already exists.') {
        // Category already exists, handle accordingly
      }
    } catch (e) {
      print(e);
    }
  }
}
