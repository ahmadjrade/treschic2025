import 'package:fixnshop_admin/controller/insert_recharge_card.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddRechargeCard extends StatelessWidget {
  int Type_id;
 AddRechargeCard({super.key,required this.Type_id});
    TextEditingController Card_Cost = TextEditingController();

  TextEditingController Card_Name = TextEditingController();
    TextEditingController Card_Price = TextEditingController();
  final InsertRechargeCard insertRechargeCard =
      Get.put(InsertRechargeCard());

        final RechargeCartController rechargeCartController = Get.find<RechargeCartController>();

  @override
  Widget build(BuildContext context) {
    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      appBar: AppBar(title: Text('New Recharge Card'),),
      
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
SizedBox(height: 20,),
              TextFormField(
                          readOnly: false,
                          //   maxLength: 50,
                          //   initialValue: Product_Code,
                          keyboardType: TextInputType.name,
                          controller: Card_Name,
                          decoration: InputDecoration(
                            labelText: "Card Name ",
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
                        ),SizedBox(height: 20,),
                         TextFormField(
                          readOnly: false,
                          //   maxLength: 50,
                          //   initialValue: Product_Code,
                          keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                          // sad        
                         controller: Card_Cost,
                          decoration: InputDecoration(
                            labelText: "Card Cost ",
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
                        SizedBox(height: 20,),
                         TextFormField(
                          readOnly: false,
                          //   maxLength: 50,
                          //   initialValue: Product_Code,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          controller: Card_Price,
                          decoration: InputDecoration(
                            labelText: "Card Price ",
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

            ],),

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
                      insertRechargeCard.UploadCard(
                              Type_id.toString(),
                              Card_Name.text,
                              Card_Cost.text,
                              Card_Price.text,
                             )
                          .then((value) =>
                              showToast(insertRechargeCard.result))
                          .then((value) =>
                              rechargeCartController.isDataFetched = false)
                          .then((value) => rechargeCartController.fetch_recharge_carts())
                          .then((value) => Navigator.of(context).pop())
                                            .then((value) => Navigator.of(context).pop());

                  },
                  child: Text(
                    'Insert Card',
                    style: TextStyle(color: Colors.white),
                  ))
            
          ],
        ),
      )),
    );
  }
}