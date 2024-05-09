// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/controller/insert_brand_controller.dart';
import 'package:fixnshop_admin/controller/insert_phone_model_controller.dart';
import 'package:fixnshop_admin/controller/insert_supplier_controller.dart';
import 'package:fixnshop_admin/model/brand_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneModelAdd extends StatelessWidget {
  PhoneModelAdd({super.key});

  final InsertPhoneModelController insertPhoneModelController =
      Get.put(InsertPhoneModelController());
    final BrandController brandController = Get.find<BrandController>();

  TextEditingController Phone_Name = TextEditingController();
BrandModel? SelectedBrand;
  String SelectBrandId = '';
  //String Supplier_Number = '';
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('New Phone Model'),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 50,
          ),     
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal : 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => brandController.brands.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      // Text('Fetching Rate! Please Wait'),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                )
                              : DropdownButtonFormField<BrandModel>(
                                  decoration: InputDecoration(
                                    labelText: "Brands",
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
                                  iconDisabledColor: Colors.deepPurple.shade300,
                                  iconEnabledColor: Colors.deepPurple.shade300,
                                  //  value: categoryController.category.first,
                                  onChanged: (BrandModel? value) {
                                    SelectedBrand = value;
                                    SelectBrandId = (SelectedBrand?.Brand_id).toString();
                                    print(SelectBrandId);
                                  },
                                  items: brandController.brands
                                      .map((brand) => DropdownMenuItem<BrandModel>(
                                            value: brand,
                                            child: Text(brand.Brand_Name),
                                          ))
                                      .toList(),
                                ),
                        ),
                      ),Padding(
                        padding: const EdgeInsets.fromLTRB(20,0,10,0),
                        child: IconButton(
                          color: Colors.black,
                          iconSize: 24.0,
                          icon: Icon(CupertinoIcons.add),
                          onPressed: () {
                            //customerController.searchCustomer(numberController);
                            Get.toNamed('/NewBrand');
                          },
                        ),
                      ),
                    ],
                  ),
                ),SizedBox(
                  height: 20,
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
             
              maxLength: 50,
              keyboardType: TextInputType.name,
              controller: Phone_Name,
              decoration: InputDecoration(
                labelText: "Phone Name ",
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
          
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GetBuilder<InsertPhoneModelController>(
                builder: (insertPhoneModelController) {
              return  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.deepPurple.shade300,
                      side: BorderSide(
                          width: 2.0, color: Colors.deepPurple.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  onPressed: () {
                    if (Phone_Name != '') {
                      if (SelectBrandId != '') {
                         
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
                          insertPhoneModelController.UploadPhoneModel(
                                  SelectBrandId, Phone_Name.text).then((value) => Phone_Name.clear())
                              .then((value) => Navigator.of(context).pop())
                              .then((value) =>
                                  showToast(insertPhoneModelController.result));
                        
                      } else {
                        showToast('Please add Customer Name');
                      }
                    }
                  },
                  child: Text(
                    'Insert Phone Model',
                    style: TextStyle(color: Colors.white),
                  ));
            }),
          ),
        ]),
      ),
    );
  }
}
