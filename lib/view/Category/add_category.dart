// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:dotted_line/dotted_line.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/sub_category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controller/category_controller.dart';
import '../../controller/insert_category_controller.dart';
import '../../controller/insert_sub_category_controller.dart';
import '../../model/category_model.dart';

class AddCategory extends StatelessWidget {
  AddCategory({super.key});

  final InsertCategoryController insertcategoryController =
      Get.put(InsertCategoryController());
  final InsertSubCategoryController insertsubcategoryController =
      Get.put(InsertSubCategoryController());

  final CategoryController categoryController = Get.find<CategoryController>();
  final SubCategoryController subcategoryController =
      Get.find<SubCategoryController>();

  String Category_Name = '';
  String SCategory_Name = '';
  CategoryModel? SelectedCategory;
  String SelectCatId = '';
  String loadingtext = 'Loading';

  void RefreshVar() {
    categoryController.isDataFetched = false;
    categoryController.fetchcategories();
  }

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
            Text('Categories'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                categoryController.isDataFetched = false;
                categoryController.fetchcategories();
                subcategoryController.isDataFetched = false;
                subcategoryController.fetchcategories();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    Category_Name = value;
                  },
                  maxLength: 15,
                  keyboardType: TextInputType.name,
                  //controller: Product_Name,
                  decoration: InputDecoration(
                    labelText: "Category Name",
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: GetBuilder<InsertCategoryController>(
                      builder: (insertcustomerController) {
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
                          if (Category_Name != '') {
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

                            insertcategoryController.UploadCat(Category_Name)
                                .then((value) => RefreshVar())
                                .then((value) => Navigator.of(context).pop())
                                .then((value) =>
                                    showToast(insertcategoryController.result));
                          } else {}
                        },
                        child: Text(
                          'Insert Category',
                          style: TextStyle(color: Colors.white),
                        ));
                  }),
                ),
                SizedBox(
                  height: 50,
                ),
                DottedLine(
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
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => categoryController.category.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              // Text('Fetching Rate! Please Wait'),
                              Text('No Categories Found ')
                            ],
                          ),
                        )
                      : DropdownButtonFormField<CategoryModel>(
                        dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: "Categories",
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
                          iconDisabledColor: Colors.blue.shade300,
                          iconEnabledColor: Colors.blue.shade300,
                          //  value: categoryController.category.first,
                          onChanged: (CategoryModel? value) {
                            SelectedCategory = value;
                            SelectCatId = (SelectedCategory?.Cat_id).toString();
                            print(SelectCatId);
                          },
                          items: categoryController.category
                              .map((cat) => DropdownMenuItem<CategoryModel>(
                                    value: cat,
                                    child: Text(cat.Cat_Name),
                                  ))
                              .toList(),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    SCategory_Name = value;
                  },
                  maxLength: 15,
                  keyboardType: TextInputType.name,
                  //controller: Product_Name,
                  decoration: InputDecoration(
                    labelText: "Sub-Category Name",
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: GetBuilder<InsertCategoryController>(
                      builder: (insertcustomerController) {
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
                          if (SCategory_Name != '') {
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

                            insertsubcategoryController.UploadSubCat(
                                    SCategory_Name, SelectCatId.toString())
                                .then((value) =>
                                    subcategoryController.isDataFetched = false)
                                .then((value) =>
                                    subcategoryController.fetchcategories())
                                // .then((value) => RefreshVar())
                                .then((value) => Navigator.of(context).pop())
                                .then((value) => showToast(
                                    insertsubcategoryController.result));
                          } else {}
                        },
                        child: Text(
                          'Insert Sub-Category',
                          style: TextStyle(color: Colors.white),
                        ));
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                DottedLine(
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
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => subcategoryController.sub_category.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              // Text('Fetching Rate! Please Wait'),
                              Text('No Sub-Categories Found'),
                            ],
                          ),
                        )
                      : DropdownButtonFormField<SubCategoryModel>(
                                                dropdownColor: Colors.white,

                          decoration: InputDecoration(
                            labelText: "Sub Categories",
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
                          onChanged: (SubCategoryModel? value) {
                            // SelectedCategory = value;
                            // SelectCatId = (SelectedCategory?.Cat_id).toString();
                            //rint(SelectCatId);
                          },
                          items: subcategoryController.sub_category
                              .map((cat) => DropdownMenuItem<SubCategoryModel>(
                                    value: cat,
                                    child: Text(cat.SCat_Name),
                                  ))
                              .toList(),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    );
  }
}
