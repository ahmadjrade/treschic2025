import 'package:fixnshop_admin/view/Repairs/add_repair_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RepairDetails extends StatelessWidget {
  String Repair_id, Cus_id, Cus_Name, Cus_Number, Rec_usd, Total_usd, Phone;
  RepairDetails(
      {super.key,
      required this.Repair_id,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number,
      required this.Rec_usd,
      required this.Total_usd,
      required this.Phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Repair #$Repair_id Details | $Phone ',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: false,
                keyboardType: TextInputType.name,
                initialValue: Cus_Name + ' | ' + Cus_Number,
                onChanged: (value) {
                  // New_Name = value;
                },
                //  controller: nameController,
                decoration: InputDecoration(
                  labelText: "Customer ",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: false,
                      initialValue: Total_usd,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // New_Number = value;
                      },
                      //  controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Total Price ",
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
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: false,
                      initialValue: Rec_usd,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // New_Number = value;
                      },
                      //  controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Recieved Money ",
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
              OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 50),
                    backgroundColor: Colors.blue.shade100,
                    side: BorderSide(width: 2.0, color: Colors.blue.shade100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    Get.to(AddRepairItems(Rep_id: Repair_id));
                    // if (Product_Name.text == '') {
                    //   showToast('Please insert Product Name');
                    // } else if (SelectCatId == '') {
                    //   showToast('Select Category');
                    // } else if (SelectSubCatId == '') {
                    //   showToast('Select Sub-Category');
                    // } else if (SelectBrandId == '') {
                    //   showToast('Select Brand');
                    // } else if (SelectedColorId == '') {
                    //   showToast('Select Color');
                    // } else if (barcodeController.barcode.value == '') {
                    //   showToast('Please Add Product Code ');
                    // } else if (Product_MPrice.text == '') {
                    //   showToast('Please Add Max Price');
                    // } else if ((Product_Cost.text) == '') {
                    //   showToast('Please Add Product Cost');
                    // } else if (double.tryParse(Product_MPrice.text)! == 0) {
                    //   showToast('Please Increase Max Price');
                    // } else if (double.tryParse(Product_MPrice.text) ==
                    //     double.tryParse(Product_Cost.text)) {
                    //   showToast('Cost Can\'t Be equal to Max Price');
                    // } else {
                    //   showDialog(
                    //       // The user CANNOT close this dialog  by pressing outsite it
                    //       barrierDismissible: false,
                    //       context: context,
                    //       builder: (_) {
                    //         return Dialog(
                    //           // The background color
                    //           backgroundColor: Colors.white,
                    //           child: Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(vertical: 20),
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 // The loading indicator
                    //                 CircularProgressIndicator(),
                    //                 SizedBox(
                    //                   height: 15,
                    //                 ),
                    //                 // Some text
                    //                 Text('Loading')
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       });
                    //   insertRepairProductController.UploadAcc(
                    //           Product_Name.text,
                    //           SelectCatId,
                    //           SelectSubCatId,
                    //           SelectBrandId,
                    //           Product_Code.text,
                    //           SelectedColorId.toString(),
                    //           Product_Cost.text,
                    //           Product_MPrice.text)
                    //       .then((value) =>
                    //           showToast(insertRepairProductController.result))
                    //       .then((value) =>
                    //           repairProductController.isDataFetched = false)
                    //       .then((value) =>
                    //           repairProductController.fetchproducts())
                    //       .then((value) => Navigator.of(context).pop())
                    //       .then((value) => Navigator.of(context).pop());
                  },
                  child: Text(
                    'Insert Items',
                    style: TextStyle(color: Colors.blue.shade900),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
