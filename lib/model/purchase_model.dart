// ignore_for_file: empty_constructor_bodies

import 'dart:ffi';

import 'package:get/get.dart';

class PurchaseModel {
  final int Purchase_id;
  final int Purchase_Store;
  final double Purchase_Total_USD;
  final double Purchase_Total_LB;
  final double Purchase_Rec_USD;
  final double Purchase_Rec_LB;
  final double Purchase_Due_USD;
  final double Purchase_Due_LB;
  final String Purchase_Date;
  final int Supplier_id;
  final String? Supplier_Name;
  final String Supplier_Number;
  final String Purchase_Time;
  final int isPaid;

  final String Username;
  final int Month;

  // RxDouble _product_MPrice; // Use RxDouble for reactive price
  // final int Product_Cat_id;
  // final int Product_Sub_Cat_id;
  // final String? imageUrl;

  // RxInt quantity;

  PurchaseModel({
    required this.Purchase_id,
    required this.Purchase_Store,
    required this.Purchase_Total_USD,
    required this.Purchase_Total_LB,
    required this.Purchase_Rec_USD,
    required this.Purchase_Rec_LB,
    required this.Purchase_Due_USD,
    required this.Purchase_Due_LB,
    required this.Purchase_Date,
    required this.Supplier_id,
    required this.Supplier_Name,
    required this.Supplier_Number,
    required this.Purchase_Time,
    required this.isPaid,
    required this.Username,
    required this.Month
  });
  // :
  //  _product_MPrice = Product_MPrice.obs; // Initialize RxDouble

  // double get product_MPrice =>
  //     _product_MPrice.value; // Getter for product_MPrice

  // set product_MPrice(double value) =>
  //     _product_MPrice.value = value; // Setter for product_MPrice

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      Purchase_id: json['Purchase_id'],
      Purchase_Store: json['Purchase_Store'],
      Purchase_Total_USD: json['Purchase_Total_USD'].toDouble(),
      Purchase_Total_LB: json['Purchase_Total_LB'].toDouble(),
      Purchase_Rec_USD: json['Purchase_Rec_USD'].toDouble(),
      Purchase_Rec_LB: json['Purchase_Rec_LB'].toDouble(),
      Purchase_Due_USD: json['Purchase_Due_USD'].toDouble(),
      Purchase_Due_LB: json['Purchase_Due_LB'].toDouble(),
      Purchase_Date: json['Purchase_Date'],
      Supplier_id: json['Supplier_id'],
      Supplier_Name: json['Supplier_Name'],
      Supplier_Number: json['Supplier_Number'],
      Purchase_Time: json['Purchase_Time'],
      isPaid: json['isPaid'],
      Username: json['Username'],  
          Month: json['Month'],

    );
  }
}
