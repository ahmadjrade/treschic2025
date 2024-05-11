// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/insert_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductDetail extends StatelessWidget {
  String Product_id, Product_Name, Product_Code, Product_LPrice, Product_MPrice;
  AddProductDetail(
      {super.key,
      required this.Product_id,
      required this.Product_Name,
      required this.Product_Code,
      required this.Product_LPrice,
      required this.Product_MPrice});
  final InsertProductDetailController insertProductDetailController =
      Get.find<InsertProductDetailController>();
  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();
  //     final ColorController colorController = Get.find<ColorController>();
  //       ColorModel? SelectedColor;
  // int SelectedColorId = 0;
  TextEditingController Product_Cost = TextEditingController();
  // TextEditingController Product_LPrice= TextEditingController();
  // TextEditingController Product_MPrice= TextEditingController();

  TextEditingController Product_Quantity = TextEditingController();
  void refresh() {
    productDetailController.isDataFetched = false;
    productDetailController.fetchproductdetails();
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Row(
        children: [
          Expanded(
              child: Text(
            'Add Purchase of $Product_Name',
            style: TextStyle(fontSize: 17),
          ))
        ],
      )),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  readOnly: true,
                  //  maxLength: 50,
                  initialValue: Product_Name,
                  keyboardType: TextInputType.name,
                  //controller: Product_Name,
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  //   maxLength: 50,
                  initialValue: Product_Code,
                  keyboardType: TextInputType.name,
                  //controller: Product_Name,
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
                ),
                // SizedBox(height: 20,),
                //  Obx(
                //         () => colorController.colors.isEmpty
                //             ? Center(
                //                 child: Column(
                //                   children: [
                //                     // Text('Fetching Rate! Please Wait'),
                //                     CircularProgressIndicator(),
                //                   ],
                //                 ),
                //               )
                //             : DropdownButtonFormField<ColorModel>(
                //                 decoration: InputDecoration(
                //                   labelText: "Colors",
                //                   labelStyle: TextStyle(
                //                     color: Colors.black,
                //                   ),
                //                   fillColor: Colors.black,
                //                   focusedBorder: OutlineInputBorder(
                //                     borderRadius: BorderRadius.circular(15.0),
                //                     borderSide: BorderSide(
                //                       color: Colors.black,
                //                     ),
                //                   ),
                //                   enabledBorder: OutlineInputBorder(
                //                     borderRadius: BorderRadius.circular(15.0),
                //                     borderSide: BorderSide(
                //                       color: Colors.black,
                //                       width: 2.0,
                //                     ),
                //                   ),
                //                 ),
                //                 iconDisabledColor: Colors.deepPurple.shade300,
                //                 iconEnabledColor: Colors.deepPurple.shade300,
                //                 //  value: categoryController.category.first,
                //                 onChanged: (ColorModel? value) {
                //                     SelectedColor = value;
                //                     SelectedColorId = (SelectedColor?.Color_id)!;
                //                 },
                //                 items: colorController.colors
                //                     .map((color) => DropdownMenuItem<ColorModel>(
                //                           value: color,
                //                           child: Text(color.Color),
                //                         ))
                //                     .toList(),
                //               ),
                //       ),
                SizedBox(
                  height: 20,
                ),

                Container(
                  width: double.infinity,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Prices',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              //   maxLength: 50,
                              //   initialValue: Product_Code,
                              keyboardType: TextInputType.number,
                              initialValue: Product_LPrice,
                              decoration: InputDecoration(
                                labelText: "Lowest Price ",
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
                              readOnly: true,
                              //   maxLength: 50,
                              //   initialValue: Product_Code,
                              keyboardType: TextInputType.number,
                              initialValue: Product_MPrice,
                              decoration: InputDecoration(
                                labelText: "Max Price ",
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
                  height: 20,
                ),
                TextFormField(
                  readOnly: false,
                  //   maxLength: 50,
                  //   initialValue: Product_Code,
                  keyboardType: TextInputType.number,
                  controller: Product_Quantity,
                  decoration: InputDecoration(
                    labelText: "Product Quantity ",
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
              ],
            ),
            Column(
              children: [
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
                      if (Product_Quantity.text == '') {
                        showToast('Please Add Quantity');
                      } else if (double.tryParse(Product_Quantity.text)! == 0) {
                        showToast('Please Increase Quantity');
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
                        insertProductDetailController.UploadProductDetails(
                                Product_id,
                                Product_Quantity.text,
                                Product_LPrice,
                                Product_MPrice)
                            .then((value) => Navigator.of(context).pop())
                            .then((value) => refresh())
                            .then((value) =>
                                showToast(insertProductDetailController.result))
                            .then((value) => Navigator.of(context).pop());
                      }
                      // if(idController.text != '' && nameController.text != '' && nameController.text !='') {

                      //    showDialog(
                      //         // The user CANNOT close this dialog  by pressing outsite it
                      //         barrierDismissible: false,
                      //         context: context,
                      //         builder: (_) {
                      //           return Dialog(
                      //             // The background color
                      //             backgroundColor: Colors.white,
                      //             child: Padding(
                      //               padding:
                      //                   const EdgeInsets.symmetric(vertical: 20),
                      //               child: Column(
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   // The loading indicator
                      //                   CircularProgressIndicator(),
                      //                   SizedBox(
                      //                     height: 15,
                      //                   ),
                      //                   // Some text
                      //                   Text('Loading')
                      //                 ],
                      //               ),
                      //             ),
                      //           );
                      //         });
                      // buyPhoneController.UploadPhone(int.tryParse(idController.text)!,numberController.text,nameController.text,SelectedBrandId,SelectedPhoneId,SelectedColorId, Condition,   SelectedCapacity, Imei.text, Note.text, Price.text) .then((value) => Navigator.of(context).pop()).then((value) => null)
                      //         .then((value) =>
                      //             showToast(buyPhoneController.result)).then((value) => NavOut());
                      // }
                      // else if(SelectedBrandId == 0) {
                      //   showToast('Please Select Brand !');
                      // } else if (SelectedPhoneId == 0) {
                      //    showToast('Please Select Phone Model !');
                      // }else if(SelectedCapacity == '') {
                      //   showToast('Please Select Capacity !');
                      // }  else if(SelectedColorId == 0) {
                      //   showToast('Please Select Color !');
                      // } else if (Imei.text == '') {
                      //   showToast('Please Add Imei');
                      // } else if(Price.text == '') {
                      //   showToast('Please Add Price');
                      // }

                      // else {
                      //   showToast('Please Add Customer!');
                      // }
                    },
                    child: Text(
                      'Submit Purchase',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
