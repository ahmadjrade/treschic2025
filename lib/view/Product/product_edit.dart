// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, unused_import, must_be_immutable

import 'dart:math';

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/controller/supplier_controller.dart';
import 'package:fixnshop_admin/controller/update_phone_attributes.dart';
import 'package:fixnshop_admin/controller/update_product_attributes.dart';
import 'package:fixnshop_admin/model/brand_model.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/sub_category_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProductEdit extends StatefulWidget {
  int Product_id, Category, SubCategory;
  String Product_Name;
  String P_Code, P_Color, Cost_Price, LPrice, Brand, MPrice;

  ProductEdit(
      {super.key,
      required this.Product_id,
      required this.Product_Name,
      required this.P_Code,
      required this.Cost_Price,
      required this.LPrice,
      required this.SubCategory,
      required this.Category,
      required this.Brand,
      required this.MPrice,
      required this.P_Color});

  @override
  State<ProductEdit> createState() => _PhoneEditState();
}

class _PhoneEditState extends State<ProductEdit> {
  final ProductController productController = Get.find<ProductController>();

  final UpdateProductController updateProductController =
      Get.put(UpdateProductController());

  final ColorController colorController = Get.find<ColorController>();

  final SubCategoryController subcategoryController =
      Get.find<SubCategoryController>();
  final BrandController brandController = Get.find<BrandController>();
  final BarcodeController barcodeController = Get.find<BarcodeController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final SupplierController supplierController = Get.find<SupplierController>();
  CategoryModel? SelectedCategory;
  String SelectCatId = '';

  SubCategoryModel? SelectedSubCategory;
  String SelectSubCatId = '';

  BrandModel? SelectedBrand;
  String SelectBrandId = '';

  ColorModel? SelectedColor;
  int SelectedColorId = 0;
  @override
  Widget build(BuildContext context) {
    String New_PCODE = widget.P_Code,
        New_MPRICE = widget.MPrice,
        New_CPRICE = widget.Cost_Price,
        New_LPRICE = widget.LPrice;
    // Phone_Category = widget.Category;

    //String New_Conditiion = widget.Category;
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Edit Phone'),
            Row(
              children: [
                IconButton(
                    color: Colors.deepPurple,
                    onPressed: () {
                      productController.iseditable.value =
                          !productController.iseditable.value;
                    },
                    icon: Icon(Icons.edit)),
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Obx(() {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //maxLength: 15,
                  initialValue: widget.Product_Name,
                  readOnly: true,
                  //controller: Product_Name,

                  decoration: InputDecoration(
                    //helperText: '*',

                    //  hintText: '03123456',
                    labelText: "Phone Name",
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //maxLength: 15,
                        initialValue: widget.P_Code,
                        readOnly: productController.iseditable.value,
                        //controller: Product_Name,
                        onChanged: (value) {
                          New_PCODE = value;
                          print(New_PCODE);
                        },
                        decoration: InputDecoration(
                          //helperText: '*',

                          //  hintText: '03123456',

                          labelText: "Product Code",
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
                      width: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        icon: Icon(Icons.qr_code_scanner_rounded),
                        color: Colors.black,
                        onPressed: () {
                          barcodeController.scanBarcode();
                        },
                      ),
                    )
                  ],
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // TextFormField(
                //   //maxLength: 15,
                //   initialValue: widget.Brand,
                //   maxLines: 2,
                //   readOnly: productController.iseditable.value,
                //   onChanged: (value) {
                //     New_MPRICE = value;
                //     print(New_MPRICE);
                //   },
                //   //controller: Product_Name,
                //   decoration: InputDecoration(
                //     //helperText: '*',

                //     //  hintText: '03123456',
                //     labelText: "Brand",
                //     labelStyle: TextStyle(
                //       color: Colors.black,
                //     ),
                //     fillColor: Colors.black,
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15.0),
                //       borderSide: BorderSide(
                //         color: Colors.black,
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(15.0),
                //       borderSide: BorderSide(
                //         color: Colors.black,
                //         width: 2.0,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //maxLength: 15,
                        initialValue: widget.Cost_Price.toString(),
                        readOnly: productController.iseditable.value,
                        onChanged: (value) {
                          New_CPRICE = value;
                          print(New_CPRICE);
                        },
                        keyboardType: TextInputType.number,

                        //controller: Product_Name,
                        decoration: InputDecoration(
                          //helperText: '*',

                          //  hintText: '03123456',
                          labelText: "Cost Price",
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
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        //maxLength: 15,
                        keyboardType: TextInputType.number,
                        initialValue: widget.LPrice.toString(),
                        readOnly: productController.iseditable.value,
                        //controller: Product_Name,
                        onChanged: (value) {
                          New_LPRICE = value;
                          print(New_LPRICE);
                        },
                        decoration: InputDecoration(
                          //helperText: '*',

                          //  hintText: '03123456',
                          labelText: "Lowest Price",
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
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        //maxLength: 15,
                        keyboardType: TextInputType.number,
                        initialValue: widget.MPrice.toString(),
                        readOnly: productController.iseditable.value,
                        //controller: Product_Name,
                        onChanged: (value) {
                          New_MPRICE = value;
                          print(New_MPRICE);
                        },
                        decoration: InputDecoration(
                          //helperText: '*',

                          //  hintText: '03123456',
                          labelText: "Max Price",
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
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                SizedBox(width: 20),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Obx(() {
                          if (categoryController.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                            // patientsController.fetchpatients();
                          } else if (categoryController.category.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No Categories Found !.'),
                                ],
                              ),
                            );
                          } else {
                            return DropdownButtonFormField<CategoryModel>(
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
                              iconDisabledColor: Colors.deepPurple.shade300,
                              iconEnabledColor: Colors.deepPurple.shade300,
                              //  value: categoryController.category.first,
                              onChanged: (CategoryModel? value) {
                                print(widget.Category);
                                categoryController.SelectedCategory.value =
                                    value;
                                subcategoryController
                                    .selectedSubCategory.value = null;

                                SelectedCategory = value;
                                widget.Category = (SelectedCategory?.Cat_id)!;
                                print(SelectCatId);
                              },
                              items: categoryController.category
                                  .map((color) =>
                                      DropdownMenuItem<CategoryModel>(
                                        value: color,
                                        child: Text(color.Cat_Name),
                                      ))
                                  .toList(),
                            );
                          }
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        color: Colors.blueAccent,
                        iconSize: 24.0,
                        onPressed: () {
                          Get.toNamed('/NewCat');
                          // colorController.isDataFetched = false;
                          // colorController.fetchcolors();
                          // //Quantities.clear();
                          //Quantities.add(Product_Quantity.text);
                          //  print(Quantities);
                        },
                        icon: Icon(CupertinoIcons.add),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Obx(
                          () {
                            final subcategoriesForSelectedCategory =
                                subcategoryController.sub_category
                                    .where((subCat) =>
                                        subCat.Cat_id ==
                                        categoryController
                                            .SelectedCategory.value?.Cat_id)
                                    .toList();

                            if (subcategoriesForSelectedCategory.isEmpty) {
                              return TextFormField(
                                readOnly: true,
                                initialValue:
                                    'No Sub Categories For Selected Categories',
                                //controller: Product_Name,
                                decoration: InputDecoration(
                                  labelText: "Sub Categories ",
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
                              );
                            }

                            return DropdownButtonFormField<SubCategoryModel>(
                              iconDisabledColor: Colors.deepPurple.shade300,
                              iconEnabledColor: Colors.deepPurple.shade300,
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
                              value: subcategoryController
                                  .selectedSubCategory.value,
                              onChanged: (SubCategoryModel? value) {
                                print(widget.Category);
                                subcategoryController
                                    .selectedSubCategory.value = value;
                                SelectedSubCategory = value;
                                widget.SubCategory =
                                    (SelectedSubCategory?.SCat_id)!;
                                print(SelectSubCatId);
                              },
                              items: subcategoriesForSelectedCategory
                                  .map((subCat) =>
                                      DropdownMenuItem<SubCategoryModel>(
                                        value: subCat,
                                        child: Text(subCat.SCat_Name),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        color: Colors.blueAccent,
                        iconSize: 24.0,
                        onPressed: () {
                          Get.toNamed('/NewCat');
                          // colorController.isDataFetched = false;
                          // colorController.fetchcolors();
                          // //Quantities.clear();
                          //Quantities.add(Product_Quantity.text);
                          //print(Quantities);
                        },
                        icon: Icon(CupertinoIcons.add),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                                    print(widget.Brand);
                                    SelectedBrand = value;
                                    widget.Brand =
                                        (SelectedBrand?.Brand_Name).toString();
                                    print(SelectBrandId);
                                    //SelectedCategory = value;
                                    //SelectCatId = (SelectedCategory?.Cat_id).toString();
                                    //print(SelectCatId);
                                  },
                                  items: brandController.brands
                                      .map((brand) =>
                                          DropdownMenuItem<BrandModel>(
                                            value: brand,
                                            child: Text(brand.Brand_Name),
                                          ))
                                      .toList(),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        color: Colors.blueAccent,
                        iconSize: 24.0,
                        onPressed: () {
                          Get.toNamed('/NewBrand');
                          // colorController.isDataFetched = false;
                          // colorController.fetchcolors();
                          // //Quantities.clear();
                          //Quantities.add(Product_Quantity.text);
                          //  print(Quantities);
                        },
                        icon: Icon(CupertinoIcons.add),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Obx(
                          () => colorController.colors.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      // Text('Fetching Rate! Please Wait'),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                )
                              : DropdownButtonFormField<ColorModel>(
                                  decoration: InputDecoration(
                                    labelText: "Colors",
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
                                  onChanged: (ColorModel? value) {
                                    print(widget.P_Color);
                                    SelectedColor = value;
                                    widget.P_Color =
                                        (SelectedColor?.Color).toString();
                                  },
                                  items: colorController.colors
                                      .map((color) =>
                                          DropdownMenuItem<ColorModel>(
                                            value: color,
                                            child: Text(color.Color),
                                          ))
                                      .toList(),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        color: Colors.blueAccent,
                        iconSize: 24.0,
                        onPressed: () {
                          Get.toNamed('/NewColor');
                          // colorController.isDataFetched = false;
                          // colorController.fetchcolors();
                          // //Quantities.clear();
                          //Quantities.add(Product_Quantity.text);
                          //  print(Quantities);
                        },
                        icon: Icon(CupertinoIcons.add),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(
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
                      updateProductController.UpdatePhone(
                              widget.Product_id.toString(),
                              New_PCODE,
                              New_LPRICE,
                              New_MPRICE,
                              New_CPRICE,
                              widget.Category.toString(),
                              widget.SubCategory.toString(),
                              widget.P_Color.toString(),
                              widget.Brand.toString())
                          .then((value) =>
                              showToast(updateProductController.result))
                          .then((value) =>
                              productController.isDataFetched = false)
                          .then((value) => productController.fetchproducts())
                          .then((value) => Navigator.of(context).pop())
                          .then((value) => Navigator.of(context).pop());
                    },
                    child: Text(
                      'Commit Update',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          }),
        ),
      )),
    );
  }
}
