// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:dotted_line/dotted_line.dart';
import 'package:treschic/controller/driver_controller.dart';
import 'package:treschic/model/driver_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDriver extends StatelessWidget {
  AddDriver({super.key});

  final DriverController driverController =
      Get.put(DriverController());
  String Driver_Name = '';

  String Driver_Number = '';
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
            Text('Drivers'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                driverController.isDataFetched = false;
                driverController.fetch_drivers();
                
              },
              icon: Icon(CupertinoIcons.refresh,color: Colors.blue.shade900,),
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
              onChanged: (value) {
                Driver_Name = value;
              },
              maxLength: 50,
              keyboardType: TextInputType.name,
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Driver Name ",
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
              onChanged: (value) {
                Driver_Number = value;
              },
              maxLength: 15,
              keyboardType: TextInputType.number,
              //controller: Product_Name,
              decoration: InputDecoration(
                labelText: "Driver Number ",
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
            child: GetBuilder<DriverController>(
                builder: (driverController) {
              return  OutlinedButton(
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
                    if (Driver_Number != '') {
                      if (Driver_Name != '') {
                        if (Driver_Number.length < 8) {
                          showToast(
                              'Driver Number should Have minimum 8 Digits');
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
                          driverController.UploadDriver(
                                  Driver_Name, Driver_Number)
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => driverController.isDataFetched = false)
                              .then((value) => driverController.fetch_drivers())
                              .then((value) =>
                                  showToast(driverController.result2));
                        }
                      } else {
                        showToast('Please add Driver Name');
                      }
                    }
                  },
                  child: Text(
                    'Insert Driver',
                    style: TextStyle(color: Colors.white),
                  ));
            }),
          ),SizedBox(
                  height: 20,
                ),Padding(
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
                    () => driverController.isLoading.value
                        ? Center(
                            child: Column(
                              children: [
                                // Text('Fetching Rate! Please Wait'),
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        :    driverController.drivers.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                // Text('Fetching Rate! Please Wait'),
                                Text('No Drivers Yet'),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<DriverModel>(
                            decoration: InputDecoration(
                              labelText: "Drivers",
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
                            onChanged: (DriverModel? value) {
                             // SelectedCategory = value;
                             // SelectCatId = (SelectedCategory?.Cat_id).toString();
                              //rint(SelectCatId);
                            },
                            items: driverController.drivers
                                .map((driver) => DropdownMenuItem<DriverModel>(
                                      value: driver,
                                      child: Text(driver.Driver_Name),
                                    ))
                                .toList(),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
        ]),
      ),
    );
  }
}
