// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:dotted_line/dotted_line.dart';
import 'package:treschic/controller/brand_controller.dart';
import 'package:treschic/controller/color_controller.dart';
import 'package:treschic/controller/insert_color_controller.dart';
import 'package:treschic/controller/insert_size_controller.dart';
import 'package:treschic/controller/size_controller.dart';
import 'package:treschic/model/brand_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/size_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/insert_brand_controller.dart';

class AddSize extends StatelessWidget {
  AddSize({super.key});

  final InsertSizeController insertSizeController =
      Get.put(InsertSizeController());
  final SizeController sizeController = Get.find<SizeController>();

  TextEditingController Size_Name = TextEditingController();
  TextEditingController Size_shortcut = TextEditingController();

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
            Text('Sizes'),
            IconButton(
              color: Colors.blue,
              iconSize: 24.0,
              onPressed: () {
                sizeController.isDataFetched = false;
                sizeController.fetchcolors();
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
              controller: Size_Name,
              decoration: InputDecoration(
                labelText: "Size Name ",
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
              maxLength: 50,
              keyboardType: TextInputType.name,
              controller: Size_shortcut,
              decoration: InputDecoration(
                labelText: "Size shortcut ",
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
            child: GetBuilder<InsertSizeController>(
                builder: (insertSizeController) {
              return OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 50),
                    backgroundColor: Colors.blue.shade900,
                    side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    if (Size_Name.text != '') {
                      if (Size_shortcut.text != ' ') {
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
                        insertSizeController.UploadSize(
                                Size_Name.text, Size_shortcut.text)
                            .then((value) => Size_Name.clear())
                            .then(
                                (value) => sizeController.isDataFetched = false)
                            .then((value) => sizeController.fetchcolors())
                            .then((value) =>
                                showToast(insertSizeController.result))
                            .then((value) => Navigator.of(context).pop());
                      } else {
                        showToast('Please add Color Name');
                      }
                    } else {
                      showToast('Please add Size Name');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Insert Size',
                      style: TextStyle(color: Colors.white),
                    ),
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
              () => sizeController.sizes.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          // Text('Fetching Rate! Please Wait'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    )
                  : DropdownButtonFormField<SizeModel>(
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: "Size",
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
                      onChanged: (SizeModel? value) {
                        //SelectedCategory = value;
                        //SelectCatId = (SelectedCategory?.Cat_id).toString();
                        //print(SelectCatId);
                      },
                      items: sizeController.sizes
                          .map((size) => DropdownMenuItem<SizeModel>(
                                value: size,
                                child: Text(size.Size + ' - ' + size.Shortcut),
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
