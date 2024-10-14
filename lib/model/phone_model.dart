// ignore_for_file: empty_constructor_bodies

import 'dart:ffi';

import 'package:get/get.dart';

class PhoneModel {
  final int Phone_id;
  final int Phone_Purchase_id;
  final int Store_id;
  final int Brand_id;
  final int Phone_Model_id;
  final String Phone_Name;
  final String Phone_IMEI;
  final int Phone_Color_id;
  final String Phone_Capacity;
  final double Phone_Price;
  final int isSold;
  final double Sell_Price;
  final double Sold_Price;
  final String? Sold_Time;
  final String Color;
  final String Username;
  final String Brand_Name;
  final String Phone_Condition;
  final int? Supplier_id;
  final String? Supplier_Name;
  final String? Supplier_Number;
  final int? Cus_id;
  final String? Cus_Name;
  final String? Cus_Number;
  final String Buy_Date;
  final String Buy_Time;
  final int? Sold_to_id;
  final String? Sold_to_name;
  final String? Sold_to_number;
  // RxDouble _product_MPrice; // Use RxDouble for reactive price
  // final int Product_Cat_id;
  // final int Product_Sub_Cat_id;
  // final String? imageUrl;

  // RxInt quantity;

  PhoneModel({
    required this.Phone_id,
    required this.Phone_Purchase_id,
    required this.Store_id,
    required this.Brand_id,
    required this.Phone_Model_id,
    required this.Phone_Name,
    required this.Phone_IMEI,
    required this.Phone_Color_id,
    required this.Phone_Capacity,
    required this.Phone_Price,
    required this.isSold,
    required this.Sell_Price,
    required this.Sold_Price,
    required this.Sold_Time,
    required this.Color,
    required this.Username,
    required this.Brand_Name,
    required this.Phone_Condition,
    required this.Supplier_id,
    required this.Supplier_Name,
    required this.Supplier_Number,
    required this.Cus_id,
    required this.Cus_Name,
    required this.Cus_Number,
    required this.Buy_Date,
    required this.Buy_Time,
    required this.Sold_to_id,
    required this.Sold_to_name,
    required this.Sold_to_number,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      Phone_id: json['Phone_Purchase_Details_id'],
      Phone_Purchase_id: json['Phone_Purchase_id'],
      Store_id: json['Store_id'],
      Brand_id: json['Brand_id'],
      Phone_Model_id: json['Phone_Model_id'],
      Phone_Name: json['Phone_Name'],
      Phone_IMEI: json['Phone_IMEI'],
      Phone_Color_id: json['Phone_Color_id'],
      Phone_Capacity: json['Phone_Capacity'],
      Phone_Price: json['Phone_Price'].toDouble(),
      isSold: json['isSold'],
      Sell_Price: json['Sell_Price'].toDouble(),
      Sold_Price: json['Sold_Price'].toDouble(),
      Sold_Time: json['Sold_Time'],
      Color: json['Color'],
      Username: json['Username'],
      Brand_Name: json['Brand_Name'],
      Phone_Condition: json['Phone_Condition'],
      Supplier_id: json['Supplier_id'],
      Supplier_Name: json['Supplier_Name'],
      Supplier_Number: json['Supplier_Number'],
      Cus_id: json['Cus_id'],
      Cus_Name: json['Cus_Name'],
      Cus_Number: json['Cus_Number'],
      Buy_Date: json['Purchase_Date'],
      Buy_Time: json['Purchase_Time'],
      Sold_to_id: json['Sold_to_id'],
      Sold_to_name: json['Sold_to_name'],
      Sold_to_number: json['Sold_to_number'],
    );
  }
}
