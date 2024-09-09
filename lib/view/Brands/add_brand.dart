// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:dotted_line/dotted_line.dart';
import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/model/brand_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/insert_brand_controller.dart';

class AddBrand extends StatelessWidget {
  AddBrand({super.key});

  final InsertBrandController insertbrandController =
      Get.put(InsertBrandController());
  final BrandController brandController = Get.find<BrandController>();

  TextEditingController Brand_Name = TextEditingController();

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
            Text('Brands'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                brandController.isDataFetched = false;
                brandController.fetchbrands();
                //  supplierController.isDataFetched = false;
                // supplierController.fetchsuppliers();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              maxLength: 50,
              keyboardType: TextInputType.name,
              controller: Brand_Name,
              decoration: InputDecoration(
                labelText: "Brand Name ",
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GetBuilder<InsertBrandController>(
                builder: (insertbrandController) {
              return OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 50),
                    backgroundColor: Colors.blue.shade900,
                    side: BorderSide(
                        width: 2.0, color: Colors.blue.shade900),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    if (Brand_Name.text != '') {
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
                      insertbrandController.UploadBrand(Brand_Name.text)
                          .then((value) => Brand_Name.clear())
                          .then(
                              (value) => brandController.isDataFetched = false)
                          .then((value) => brandController.fetchbrands())
                          .then((value) =>
                              showToast(insertbrandController.result))
                          .then((value) => Navigator.of(context).pop());
                    } else {
                      showToast('Please add Brand Name');
                    }
                  },
                  child: Text(
                    'Insert Brand',
                    style: TextStyle(color: Colors.white),
                  ));
            }),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 2.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGradient: [Colors.black, Colors.black],
              dashRadius: 1.0,
              dashGapLength: 1.0,
              dashGapColor: Colors.transparent,
              dashGapGradient: [Colors.white, Colors.white],
              dashGapRadius: 1.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                      iconDisabledColor: Colors.blue.shade900,
                      iconEnabledColor: Colors.blue.shade900,
                      //  value: categoryController.category.first,
                      onChanged: (BrandModel? value) {
                        //SelectedCategory = value;
                        //SelectCatId = (SelectedCategory?.Cat_id).toString();
                        //print(SelectCatId);
                      },
                      items: brandController.brands
                          .map((brand) => DropdownMenuItem<BrandModel>(
                                value: brand,
                                child: Text(brand.Brand_Name),
                              ))
                          .toList(),
                    ),
            ),
          ),
        ]),
      ),
    );
  }
}
