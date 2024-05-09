// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/image_controller.dart';
import 'package:fixnshop_admin/controller/insert_product_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/supplier_controller.dart';
import 'package:fixnshop_admin/model/brand_model.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/sub_category_model.dart';
import 'package:fixnshop_admin/model/supplier_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controller/sub_category_controller.dart';

class BuyAccessories extends StatefulWidget {
  const BuyAccessories({super.key});

  @override
  State<BuyAccessories> createState() => _BuyAccessoriesState();
}

final SubCategoryController subcategoryController =
    Get.find<SubCategoryController>();
final ColorController colorController = Get.find<ColorController>();
final BrandController brandController = Get.find<BrandController>();
final BarcodeController barcodeController = Get.find<BarcodeController>();

final InsertProductController insertProductController =
    Get.find<InsertProductController>();
final ProductController productController = Get.find<ProductController>();

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
TextEditingController Product_Code = TextEditingController();
TextEditingController Product_Cost = TextEditingController();
TextEditingController Product_LPrice = TextEditingController();
TextEditingController Product_MPrice = TextEditingController();
TextEditingController Product_Name = TextEditingController();
//List Quantities = [];

class _BuyAccessoriesState extends State<BuyAccessories> {
  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    Future<void> clearSelect() async {
      categoryController.clearSelectedCat();
      subcategoryController.clearSelectedCat();
      SelectedCategory = null;
    }

    final ImageController controller = Get.put(ImageController());

    //  Future<void> RefreshData() async {
    //   categoryController.isDataFetched = false;
    //   categoryController.fetchcategories();
    //   supplierController.isDataFetched = false;
    //   supplierController.fetchsuppliers();
    //   subcategoryController.isDataFetched =false;
    //   subcategoryController.fetchcategories();
    // }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Buy Accessories'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                Get.toNamed('/NewProductDetail');
              },
              icon: Icon(CupertinoIcons.add),
            ),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                clearSelect()
                    .then((value) => categoryController.isDataFetched = false)
                    .then((value) => categoryController.fetchcategories())
                    .then((value) => supplierController.isDataFetched = false)
                    .then((value) => supplierController.fetchsuppliers())
                    .then(
                        (value) => subcategoryController.isDataFetched = false)
                    .then((value) => subcategoryController.fetchcategories());
                // categoryController.selectedCategory.value = null;
                // subcategoryController.selectedSubCategory.value = null;

                // categoryController.category.clear();
                // subcategoryController.sub_category.clear();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Obx(() {
          //   if (controller.imagePath.value.isEmpty) {
          //     return Text('No image selected');
          //   } else {
          //     return SizedBox(
          //       height: 200,
          //       width: 200,
          //       child: Image.file(
          //         File(controller.imagePath.value),
          //         width: 300,
          //         height: 300,
          //       ),
          //     );
          //   }
          // }),
          // ElevatedButton(
          //   onPressed: () async {
          //     await controller.getImageFromCamera();
          //   },
          //   child: Text('Take Photo'),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     await controller.getImageFromGallery();
          //   },
          //   child: Text('Choose from Gallery'),
          // ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Product Name ",
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                          categoryController.SelectedCategory.value = value;
                          subcategoryController.selectedSubCategory.value =
                              null;

                          SelectedCategory = value;
                          SelectCatId = (SelectedCategory?.Cat_id).toString();
                          print(SelectCatId);
                        },
                        items: categoryController.category
                            .map((color) => DropdownMenuItem<CategoryModel>(
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
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                child: IconButton(
                  color: Colors.blueAccent,
                  iconSize: 24.0,
                  onPressed: () {
                    Get.toNamed('/NewCat');
                    // colorController.isDataFetched = false;
                    // colorController.fetchcolors();
                    // //Quantities.clear();
                    //Quantities.add(Product_Quantity.text);
                   // print(Quantities);
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
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Obx(
                    () {
                      final subcategoriesForSelectedCategory =
                          subcategoryController
                              .sub_category
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
                        value: subcategoryController.selectedSubCategory.value,
                        onChanged: (SubCategoryModel? value) {
                          subcategoryController.selectedSubCategory.value =
                              value;
                          SelectedSubCategory = value;
                          SelectSubCatId =
                              (SelectedSubCategory?.SCat_id).toString();
                          print(SelectSubCatId);
                        },
                        items: subcategoriesForSelectedCategory
                            .map((subCat) => DropdownMenuItem<SubCategoryModel>(
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
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
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
                            iconDisabledColor: Colors.deepPurple.shade300,
                            iconEnabledColor: Colors.deepPurple.shade300,
                            //  value: categoryController.category.first,
                            onChanged: (BrandModel? value) {
                              SelectedBrand = value;
                              SelectBrandId =
                                  (SelectedBrand?.Brand_id).toString();
                              print(SelectBrandId);
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                child: IconButton(
                  color: Colors.blueAccent,
                  iconSize: 24.0,
                  onPressed: () {
                    Get.toNamed('/NewBrand');
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
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                              SelectedColor = value;
                              SelectedColorId = (SelectedColor?.Color_id)!;
                            },
                            items: colorController.colors
                                .map((color) => DropdownMenuItem<ColorModel>(
                                      value: color,
                                      child: Text(color.Color),
                                    ))
                                .toList(),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
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
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    Product_Code.text = barcodeController.barcode.value;
                    return TextFormField(
                      controller: Product_Code,
                      onChanged: (value) {
                        barcodeController.barcode.value = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Product Code ",
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
                  }),
                ),
                // Expanded(
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 25),
                //     child: TextFormField(
                //       controller: Product_Code,
                //       decoration: InputDecoration(
                //         labelText: "Product Code ",
                //         labelStyle: TextStyle(
                //           color: Colors.black,
                //         ),
                //         fillColor: Colors.black,
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(15.0),
                //           borderSide: BorderSide(
                //             color: Colors.black,
                //           ),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(15.0),
                //           borderSide: BorderSide(
                //             color: Colors.black,
                //             width: 2.0,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              width: double.infinity,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Prices',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(color: Colors.black)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: false,
                        //   maxLength: 50,
                        //   initialValue: Product_Code,
                        keyboardType: TextInputType.number,
                        controller: Product_Cost,
                        decoration: InputDecoration(
                          labelText: "Cost ",
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
                        readOnly: false,
                        //   maxLength: 50,
                        //   initialValue: Product_Code,
                        keyboardType: TextInputType.number,
                        controller: Product_LPrice,
                        decoration: InputDecoration(
                          labelText: "LPrice ",
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
                        readOnly: false,
                        //   maxLength: 50,
                        //   initialValue: Product_Code,
                        keyboardType: TextInputType.number,
                        controller: Product_MPrice,
                        decoration: InputDecoration(
                          labelText: "MPrice ",
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
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GetBuilder<InsertProductController>(
                builder: (insertProductController) {
              return OutlinedButton(
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
                    if (Product_Name.text == '') {
                      showToast('Please insert Product Name');
                    } else if (SelectCatId == '') {
                      showToast('Select Category');
                    } else if (SelectSubCatId == '') {
                      showToast('Select Sub-Category');
                    } else if (SelectBrandId == '') {
                      showToast('Select Brand');
                    } else if (SelectedColorId == '') {
                      showToast('Select Color');
                    } else if (Product_LPrice.text == '') {
                      showToast('Please Add Lower Price');
                    } else if (barcodeController.barcode.value == '') {
                      showToast('Please Add Product Code ');
                    } else if (Product_MPrice.text == '') {
                      showToast('Please Add Max Price');
                    } else if ((Product_Cost.text) == '') {
                      showToast('Please Add Product Cost');
                    } else if (double.tryParse(Product_Cost.text)! == 0) {
                      showToast('Please Increase Cost');
                    } else if (double.tryParse(Product_LPrice.text)! == 0) {
                      showToast('Please Increase Lower Price');
                    } else if (double.tryParse(Product_MPrice.text)! == 0) {
                      showToast('Please Increase Max Price');
                    } else if (double.tryParse(Product_Cost.text)! >
                        double.tryParse(Product_LPrice.text)!) {
                      showToast('Cost Can\'t Be Bigger than Price');
                    } else if (double.tryParse(Product_LPrice.text) ==
                        double.tryParse(Product_Cost.text)) {
                      showToast('Cost Can\'t Be equal to lowest Price');
                    } else if (double.tryParse(Product_MPrice.text) ==
                        double.tryParse(Product_Cost.text)) {
                      showToast('Cost Can\'t Be equal to Max Price');
                    } else if (double.tryParse(Product_LPrice.text)! >
                        double.tryParse(Product_MPrice.text)!) {
                      showToast('Lowest Pric2 Can\'t Be Bigger to Max Price');
                    } else {
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
                      insertProductController.UploadAcc(
                              Product_Name.text,
                              SelectCatId,
                              SelectSubCatId,
                              SelectBrandId,
                              Product_Code.text,
                              SelectedColorId.toString(),
                              Product_Cost.text,
                              Product_LPrice.text,
                              Product_MPrice.text)
                          .then((value) =>
                              showToast(insertProductController.result))
                          .then((value) =>
                              productController.isDataFetched = false)
                          .then((value) => productController.fetchproducts())
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  child: Text(
                    'Insert Product',
                    style: TextStyle(color: Colors.white),
                  ));
            }),
          ),

          //Text(Quantities.toString())
        ]),
      ),
    );
  }
}
