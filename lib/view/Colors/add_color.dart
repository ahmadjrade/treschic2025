// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:dotted_line/dotted_line.dart';
import 'package:treschic/controller/brand_controller.dart';
import 'package:treschic/controller/color_controller.dart';
import 'package:treschic/controller/insert_color_controller.dart';
import 'package:treschic/model/brand_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/insert_brand_controller.dart';

class AddColor extends StatelessWidget {
  AddColor({super.key});

  final InsertColorController insertColorController =
      Get.put(InsertColorController());
  final ColorController colorController = Get.find<ColorController>();

  TextEditingController Color = TextEditingController();
  TextEditingController Color_name = TextEditingController();

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
            Text('Colors'),
            IconButton(
              color: Colors.blue,
              iconSize: 24.0,
              onPressed: () {
                colorController.isDataFetched = false;
                colorController.fetchcolors();
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
              controller: Color,
              decoration: InputDecoration(
                labelText: "Color Name ",
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
              controller: Color_name,
              decoration: InputDecoration(
                labelText: "Color Shortcut ",
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
            child: GetBuilder<InsertColorController>(
                builder: (insertColorController) {
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
                    if (Color.text != '') {
                      if (Color_name.text != '') {
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
                        insertColorController.UploadColor(
                                Color.text, Color_name.text)
                            .then((value) => Color.clear())
                            .then((value) =>
                                colorController.isDataFetched = false)
                            .then((value) => colorController.fetchcolors())
                            .then((value) =>
                                showToast(insertColorController.result))
                            .then((value) => Navigator.of(context).pop());
                      } else {
                        showToast('Please add Color Shortcut');
                      }
                    } else {
                      showToast('Please add Color Name');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Insert Color',
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
                      dropdownColor: Colors.white,
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
                        //SelectedCategory = value;
                        //SelectCatId = (SelectedCategory?.Cat_id).toString();
                        //print(SelectCatId);
                      },
                      items: colorController.colors
                          .map((color) => DropdownMenuItem<ColorModel>(
                                value: color,
                                child: Text(
                                    color.Color + ' - ' + color.Color_name),
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
