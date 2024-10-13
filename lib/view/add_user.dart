// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/insert_customer_controller.dart';
import 'package:fixnshop_admin/controller/stores_controller.dart';
import 'package:fixnshop_admin/controller/users_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUser extends StatefulWidget {
  String Store_id, Store_Name;
  AddUser({super.key, required this.Store_id, required this.Store_Name});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final UsersControllers usersControllers = Get.find<UsersControllers>();

  List<String> roles = [
    'User',
    'Admin',
  ];
  int SelectedCapacityIndex = 0;
  String SelectedCapacity = '';

  TextEditingController Username = TextEditingController();

  TextEditingController Password = TextEditingController();

  String loadingtext = 'Loading';

  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Add User for ${widget.Store_Name} Store'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                // customerController.isDataFetched = false;
                // customerController.fetchcustomers();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: Username,
                decoration: InputDecoration(
                  labelText: "Username ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: Password,
                decoration: InputDecoration(
                  labelText: "Password ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Role",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
                iconDisabledColor: Colors.blue.shade100,
                iconEnabledColor: Colors.blue.shade100,
                // value: SelectedCapacityIndex,
                onChanged: (newIndex) {
                  setState(() {
                    SelectedCapacity = roles[newIndex];
                    SelectedCapacityIndex = newIndex;
                    print(SelectedCapacity);
                    //  selectedMonthIndex = newIndex!;
                    //  SelectMonth = newIndex + 1;
                  });
                },
                items: roles.asMap().entries.map<DropdownMenuItem>(
                  (entry) {
                    int index = entry.key;
                    String monthName = entry.value;
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      if (Username.text != '') {
                        if (Password.text != '') {
                          if (SelectedCapacity != '') {
                            showDialog(
                                // The user CANNOT close this dialog  by pressing outsite it
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    // The background color
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
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
                            usersControllers.UploadUser(
                                    Username.text,
                                    Password.text,
                                    SelectedCapacity,
                                    widget.Store_id)
                                .then((value) => Navigator.of(context).pop())
                                .then((value) =>
                                    usersControllers.isDataFetched = false)
                                .then((value) => usersControllers.fetchusers())
                                .then((value) =>
                                    showToast(usersControllers.result))
                                .then((value) => Navigator.of(context).pop());
                          } else {
                            showToast('Please Select Role');
                          }
                        } else {
                          showToast('Please Enter Password');
                        }
                      } else {
                        showToast('Please Enter Username');
                      }
                    },
                    child: Text(
                      'Insert User',
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ))),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ]),
    );
  }
}
