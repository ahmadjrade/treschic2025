// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/controller/insert_customer_controller.dart';
import 'package:treschic/controller/stores_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStore extends StatelessWidget {
  AddStore({super.key});

  final StoresController storesController = Get.find<StoresController>();

  String Store_Name = '';

  String Store_Number = '';
  String Store_Loc = '';
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
            Text('Add Store'),
            IconButton(
              color: Colors.white,
              iconSize: 24.0,
              onPressed: () {
                // customerController.isDataFetched = false;
                // customerController.fetchcustomers();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
          Column(

            children: [ SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            onChanged: (value) {
              Store_Name = value;
            },
            keyboardType: TextInputType.name,
            //controller: Product_Name,
            decoration: InputDecoration(
              labelText: "Store Name ",
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
              Store_Number = value;
            },
      
            keyboardType: TextInputType.number,
            //controller: Product_Name,
            decoration: InputDecoration(
              labelText: "Store Number ",
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
              Store_Loc = value;
            },
            keyboardType: TextInputType.number,
            //controller: Product_Name,
            decoration: InputDecoration(
              labelText: "Store Location ",
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
        ),],
          ),

        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child:  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(double.maxFinite, 50),
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      if (Store_Name != '') {
                        if (Store_Loc != '') {
                          if (Store_Number != '') {
                            if (Store_Number.length < 8) {
                              showToast(
                                  'Store Number should Have minimum 8 Digits');
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
                              storesController.UploadStore(
                                      Store_Name, Store_Number, Store_Loc)
                                  .then((value) => Navigator.of(context).pop())
                                  .then((value) =>
                                      storesController.isDataFetched = false)
                                  .then((value) => storesController.fetchstores())
                                  .then((value) =>
                                      showToast(storesController.result)).then((value) => Navigator.of(context).pop());
                            }
                          } else {
                            showToast('Please add Store Number');
                          }
                        } else {
                          showToast('Please add Store Location');
                        }
                      } else {
                        showToast('Please add Store Name');
                      }
                    },
                    child: Text(
                      'Insert Store',
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                  
                    ))
                    
            ),
            SizedBox(height: 40,)
          ],
        ),
      ]),
    );
  }
}
