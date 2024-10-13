// controllers/item_controller.dart
// ignore_for_file: unused_import

import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/stores_model.dart';
import 'package:fixnshop_admin/model/supplier_model.dart';
import 'package:fixnshop_admin/model/user_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersControllers extends GetxController {
  RxList<UserModel> users = <UserModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchusers();
  }

  List<UserModel> searchUsers(String query) {
    return users
        .where(
            (user) => user.Username.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void closeLoading() {}

  Future<void> UploadUser(
      String Username, String Password, String Role, String Store_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_user.php';
      var res = await http.post(Uri.parse(uri), body: {
        "Username": Username,
        "Password": Password,
        "Role": Role,
        "Store_id": Store_id,
      });

      var response = json.decode(json.encode(res.body));
      Role = '';
      Username = '';

      Password = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'User inserted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'User already exists.') {}
    } catch (e) {
      print(e);
    }
  }

  String result2 = '';
  Future<void> DeleteUser(String U_id) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'delete_user.php';

      var res = await http.post(Uri.parse(uri), body: {
        "U_id": U_id,
      });

      var response = json.decode(json.encode(res.body));
      U_id = '';

      print(response);
      result2 = response;
      if (response.toString().trim() == 'User Deleted successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }

  void fetchusers() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_users.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          users
              .assignAll(data.map((item) => UserModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (users.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            print('supp');
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
}
