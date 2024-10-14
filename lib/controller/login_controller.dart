// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/rate_model.dart';
import 'package:fixnshop_admin/model/supplier_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  bool isDataFetched = false;
  String result = '';
  RxInt rateValue = 0.obs;
  RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
  }

  String token = '',
      role = '',
      Store_Number = '',
      Store_Name = '',
      Store_Location = '';
  Future<void> loginUser(String username, String password) async {
    String domain = domainModel.domain;
    String uri = '$domain/login.php';

    try {
      result = '';
      final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          role = jsonData['role']; // Retrieve the user role
          Store_Name = jsonData['s_name'];
          Store_Number = jsonData['s_num'];
          Store_Location = jsonData['s_loc'];
          token =
              jsonData['token']; // Assuming the token is returned as 'token'
          result = 'success';
          // Save the token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('role', role); // Store the role securely
          await prefs.setString('token', token); // Store the token securely
          print(token);
          print(role);
          print(Store_Location);
          print(Store_Name);
          print(Store_Number);

          print('Login successful, token saved');
        } else {
          print('Login failed: ${jsonData['message']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  String result2 = '';

  Future<void> logoutUser() async {
    String domain = domainModel.domain;
    String uri = '$domain/logout.php';
    result2 = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Send a logout request to invalidate the token
    final response = await http.post(
      Uri.parse(uri),
      body: jsonEncode({
        'token': token, // Send the token for invalidation
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      result2 = 'success';
      // Clear token and role after a successful server-side logout
      await prefs.remove('token');
      await prefs.remove('role');
      print('User logged out, token and role cleared');
    } else {
      print('Logout failed with status: ${response.statusCode}');
    }
  }
}
