// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, unused_import, must_be_immutable

import 'dart:math';

import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/update_phone_attributes.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneEdit extends StatefulWidget {
  int Phone_id,  Color;
  double Cost_Price, Sell_Price;
  String Phone_Name;
  String IMEI, Condition, Capacity;

  PhoneEdit(
      {super.key,
      required this.Phone_id,
      required this.Phone_Name,
      required this.IMEI,
      required this.Cost_Price,
      required this.Sell_Price,
      required this.Capacity,
      required this.Condition,
      required this.Color});

  @override
  State<PhoneEdit> createState() => _PhoneEditState();
}

class _PhoneEditState extends State<PhoneEdit> {
  final PhoneController phoneController = Get.find<PhoneController>();
  final UpdatePhoneController updatePhoneController =
      Get.put(UpdatePhoneController());

  final ColorController colorController = Get.find<ColorController>();

  List<String> capacity = [
    '16G',
    '32G',
    '64G',
    '128G',
    '256G',
    '512G',
    '1TB',
    '2TB',
  ];
  List<String> phone_conditions = [
    'Used',
    'New',
  ];

  ColorModel? SelectedColor;

  int SelectedColorId = 0;

  @override
  Widget build(BuildContext context) {
    String New_IMEI = widget.IMEI,
        New_Cost = widget.Cost_Price.toString(),
        New_Sell = widget.Sell_Price.toString();
    // Phone_Condition = widget.Condition;

    String New_Conditiion = widget.Condition;
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
                      phoneController.iseditable.value =
                          !phoneController.iseditable.value;
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
                  initialValue: widget.Phone_Name,
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
                TextFormField(
                  //maxLength: 15,
                  initialValue: widget.IMEI,
                  readOnly: phoneController.iseditable.value,
                  //controller: Product_Name,
                  onChanged: (value) {
                    New_IMEI = value;
                    print(New_IMEI);
                  },
                  decoration: InputDecoration(
                    //helperText: '*',

                    //  hintText: '03123456',

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
                SizedBox(
                  height: 20,
                ),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //maxLength: 15,
                        initialValue: widget.Cost_Price.toString(),
                        readOnly: phoneController.iseditable.value,
                        onChanged: (value) {
                          New_Cost = value;
                          print(New_Cost);
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
                        initialValue: widget.Sell_Price.toString(),
                        readOnly: phoneController.iseditable.value,
                        //controller: Product_Name,
                        onChanged: (value) {
                          New_Sell = value;
                          print(New_Sell);
                        },
                        decoration: InputDecoration(
                          //helperText: '*',

                          //  hintText: '03123456',
                          labelText: "Sell Price",
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Capacity ",
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
                          //value: Capacity,
                          onChanged: (newIndex) {
                            print(widget.Capacity); // setState(() {

                            widget.Capacity = capacity[newIndex];
                            print(widget.Capacity); // setState(() {
                            //   SelectedCapacity = capacity[newIndex];
                            //   SelectedCapacityIndex = newIndex;
                            //   print(SelectedCapacity);
                            //   //  selectedMonthIndex = newIndex!;
                            //   //  SelectMonth = newIndex + 1;
                            // });
                          },
                          items: capacity.asMap().entries.map<DropdownMenuItem>(
                            (entry) {
                              int index = entry.key;
                              String monthName = entry.value;
                              return DropdownMenuItem(
                                value: index,
                                child: Text(
                                  monthName,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
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
                                    labelText: "Color",
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
                                  //   value: colorController.colors.w,
                                  onChanged: (ColorModel? value) {
                                    SelectedColor = value;
                                    print(widget.Color);

                                    widget.Color = (SelectedColor?.Color_id)!;
                                    print(widget.Color);
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

                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(00, 0, 0, 0),
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //         color: Colors.black,
                      //         iconSize: 24.0,
                      //         icon: Icon(CupertinoIcons.add),
                      //         onPressed: () {
                      //           //customerController.searchCustomer(numberController);
                      //           Get.toNamed('/NewColor');
                      //         },
                      //       ),
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ]),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Condition ",
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
                  onChanged: (newIndex) {
                    print(widget.Condition); // setState(() {

                    widget.Condition = phone_conditions[newIndex];
                    print(widget.Condition); // setState(() {
                    //   SelectedCapacity = capacity[newIndex];
                    //   SelectedCapacityIndex = newIndex;
                    //   print(SelectedCapacity);
                    //   //  selectedMonthIndex = newIndex!;
                    //   //  SelectMonth = newIndex + 1;
                    // });
                  },
                  items: phone_conditions.asMap().entries.map<DropdownMenuItem>(
                    (entry) {
                      int index = entry.key;
                      String monthName = entry.value;
                      return DropdownMenuItem(
                        value: index,
                        child: Text(
                          monthName,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ).toList(),
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
                      updatePhoneController.UpdatePhone(
                              widget.Phone_id.toString(),
                              New_IMEI,
                              New_Cost,
                              New_Sell,
                              widget.Capacity,
                              widget.Color.toString(),
                              widget.Condition)
                          .then((value) =>
                              showToast(updatePhoneController.result))
                          .then(
                              (value) => phoneController.isDataFetched = false)
                          .then((value) => phoneController.fetchphones())
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
