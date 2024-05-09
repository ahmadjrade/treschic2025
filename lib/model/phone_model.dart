// ignore_for_file: empty_constructor_bodies

import 'dart:ffi';

import 'package:get/get.dart';

class PhoneModel {
  final int Phone_id;
  final String Phone_Name;
  final int Cus_id;
  final String Username;
  final String Cus_Name;
  final String Cus_Number;
  final String Brand_Name;
  final String Color;
  final String Phone_Condition;
  final String Capacity;
  final String IMEI;
  final String Note;
  final int Price;
  final int Sell_Price;
  final int isSold;
  final String Buy_Date;
  final String Buy_Time;
  final int Color_id;
  // RxDouble _product_MPrice; // Use RxDouble for reactive price
  // final int Product_Cat_id;
  // final int Product_Sub_Cat_id;
  // final String? imageUrl;

  // RxInt quantity;

  PhoneModel({
    required this.Phone_id,
    required this.Phone_Name, 
    required this.Cus_id,
    required this.Username,
    required this.Cus_Name,
    required this.Cus_Number,
    required this.Brand_Name,
    required this.Color,
    required this.Phone_Condition,
    required this.Capacity,
    required this.IMEI,
    required this.Note,
    required this.Price,
    required this.Sell_Price,
    required this.isSold,
    required this.Buy_Date,
    required this.Buy_Time,
        required this.Color_id,

  });
  // :
  //  _product_MPrice = Product_MPrice.obs; // Initialize RxDouble

  // double get product_MPrice =>
  //     _product_MPrice.value; // Getter for product_MPrice

  // set product_MPrice(double value) =>
  //     _product_MPrice.value = value; // Setter for product_MPrice

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
        Phone_id: json['Phone_id'],
        Phone_Name: json['Phone_Name'],
        Cus_id: json['Cus_id'],
        Username: json['Username'],
        Cus_Name: json['Cus_Name'],
        Cus_Number: json['Cus_Number'],
        Brand_Name: json['Brand_Name'],
         Color: json['Color'],
        Phone_Condition: json['Phone_Condition'],
        Capacity: json['Capacity'],
        IMEI: json['IMEI'],
        Note: json['Note'],
         Price: json['Price'],
        Sell_Price: json['Sell_Price'],
        isSold: json['isSold'],
        Buy_Date: json['Buy_Date'],
        Buy_Time: json['Buy_Time'], Color_id: json['Color_id'],);
        
  }
}
