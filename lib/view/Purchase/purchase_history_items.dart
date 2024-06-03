import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/purchase_detail_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/model/purchase_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseHistoryItems extends StatelessWidget {
  final String Purchase_id;
  final String Supplier_Name;
  final String Supplier_Number;
  final String purchase_Total_US;
  final String purchase_Rec_US;
  final String purchase_Due_US;

  PurchaseHistoryItems({
    Key? key,
    required this.Purchase_id,
    required this.Supplier_Name,
    required this.Supplier_Number,
    required this.purchase_Total_US,
    required this.purchase_Rec_US,
    required this.purchase_Due_US,
  }) : super(key: key);

  final PurchaseDetailController purchaseDetailController = Get.find<PurchaseDetailController>();
  final SharedPreferencesController sharedPreferencesController = Get.find<SharedPreferencesController>();
  final TextEditingController newQtyController = TextEditingController();
  final RxString username = ''.obs;
    final RxString filter = ''.obs;
  final TextEditingController filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    username.value = sharedPreferencesController.username.value;

    Future<void> showToast(String result) async {
      final snackBar = SnackBar(content: Text(result));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    List<PurchaseHistoryModel> filteredProductDetails() {
      final filterText = filter.value.toLowerCase();
      return purchaseDetailController.purchase_details
          .where((purchaseDetail) =>
              purchaseDetail.Purchase_id == int.tryParse(Purchase_id) &&
              (purchaseDetail.Product_Name.toLowerCase().contains(filterText) ||
               purchaseDetail.Product_Code.toLowerCase().contains(filterText)))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Purchase #$Purchase_id Items'),
            IconButton(
              color: Color.fromRGBO(13, 134, 151, 1),
              iconSize: 24.0,
              onPressed: () {
                // Add navigation to AddProductDetail screen if needed
              },
              icon: Icon(CupertinoIcons.add),
            ),
            IconButton(
              color: Colors.deepPurple,
              iconSize: 24.0,
              onPressed: () {
                purchaseDetailController.isDataFetched = false;
                purchaseDetailController.fetchpurchasedetails();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            SizedBox(height: 25),
            TextFormField(
              initialValue: '$Supplier_Name || $Supplier_Number',
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Supplier",
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '$purchase_Total_US\$',
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Total",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: '$purchase_Rec_US\$',
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Received",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: '$purchase_Due_US\$',
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Due",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: filterController,
              decoration: InputDecoration(
                labelText: "Filter by Name or Code",
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              onChanged: (value) {
                filter.value = value;
              },),
            SizedBox(height: 20),
            Expanded(
              child: Obx(
                () {
                  final List<PurchaseHistoryModel> filteredItems = filteredProductDetails();
                  if (purchaseDetailController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (purchaseDetailController.purchase_details.isEmpty) {
                    return Center(child: Text('No Items Yet! Add Some'));
                  } else {
                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final PurchaseHistoryModel purchase = filteredItems[index];
                        return Container(
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.only(bottom: 10),
                          child: ExpansionTile(
                            collapsedTextColor: Colors.black,
                            textColor: Colors.black,
                            backgroundColor: Colors.deepPurple.shade100,
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${purchase.Product_Quantity} PCS',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  'UP: ${purchase.product_UC}\$',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green.shade900),
                                ),
                              ],
                            ),
                            title: Text(
                              '#${purchase.Purchase_Detail_id} || ${purchase.Product_Name}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: purchaseDetailController.isadmin(username.value),
                                      child: IconButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Update Item Quantity'),
                                                content: TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: newQtyController,
                                                  decoration: InputDecoration(hintText: 'Enter New Quantity'),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (newQtyController.text.isNotEmpty) {
                                                        showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (_) {
                                                            return Dialog(
                                                              backgroundColor: Colors.white,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    CircularProgressIndicator(),
                                                                    SizedBox(height: 15),
                                                                    Text('Loading'),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      //   purchaseDetailController
                                                      //       .updateProductQty(purchase.purchaseDetailId.toString(), newQtyController.text)
                                                      //       .then((value) {
                                                      //     showToast(purchaseDetailController.result2);
                                                      //     purchaseDetailController.isDataFetched = false;
                                                      //     purchaseDetailController.fetchpurchase_details();
                                                      //     Navigator.of(context).pop();
                                                      //     Navigator.of(context).pop();
                                                      //     newQtyController.clear();
                                                      //   });
                                                      // } else {
                                                      //   Get.snackbar('Error', 'Add New Quantity');
                                                      // }
                                                      }
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ),
                                    Text('Product Code: ${purchase.Product_Code}'),
                                    SizedBox(height: 5),
                                    Text('Product Color: ${purchase.Product_Color}'),
                                    SizedBox(height: 5),
                                    Text('Unit Price: ${purchase.product_UC}\$'),
                                    SizedBox(height: 5),
                                    Text('Total Price: ${purchase.product_TC}\$'),
                                    SizedBox(height: 25),
                                  ],
                                ),
                              )
                            ],
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
      ),
    );
  }
}
