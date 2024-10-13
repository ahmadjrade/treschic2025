// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/stores_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/stores_model.dart';
import 'package:fixnshop_admin/view/Transfer/new_transfer.dart';
import 'package:fixnshop_admin/view/add_store.dart';
import 'package:fixnshop_admin/view/store_users.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoresListFTransfer extends StatelessWidget {
  StoresListFTransfer({super.key});

  final StoresController storesController = Get.find<StoresController>();
  TextEditingController Store_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            'Select Store to Transfer items',
            style: TextStyle(fontSize: 15),
          )),
          Row(
            children: [
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  Get.to(() => AddStore());
                },
                icon: Icon(CupertinoIcons.add),
              ),
              IconButton(
                color: Colors.deepPurple,
                iconSize: 24.0,
                onPressed: () {
                  storesController.isDataFetched = false;
                  storesController.fetchstores();
                },
                icon: Icon(CupertinoIcons.refresh),
              ),
            ],
          ),
        ],
      )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: Store_Name,
              onChanged: (query) {
                storesController.stores.refresh();
              },
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                final List<StoresModel> filteredCategories =
                    storesController.searchStores(Store_Name.text);
                if (storesController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final StoresModel store = filteredCategories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // IconButton(
                                    //   onPressed: () {
                                    //     showDialog(
                                    //         // The user CANNOT close this dialog  by pressing outsite it
                                    //         barrierDismissible: false,
                                    //         context: context,
                                    //         builder: (_) {
                                    //           return Dialog(
                                    //             // The background color
                                    //             backgroundColor: Colors.white,
                                    //             child: Padding(
                                    //               padding: const EdgeInsets
                                    //                   .symmetric(vertical: 20),
                                    //               child: Column(
                                    //                 mainAxisSize:
                                    //                     MainAxisSize.min,
                                    //                 children: [
                                    //                   // The loading indicator
                                    //                   CircularProgressIndicator(),
                                    //                   SizedBox(
                                    //                     height: 15,
                                    //                   ),
                                    //                   // Some text
                                    //                   Text('Loading')
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           );
                                    //         });
                                    //     storesController.DeleteStore(
                                    //             store.Store_id.toString())
                                    //         .then((value) =>
                                    //             Navigator.of(context).pop())
                                    //         .then((value) => storesController
                                    //             .isDataFetched = false)
                                    //         .then((value) =>
                                    //             storesController.fetchstores())
                                    //         .then((value) => showToast(
                                    //             storesController.result2));
                                    //   },
                                    //   icon: Icon(
                                    //     Icons.delete,
                                    //     color: Colors.red,
                                    //   ),
                                    // ),
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '#' +
                                              store.Store_id.toString() +
                                              ' ' +
                                              store.Store_Name +
                                              ' | ' +
                                              store.Store_Number,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(store.Store_Loc),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      Get.to(NewTransfer(
                                          Store_id: store.Store_id.toString(),
                                          Store_Name: store.Store_Name));
                                    },
                                    child: Text('Select'))
                              ],
                            ),
                          ),

                          // Add more properties as needed
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
