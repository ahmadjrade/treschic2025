// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/cart_types_model.dart';
import 'package:fixnshop_admin/view/Recharge/add_recharge_type.dart';
import 'package:fixnshop_admin/view/Recharge/recharge_carts.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class RechargeTypes extends StatelessWidget {
  RechargeTypes({super.key});
  final CartTypesController cartTypesController =
      Get.find<CartTypesController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();
  RxString Username = ''.obs;
  TextEditingController Type_Name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Username = sharedPreferencesController.username;

    // cartTypesController.fetchcarts();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Card Types'),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                IconButton(
                  color: Colors.blue.shade900,
                  //iconSize: 24.0,
                  onPressed: () {
                    Get.to(AddRechargeType());
                  },
                  icon: Icon(CupertinoIcons.add),
                ),
                IconButton(
                  color: Colors.blue.shade900,
                  // iconSize: 24.0,
                  onPressed: () {
                    cartTypesController.isDataFetched = false;
                    cartTypesController.fetch_cart_types();
                  },
                  icon: Icon(CupertinoIcons.refresh),
                ),
              ],
            ),
          ),
        ],
      )),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
              () {
                final List<CartTypeModel> filteredcarts =
                    cartTypesController.searchTypes(Type_Name.text);
                if (cartTypesController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (cartTypesController.carts.isEmpty) {
                  return Center(child: Text('No Carts Yet ! Add Some '));
                } else {
                  return ListView.builder(
                    itemCount: filteredcarts.length,
                    itemBuilder: (context, index) {
                      final CartTypeModel cart = filteredcarts[index];
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)),

                        //  width: double.infinity,
                        //   height: 150.0,
                        //color: Colors.blue.shade100,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        //     padding: EdgeInsets.all(35),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ListTile(
                            onTap: () {
                              Get.to(() => RechargeCarts(
                                    Type_id: cart.Type_id,
                                    Type_Name: cart.Type_Name,
                                  ));
                            },
                            leading:
                                cart.Type_Image == null || cart.Type_Image == ''
                                    ? SizedBox(
                                        width: 75,
                                        child: Column(
                                          children: [
                                            Text('No Image'),
                                            Icon(
                                              Icons.error,
                                            ),
                                          ],
                                        ))
                                    : CachedNetworkImage(
                                        width: 75,
                                        imageUrl: cart.Type_Image!,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cart.Type_Name
                                  // +
                                  // ' -- ' +
                                  // cart.cart_Code,
                                  ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                      //fixedSize: Size(200, 20),
                                      backgroundColor: Colors.blue.shade100,
                                      side: BorderSide(
                                        width: 2.0,
                                        color: Colors.blue.shade900,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => RechargeCarts(
                                            Type_id: cart.Type_id,
                                            Type_Name: cart.Type_Name,
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.arrow_circle_right_rounded,
                                            color: Colors.blue.shade900),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.maxFinite, 50),
                  backgroundColor: Colors.blue.shade100,
                  side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.blue.shade900),
                )),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
