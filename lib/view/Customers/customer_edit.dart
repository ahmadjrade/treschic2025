import 'package:fixnshop_admin/controller/customer_address_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/model/customer_address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerEdit extends StatelessWidget {
  String Cus_id, Cus_Name, Cus_Number;
  CustomerEdit(
      {super.key,
      required this.Cus_id,
      required this.Cus_Name,
      required this.Cus_Number});
  final CustomerController customerController = Get.find<CustomerController>();
  final CustomerAddressController customerAddressController =
      Get.find<CustomerAddressController>();
  TextEditingController Cus_Address = TextEditingController();

  String New_Name = '';
  String New_Number = '';
  @override
  Widget build(BuildContext context) {
    New_Name = Cus_Name;
    New_Number = Cus_Number;
    if (customerAddressController.address.isEmpty) {
      customerAddressController.fetch_addresses();
      // print(Cus_id);
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    List<CustomerAddressModel> filteredProductDetails() {
      return customerAddressController.address
          .where((address) => address.Cus_id.toString() == (Cus_id))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Customer Edit'),
            IconButton(
              color: Colors.deepPurple,
              iconSize: 24.0,
              onPressed: () {
                customerAddressController.isDataFetched = false;
                customerAddressController.fetch_addresses();
                // categoryController.isDataFetched =false;
                // categoryController.fetchcategories();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
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
                initialValue: Cus_Name,
                onChanged: (value) {
                  New_Name = value;
                },
                //  controller: nameController,
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: false,
                initialValue: Cus_Number,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  New_Number = value;
                },
                //  controller: nameController,
                decoration: InputDecoration(
                  labelText: "Customer Number ",
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
              OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    //fixedSize: Size(200, 20),
                    backgroundColor: Colors.green.shade100,
                    side: BorderSide(
                      width: 2.0,
                      color: Colors.green.shade900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    if (New_Name != '') {
                      if (New_Number != '') {
                        if (New_Number.length < 8) {
                          showToast('Customer Number is short');
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
                          customerController.UpdateCustomer(
                                  Cus_id, New_Name, New_Number)
                              .then((value) =>
                                  showToast(customerController.Update_result))
                              .then((value) =>
                                  customerController.isDataFetched = false)
                              .then((value) =>
                                  customerController.fetchcustomers())
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => Navigator.of(context).pop());

                          Cus_Address.clear();
                        }
                      } else {
                        showToast('Number Can\'t Be empty');
                      }
                    } else {
                      showToast('Name Can\'t Be empty');
                    }
                  },

                  // Do something with the text, e.g., save it
                  //  String enteredText = _textEditingController.text;
                  //  print('Entered text: $enteredText');
                  // Close the dialog

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update Customer',
                        style: TextStyle(color: Colors.green.shade900),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.edit_attributes, color: Colors.green.shade900
                          //   style: TextStyle(
                          //        color: Colors.red),
                          ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 10,
                  color: Colors.black,
                ),
              ),
              OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    //fixedSize: Size(200, 20),
                    backgroundColor: Colors.green.shade100,
                    side: BorderSide(
                      width: 2.0,
                      color: Colors.green.shade900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Write The Address'),
                          content: TextField(
                            maxLines: 10,
                            keyboardType: TextInputType.text,
                            controller: Cus_Address,
                            decoration: InputDecoration(hintText: 'Address'),
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
                                if (Cus_Address.text != '') {
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
                                  customerController.InsertAddress(
                                          Cus_id, Cus_Address.text)
                                      .then((value) => showToast(
                                          customerController.address_result))
                                      .then((value) => customerAddressController
                                          .isDataFetched = false)
                                      .then((value) => customerAddressController
                                          .fetch_addresses())
                                      .then((value) =>
                                          Navigator.of(context).pop())
                                      .then((value) =>
                                          Navigator.of(context).pop());

                                  Cus_Address.clear();
                                } else {
                                  Get.snackbar(
                                      'Error', 'Address Can\'t Be Empty!');
                                }

                                // Do something with the text, e.g., save it
                                //  String enteredText = _textEditingController.text;
                                //  print('Entered text: $enteredText');
                                // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New Address',
                        style: TextStyle(color: Colors.green.shade900),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.location_on, color: Colors.green.shade900
                          //  'Details',
                          //   style: TextStyle(
                          //        color: Colors.red),
                          ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  final List<CustomerAddressModel> filteredAddress =
                      filteredProductDetails();
                  if (customerAddressController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (filteredAddress.isEmpty) {
                    return Center(child: Text('No Address Yet ! Add Some'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredAddress.length,
                      itemBuilder: (context, index) {
                        final CustomerAddressModel address =
                            filteredAddress[index];
                        return Container(
                          //color: Colors.grey.shade200,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          //     padding: EdgeInsets.all(35),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //   color: Colors.grey.shade500,
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                // collapsedTextColor: Colors.black,
                                // textColor: Colors.black,
                                // backgroundColor: Colors.deepPurple.shade100,
                                //   collapsedBackgroundColor: Colors.white,

                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Address: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Expanded(
                                          child: Text(
                                            address.Address,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  'Date Addedd: ' + address.Date_added,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.black),
                                ),
                                trailing: IconButton(
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
                                                  const EdgeInsets.symmetric(
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
                                    customerAddressController.DeleteAddress(
                                            address.Address_id.toString())
                                        .then((value) => showToast(
                                            customerAddressController.result2))
                                        .then((value) =>
                                            Navigator.of(context).pop())
                                        .then((value) =>
                                            customerAddressController
                                                .isDataFetched = false)
                                        .then((value) =>
                                            customerAddressController
                                                .fetch_addresses());
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                // controlAffinity: ListTileControlAffinity.leading,
                                // children: <Widget>[
                                //   Padding(
                                //     padding:
                                //         const EdgeInsets.symmetric(horizontal: 0.0),
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceAround,
                                //       children: [
                                //         Visibility(
                                //           visible: customerAddressController
                                //               .isadmin(Username.value),
                                //           child: IconButton(
                                //               color: Colors.red,
                                //               onPressed: () {
                                //                 showDialog(
                                //                   context: context,
                                //                   builder: (BuildContext context) {
                                //                     return AlertDialog(
                                //                       title: Text(
                                //                           'Update Item Quantity'),
                                //                       content: TextField(
                                //                         keyboardType:
                                //                             TextInputType.number,
                                //                         controller: New_Qty,
                                //                         decoration: InputDecoration(
                                //                             hintText:
                                //                                 'Enter New Quantity'),
                                //                       ),
                                //                       actions: <Widget>[
                                //                         TextButton(
                                //                           onPressed: () {
                                //                             Navigator.of(context)
                                //                                 .pop();
                                //                           },
                                //                           child: Text('Cancel'),
                                //                         ),
                                //                         TextButton(
                                //                           onPressed: () {
                                //                             if (New_Qty.text !=
                                //                                 '') {
                                //                               showDialog(
                                //                                   // The user CANNOT close this dialog  by pressing outsite it
                                //                                   barrierDismissible:
                                //                                       false,
                                //                                   context: context,
                                //                                   builder: (_) {
                                //                                     return Dialog(
                                //                                       // The background color
                                //                                       backgroundColor:
                                //                                           Colors
                                //                                               .white,
                                //                                       child:
                                //                                           Padding(
                                //                                         padding: const EdgeInsets
                                //                                             .symmetric(
                                //                                             vertical:
                                //                                                 20),
                                //                                         child:
                                //                                             Column(
                                //                                           mainAxisSize:
                                //                                               MainAxisSize
                                //                                                   .min,
                                //                                           children: [
                                //                                             // The loading indicator
                                //                                             CircularProgressIndicator(),
                                //                                             SizedBox(
                                //                                               height:
                                //                                                   15,
                                //                                             ),
                                //                                             // Some text
                                //                                             Text(
                                //                                                 'Loading')
                                //                                           ],
                                //                                         ),
                                //                                       ),
                                //                                     );
                                //                                   });
                                //                               customerAddressController.UpdateProductQty(
                                //                                       address.PD_id
                                //                                           .toString(),
                                //                                       New_Qty.text)
                                //                                   .then((value) => showToast(
                                //                                       customerAddressController
                                //                                           .result2))
                                //                                   .then((value) =>
                                //                                       customerAddressController
                                //                                               .isDataFetched =
                                //                                           false)
                                //                                   .then((value) =>
                                //                                       customerAddressController
                                //                                           .fetchproductdetails())
                                //                                   .then((value) =>
                                //                                       Navigator.of(context)
                                //                                           .pop())
                                //                                   .then((value) =>
                                //                                       Navigator.of(context).pop());

                                //                               New_Qty.clear();
                                //                             } else {
                                //                               Get.snackbar('Error',
                                //                                   'Add New Quantity');
                                //                             }

                                //                             // Do something with the text, e.g., save it
                                //                             //  String enteredText = _textEditingController.text;
                                //                             //  print('Entered text: $enteredText');
                                //                             // Close the dialog
                                //                           },
                                //                           child: Text('OK'),
                                //                         ),
                                //                       ],
                                //                     );
                                //                   },
                                //                 );
                                //               },
                                //               icon: Icon(Icons.edit)),
                                //         ),
                                //         Text('Total Quantity Bought: ' +
                                //             address.Product_Max_Quantity
                                //                 .toString()),
                                //         SizedBox(
                                //           height: 5,
                                //         ),
                                //         Text('Total Quantity Sold: ' +
                                //             address.Product_Sold_Quantity
                                //                 .toString()),
                                //         SizedBox(
                                //           height: 20,
                                //         ),
                                //         // Text('id' + address.PD_id.toString()),
                                //         // SizedBox(
                                //         //   height: 20,
                                //         // ),

                                //         // Text('Total Price of Treatment:  ${treatments.!}\$ '),
                                //       ],
                                //     ),
                                //   )
                                // ],
                                //  subtitle: Text(address.Product_Brand),
                                // trailing: OutlinedButton(
                                //   onPressed: () {

                                //     // productController.SelectedPhone.value = address;
                                //     //       // product_detailsController.selectedproduct_details.value =
                                //     //       //     null;

                                //               Get.to(() => address_History(Balance_id: address.Balance_id.toString(), Product_Name: address.Product_Name,Product_Color: address.Product_Color,));
                                //   },
                                //   child: Text('Select')),
                                // // Add more properties as needed
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
