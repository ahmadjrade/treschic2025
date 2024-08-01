import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            ],
          ),
        ),
      )),
    );
  }
}
