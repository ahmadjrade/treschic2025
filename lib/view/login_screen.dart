// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, avoid_print

import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  //double screenWidth = MediaQuery.of(context).size.width;
  //double screenHeight = MediaQuery.of(context).size.height;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    usernameController.text = 'hara';
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
                      side: BorderSide(
                          width: 2.0, color: Colors.blue.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      if (usernameController.text.trim() == 'hara' &&
                          passwordController.text.trim() == '123') {
                        sharedPreferencesController
                            .setUsername(usernameController.text);
                        Get.toNamed('HomeScreenManage');
                      } else if (usernameController.text.trim() == 'beirut' &&
                          passwordController.text.trim() == '123') {
                        sharedPreferencesController
                            .setUsername(usernameController.text);
                        Get.toNamed('HomeScreenManage');
                      } else if (usernameController.text.trim() == 'admin' &&
                          passwordController.text.trim() == '123') {
                        sharedPreferencesController
                            .setUsername(usernameController.text);
                        Get.toNamed('HomeScreenManage');
                      } else {
                        print('Error');
                      }
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
