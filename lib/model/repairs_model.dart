// ignore_for_file: empty_constructor_bodies

import 'dart:ffi';

import 'package:get/get.dart';

class RepairsModel {
  final int Repair_id;
  final int Store_id;
  final int Cus_id;
  final String Cus_Name;
  final String Cus_Number;
  final String Phone_Model;
  final String Phone_Password;
  final String Phone_IMEI;
  final String Phone_Issue;
  final String Repair_Note;
  final double Received_Money;
  final double Repair_Price;
  final double Repair_Cost;
  final String Repair_Rec_Date;
  final String Repair_Rec_Time;
  final String Repair_Status;
  final String Username;

  // RxDouble _product_MPrice; // Use RxDouble for reactive price
  // final int Product_Cat_id;
  // final int Product_Sub_Cat_id;
  // final String? imageUrl;

  // RxInt quantity;

  RepairsModel({
    required this.Repair_id,
    required this.Store_id,
    required this.Cus_id,
    required this.Cus_Name,
    required this.Cus_Number,
    required this.Phone_Model,
    required this.Phone_Password,
    required this.Phone_IMEI,
    required this.Phone_Issue,
    required this.Repair_Note,
    required this.Received_Money,
    required this.Repair_Price,
    required this.Repair_Cost,
    required this.Repair_Rec_Date,
    required this.Repair_Rec_Time,
    required this.Repair_Status,
    required this.Username,
  });
  // :
  //  _product_MPrice = Product_MPrice.obs; // Initialize RxDouble

  // double get product_MPrice =>
  //     _product_MPrice.value; // Getter for product_MPrice

  // set product_MPrice(double value) =>
  //     _product_MPrice.value = value; // Setter for product_MPrice

  factory RepairsModel.fromJson(Map<String, dynamic> json) {
    return RepairsModel(
      Repair_id: json['Repair_id'],
      Store_id: json['Store_id'],
      Cus_id: json['Cus_id'],
      Cus_Name: json['Cus_Name'],
      Cus_Number: json['Cus_Number'],
      Phone_Model: json['Phone_Model'],
      Phone_Password: json['Phone_Password'],
      Phone_IMEI: json['Phone_IMEI'],
      Phone_Issue: json['Phone_Issue'],
      Repair_Note: json['Repair_Note'],
      Received_Money: json['Received_Money'].toDouble(),
      Repair_Price: json['Repair_Price'].toDouble(),
      Repair_Cost: json['Repair_Cost'].toDouble(),
      Repair_Rec_Date: json['Repair_Rec_Date'],
      Repair_Rec_Time: json['Repair_Rec_Time'],
      Repair_Status: json['Repair_Status'],
      Username: json['Username'],
    );
  }
}
