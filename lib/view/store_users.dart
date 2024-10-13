// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, must_be_immutable, unused_import

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/controller/users_controller.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/sub_category_model.dart';
import 'package:fixnshop_admin/model/user_model.dart';
import 'package:fixnshop_admin/view/Product/add_product_detail.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/add_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreUsers extends StatelessWidget {
  String Store_id, Store_Name;

  StoreUsers({super.key, required this.Store_id, required this.Store_Name});

  final UsersControllers usersControllers = Get.find<UsersControllers>();
  TextEditingController Username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    List<UserModel> filteredUsers(String query) {
      return usersControllers.users
          .where((user) =>
              user.store_id == int.tryParse(Store_id) &&
              user.Username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              'Users of $Store_Name ',
              style: TextStyle(fontSize: 15),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: Colors.deepPurple,
                  iconSize: 24.0,
                  onPressed: () {
                    Get.to(() => AddUser(
                          Store_id: Store_id,
                          Store_Name: Store_Name,
                        ));
                    // Get.toNamed('/BuyAccessories');
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
                IconButton(
                  color: Colors.deepPurple,
                  iconSize: 24.0,
                  onPressed: () {
                    usersControllers.isDataFetched = false;
                    usersControllers.fetchusers();
                  },
                  icon: Icon(CupertinoIcons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: Username,
              onChanged: (query) {
                usersControllers.users.refresh();
              },
              decoration: InputDecoration(
                labelText: 'Search by Username',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                final List<UserModel> filteredUser =
                    filteredUsers(Username.text);
                if (usersControllers.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (usersControllers.users.isEmpty) {
                  return Center(
                    child: Text('No User Found!'),
                  );
                } else {
                  if (filteredUser.isEmpty) {
                    return Center(
                      child: Text('No User Found !'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: filteredUser.length,
                      itemBuilder: (context, index) {
                        final UserModel user = filteredUser[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  IconButton(
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
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                      usersControllers.DeleteUser(
                                              user.User_id.toString())
                                          .then((value) =>
                                              Navigator.of(context).pop())
                                          .then((value) => usersControllers
                                              .isDataFetched = false)
                                          .then((value) =>
                                              usersControllers.fetchusers())
                                          .then((value) => showToast(
                                              usersControllers.result2));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Username : ' + user.Username,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          'Role : ' + user.Role,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                ],
                              ),
                            ),

                            // trailing: OutlinedButton(
                            //   onPressed: () {
                            //     // Handle selection
                            //     // Get.to(() => AddProductDetail(
                            //     //       Product_id: user.Product_id.toString(),
                            //     //       Username: user.Username,
                            //     //       Product_Code: user.Product_Code,
                            //     //       Product_LPrice:
                            //     //           user.Product_LPrice.toString(),
                            //     //       Product_MPrice:
                            //     //           user.product_MPrice.toString(),
                            //     //     ));
                            //   },
                            //   child: Text('Select'),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
