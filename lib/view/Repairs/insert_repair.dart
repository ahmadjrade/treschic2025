// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/brand_controller_phones.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/datetime_controller.dart';
import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:fixnshop_admin/controller/insert_repair_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/model/brand_model_phones.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/phonemodels_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/category_controller.dart';
import '../../controller/sub_category_controller.dart';
import '../../controller/supplier_controller.dart';
import '../../model/category_model.dart';
import '../../model/sub_category_model.dart';

class InsertRepair extends StatelessWidget {
  String Cus_id, Cus_Name, Cus_Number;
  InsertRepair(
      {super.key,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number});

  final DateTimeController dateController = DateTimeController();
  String formattedDate = '';
  String formattedTime = '';

  final InsertRepairController insertrepairController =
      Get.put(InsertRepairController());

  final SubCategoryController subcategoryController =
      Get.find<SubCategoryController>();

  final CategoryController categoryController = Get.find<CategoryController>();
  final RepairsController repairsController = Get.find<RepairsController>();

  final SupplierController supplierController = Get.find<SupplierController>();
  final HomeController homeController = Get.find<HomeController>();

  CategoryModel? SelectedCategory;
  String cusname = '';

  String SelectCatId = '0';
  final CustomerController customerController = Get.find<CustomerController>();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneIssue = TextEditingController();
  final TextEditingController phoneIMEI = TextEditingController();

  final TextEditingController phonePassowrd = TextEditingController();
  final TextEditingController phoneModel = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController receiviedMoney = TextEditingController();

  final BrandControllerPhones brandController =
      Get.find<BrandControllerPhones>();
  final PhoneModelController phoneModelController =
      Get.find<PhoneModelController>();

  BrandModelPhones? SelectedBrand;
  String SelectedBrandName = '';

  PhoneModelsModel? SelectedPhone;
  String SelectedPhoneName = '';

  @override
  Widget build(BuildContext context) {
    Future<void> clear() async {
      numberController.clear();
      idController.clear();
      nameController.clear();
      phoneModel.clear();
      phonePassowrd.clear();
      phoneIssue.clear();
      note.clear();
      receiviedMoney.clear();
      customerController.resetResult();
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    formattedDate = dateController.getFormattedDate();
    formattedTime = dateController.getFormattedTime();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //leading: Text('$formattedDate'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Repair Ticket'),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            //       child: Text(
            //         '$formattedDate',
            //         style: TextStyle(fontSize: 14),
            //       ),
            //     ),
            //     SizedBox(width: 5,),
            //     Padding(
            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            //       child: Text(
            //         '$formattedTime',
            //         style: TextStyle(fontSize: 14),
            //       ),
            //     ),
            //   ],
            // ),
            IconButton(
              color: Colors.blue.shade900,
              iconSize: 24.0,
              onPressed: () {
                customerController.isDataFetched = false;
                customerController.fetchcustomers();

                phoneModelController.SelectedPhoneModel.value = null;
                brandController.selectedBrand.value = null;
                phoneModelController.phone_model.clear();
                brandController.brands.clear();
                phoneModelController.isDataFetched = false;
                phoneModelController.fetchphonemodel();
                brandController.isDataFetched = false;
                brandController.fetchbrands();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: '$Cus_Name || $Cus_Number',
                    //controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Customer Name ",
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
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                              : DropdownButtonFormField<BrandModelPhones>(
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
                                  iconEnabledColor:
                                      const Color.fromARGB(255, 20, 15, 29),
                                  //  value: categoryController.category.first,
                                  onChanged: (BrandModelPhones? value) {
                                    brandController.selectedBrand.value = value;
                                    phoneModelController
                                        .SelectedPhoneModel.value = null;

                                    SelectedBrand = value;
                                    SelectedBrandName =
                                        (SelectedBrand?.Brand_Name)!;
                                    print(SelectedBrandName);
                                  },
                                  items: brandController.brands
                                      .map((brand) =>
                                          DropdownMenuItem<BrandModelPhones>(
                                            value: brand,
                                            child: Text(brand.Brand_Name),
                                          ))
                                      .toList(),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            IconButton(
                              color: Colors.black,
                              iconSize: 24.0,
                              icon: Icon(CupertinoIcons.add),
                              onPressed: () {
                                //customerController.searchCustomer(numberController);
                                Get.toNamed('/NewBrand');
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () {
                            final phonemodelForSelectedBrand =
                                phoneModelController.phone_model
                                    .where((subCat) =>
                                        subCat.Brand_id ==
                                        brandController
                                            .selectedBrand.value?.Brand_id)
                                    .toList();

                            if (phonemodelForSelectedBrand.isEmpty) {
                              return TextFormField(
                                readOnly: true,
                                initialValue:
                                    'No Phone Models For Selected Brand',
                                //controller: Product_Name,
                                decoration: InputDecoration(
                                  labelText: "Phone Models ",
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

                            return DropdownButtonFormField<PhoneModelsModel>(
                              iconDisabledColor: Colors.deepPurple.shade300,
                              iconEnabledColor: Colors.deepPurple.shade300,
                              decoration: InputDecoration(
                                labelText: "Phone Models",
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
                              value:
                                  phoneModelController.SelectedPhoneModel.value,
                              onChanged: (PhoneModelsModel? value) {
                                phoneModelController.SelectedPhoneModel.value =
                                    value;

                                SelectedPhone = value;
                                SelectedPhoneName =
                                    (SelectedPhone?.Phone_Name)!;
                                print(SelectedPhoneName);
                              },
                              items: phonemodelForSelectedBrand
                                  .map((subCat) =>
                                      DropdownMenuItem<PhoneModelsModel>(
                                        value: subCat,
                                        child: Text(subCat.Phone_Name),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            IconButton(
                              color: Colors.black,
                              iconSize: 24.0,
                              icon: Icon(CupertinoIcons.add),
                              onPressed: () {
                                //customerController.searchCustomer(numberController);
                                Get.toNamed('/NewPhoneModel');
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      readOnly: false,
                      controller: phonePassowrd,
                      decoration: InputDecoration(
                        hintText: 'If Pattern write the numbers',
                        labelText: "Phone Password",
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
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    maxLines: 1,
                    maxLength: 15,
                    keyboardType: TextInputType.number,
                    controller: phoneIMEI,
                    decoration: InputDecoration(
                      hintText: '123456789012345',
                      labelText: "IMEI/SN",
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
                    maxLines: 1,
                    controller: phoneIssue,
                    decoration: InputDecoration(
                      hintText:
                          'List all the problems that the customer is facing',
                      labelText: "Issue",
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
                    maxLines: 1,
                    controller: note,
                    decoration: InputDecoration(
                      labelText: "Note",
                      hintText: 'Any Note the customer want to mark it ! ',
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          //  initialValue: '0',
                          controller: receiviedMoney,
                          decoration: InputDecoration(
                            labelText: "Received Money",
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

                      //Checkbox(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GetBuilder<InsertRepairController>(
                  builder: (insertrepairController) {
                return OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.green.shade100,
                      side: BorderSide(
                          width: 2.0, color: Colors.green.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      if (idController.text == '' &&
                          nameController.text == '' &&
                          numberController.text == '') {
                        showToast('Please Add Customer Number ');
                      } else if (SelectedPhoneName == '') {
                        showToast('Add Phone Model ');
                      } else if (phoneIssue.text == '') {
                        showToast('Add Phone Issue');
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
                        insertrepairController.UploadRepair(
                                idController.text,
                                numberController.text,
                                nameController.text,
                                SelectedPhoneName,
                                phonePassowrd.text,
                                phoneIMEI.text,
                                phoneIssue.text,
                                note.text,
                                receiviedMoney.text)
                            .then((value) => Navigator.of(context).pop())
                            .then((value) =>
                                repairsController.isDataFetched = false)
                            .then((Value) => repairsController.fetchrepairs())
                            .then((value) => clear())
                            .then((value) =>
                                showToast(insertrepairController.result));
                      }
                    },
                    child: Text(
                      'Insert Repair',
                      style: TextStyle(color: Colors.green.shade900),
                    ));
              }),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
