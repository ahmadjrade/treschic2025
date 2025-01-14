// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, avoid_print

import 'package:treschic/controller/login_controller.dart';
import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/controller/stores_controller.dart';
import 'package:treschic/controller/sub_category_controller.dart';
import 'package:treschic/controller/transfer_controller.dart';
import 'package:treschic/controller/transfer_detail_controller.dart';
import 'package:treschic/controller/transfer_history_controller.dart';
import 'package:treschic/controller/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore_for_file: prefer_const_constructors

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/brand_controller.dart';
import 'package:treschic/controller/brand_controller_phones.dart';
import 'package:treschic/controller/category_controller.dart';
import 'package:treschic/controller/color_controller.dart';
import 'package:treschic/controller/customer_address_controller.dart';
import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/controller/driver_controller.dart';
import 'package:treschic/controller/expense_category_controller.dart';
import 'package:treschic/controller/expenses_controller.dart';
import 'package:treschic/controller/imoney_controller.dart';
import 'package:treschic/controller/insert_product_detail_controller.dart';
import 'package:treschic/controller/insert_product_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/invoice_detail_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/invoice_payment_controller.dart';
import 'package:treschic/controller/login_controller.dart';
import 'package:treschic/controller/platform_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/purchase_detail_controller.dart';
import 'package:treschic/controller/purchase_history_controller.dart';
import 'package:treschic/controller/purchase_payment_controller.dart';
import 'package:treschic/controller/rate_controller.dart';

import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/controller/supplier_controller.dart';
import 'package:treschic/view/Brands/add_brand.dart';
import 'package:treschic/view/Category/add_category.dart';
import 'package:treschic/view/Colors/add_color.dart';
import 'package:treschic/view/Customers/add_customer.dart';
import 'package:treschic/view/Category/category_list.dart';
import 'package:treschic/view/Suppliers/add_supplier.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:treschic/view/Expenses/buy_expenses.dart';
import 'package:treschic/view/buy_tools.dart';
import 'package:treschic/view/home_screen_manage.dart';
import 'package:treschic/view/login_screen.dart';
import 'package:treschic/view/Product/product_list.dart';
import 'package:treschic/view/Suppliers/supplier_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.find<LoginController>();
  //double screenWidth = MediaQuery.of(context).size.width;
  //double screenHeight = MediaQuery.of(context).size.height;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sharedPreferencesController = Get.put(SharedPreferencesController());

    Get.putAsync<SharedPreferencesController>(
        () async => SharedPreferencesController());
    final sharedPreferenecesController =
        Get.find<SharedPreferencesController>();
    sharedPreferenecesController.loadUsernameFromSharedPreferences();

    bool checkResponse(String result) {
      print(result);
      if (result == 'success') {
        return true;
      } else {
        return false;
      }
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    Future<void> Close() async {
      Navigator.of(context).pop();
      showToast('Login Failed');
    }

    Future<void> Navigate(token, number, name, loc, role) async {
      Navigator.of(context).pop();
      showToast('Login Success');
      sharedPreferencesController.setUsername(usernameController.text);
      sharedPreferencesController.setSession(token); // Save the session
      sharedPreferencesController.setStoreNumber(number); // Save store number
      sharedPreferencesController.setLocation(loc); // Save location
      sharedPreferencesController.setStoreName(name); // Save store name
      sharedPreferencesController.setUserRole(role); // Save user role

      Get.toNamed('HomeScreenManage');
    }

    usernameController.text = 'sfeir';
    passwordController.text = '123';
    return Scaffold(
      appBar: AppBar(title: Text('FixNShop')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //SizedBox(height: 50,)
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          //  readOnly: isLoading,
                          controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                          ),
                        ),
                      ))),

              SizedBox(height: 25),

              //Password Field
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          obscureText: true,
                          //  readOnly: isLoading,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
                        ),
                      ))),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.blue.shade100,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          // The user CANNOT close this dialog  by pressing outsite it
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return Dialog(
                              // The background color
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // The loading indicator
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // Some text
                                    Text('Loading')
                                  ],
                                ),
                              ),
                            );
                          });
                      loginController
                          .loginUser(
                              usernameController.text, passwordController.text)
                          .then((value) => checkResponse(loginController.result)
                              ? Navigate(
                                  loginController.token,
                                  loginController.Store_Number,
                                  loginController.Store_Name,
                                  loginController.Store_Location,
                                  loginController.role)
                              : Close());
                      // if (usernameController.text.trim() == 'hara' &&
                      //     passwordController.text.trim() == '123') {
                      //   sharedPreferencesController
                      //       .setUsername(usernameController.text);
                      //   Get.toNamed('HomeScreenManage');
                      // } else if (usernameController.text.trim() == 'beirut' &&
                      //     passwordController.text.trim() == '123') {
                      //   sharedPreferencesController
                      //       .setUsername(usernameController.text);
                      //   Get.toNamed('HomeScreenManage');
                      // } else if (usernameController.text.trim() == 'admin' &&
                      //     passwordController.text.trim() == '123') {
                      //   sharedPreferencesController
                      //       .setUsername(usernameController.text);
                      //   Get.toNamed('HomeScreenManage');
                      // } else {
                      //   print('Error');
                      // }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.blue.shade900),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
