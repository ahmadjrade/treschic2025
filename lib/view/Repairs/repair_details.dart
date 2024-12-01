import 'package:fixnshop_admin/controller/repair_detail_controller.dart';
import 'package:fixnshop_admin/model/repair_details_model.dart';
import 'package:fixnshop_admin/view/Repairs/add_repair_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RepairDetails extends StatefulWidget {
  String Repair_id, Cus_id, Cus_Name, Cus_Number, Rec_usd, Total_usd, Phone;
  int additem;
  RepairDetails(
      {super.key,
      required this.Repair_id,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number,
      required this.Rec_usd,
      required this.Total_usd,
      required this.Phone,
      required this.additem});

  @override
  State<RepairDetails> createState() => _RepairDetailsState();
}

class _RepairDetailsState extends State<RepairDetails> {
  final RepairDetailController repairDetailController =
      Get.find<RepairDetailController>();

  final RxString filter = ''.obs;
  bool canAdd(isadd) {
    if (isadd == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RepairDetailModel> FilteredRepairDetails() {
      final filterText = filter.value.toLowerCase();
      return repairDetailController.repair_details_model
          .where((reapir_detail) =>
              reapir_detail.Repair_id == int.tryParse(widget.Repair_id) &&
              (reapir_detail.RProduct_Name.toLowerCase().contains(filterText) ||
                  reapir_detail.RProduct_Code.toLowerCase()
                      .contains(filterText)))
          .toList();
    }

    // canAdd(widget.additem);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Repair #${widget.Repair_id} Details | ${widget.Phone} ',
              style: TextStyle(fontSize: 15),
            ),
            Container(
              decoration: BoxDecoration(
                //color: Colors.grey.shade500,
                border: Border.all(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                  onPressed: () {
                    repairDetailController.isDataFetched = false;
                    repairDetailController.FetchRepairDetails();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.blue.shade900,
                  )),
            )
          ],
        ),
      ),
      body: SafeArea(
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
              initialValue: widget.Cus_Name + ' | ' + widget.Cus_Number,
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
                    initialValue: widget.Total_usd,
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
                    initialValue: widget.Rec_usd,
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
            Visibility(
              visible: canAdd(widget.additem),
              child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 50),
                    backgroundColor: Colors.blue.shade100,
                    side: BorderSide(width: 2.0, color: Colors.blue.shade900),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => AddRepairItems(
                          Rep_id: widget.Repair_id,
                        ));
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
                    'Add Items',
                    style: TextStyle(color: Colors.blue.shade900),
                  )),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Repair Items ',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Obx(
                () {
                  final List<RepairDetailModel> filtereditems =
                      FilteredRepairDetails();
                  if (repairDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (repairDetailController
                      .repair_details_model.isEmpty) {
                    return Center(child: Text('No Items Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filtereditems.length,
                      itemBuilder: (context, index) {
                        final RepairDetailModel repair = filtereditems[index];
                        return Container(
                          decoration: BoxDecoration(
                            //color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: ListTile(
                            textColor: Colors.black,
                            //   collapsedBackgroundColor: Colors.white,

                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#' +
                                              repair.Repair_detail_id
                                                  .toString() +
                                              ' || ' +
                                              repair.RProduct_Name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          'Product Code: ' +
                                              repair.RProduct_Code,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          'Product Color: ' +
                                              repair.RProduct_Color,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          repair.RProduct_Qty.toString() +
                                              ' PCS',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'UP: ' +
                                              repair.product_UP.toString() +
                                              '\$',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.green.shade900),
                                        ),
                                        Text(
                                          'TP: ' +
                                              repair.product_TP.toString() +
                                              '\$',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.green.shade900),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            //  subtitle: Text(repair.Product_Brand),
                            // trailing: OutlinedButton(
                            //   onPressed: () {

                            //     // productController.SelectedPhone.value = repair;
                            //     //       // product_detailsController.selectedproduct_details.value =
                            //     //       //     null;

                            //               Get.to(() => InvoiceHistoryItems(Invoice_id: repair.Invoice_id.toString(), Customer_Name: repair.Customer_Name,Customer_Number: repair.Customer_Number,));
                            //   },
                            //   child: Text('Select')),
                            // // Add more properties as needed
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
