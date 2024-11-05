// ignore_for_file: empty_constructor_bodies

import 'dart:ffi';

import 'package:get/get.dart';

class InvoiceModel {
  final int Invoice_id;
  final int Invoice_Store;
  final double Invoice_Total_Usd;
  final double Invoice_Total_Lb;
  final double Invoice_Rec_Usd;
  final double Invoice_Rec_Lb;
  final double Invoice_Due_USD;
  final double Invoice_Due_LB;
  final String Invoice_Date;
  final int? Cus_id;
  final String? Cus_Name;
  final String? Cus_Number;
  final String Invoice_Time;
  final int isPaid;
  final String? Invoice_Type;
  final String Username;
  final double Inv_Rate;
  final int Invoice_Month;
  final int? Driver_id;
  final String? Driver_Name;
  final String? Driver_Number;

  // RxDouble _product_MPrice; // Use RxDouble for reactive price
  // final int Product_Cat_id;
  // final int Product_Sub_Cat_id;
  // final String? imageUrl;

  // RxInt quantity;

  InvoiceModel({
    required this.Invoice_id,
    required this.Invoice_Store,
    required this.Invoice_Total_Usd,
    required this.Invoice_Total_Lb,
    required this.Invoice_Rec_Usd,
    required this.Invoice_Rec_Lb,
    required this.Invoice_Due_USD,
    required this.Invoice_Due_LB,
    required this.Invoice_Date,
    required this.Cus_id,
    required this.Cus_Name,
    required this.Cus_Number,
    required this.Invoice_Time,
    required this.isPaid,
    required this.Invoice_Type,
    required this.Username,
    required this.Inv_Rate,
    required this.Invoice_Month,
    required this.Driver_id,
    required this.Driver_Name,
    required this.Driver_Number,
  });
  // :
  //  _product_MPrice = Product_MPrice.obs; // Initialize RxDouble

  // double get product_MPrice =>
  //     _product_MPrice.value; // Getter for product_MPrice

  // set product_MPrice(double value) =>
  //     _product_MPrice.value = value; // Setter for product_MPrice

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      Invoice_id: json['Invoice_id'],
      Invoice_Store: json['Invoice_Store'],
      Invoice_Total_Usd: json['Invoice_Total_Usd'].toDouble(),
      Invoice_Total_Lb: json['Invoice_Total_Lb'].toDouble(),
      Invoice_Rec_Usd: json['Invoice_Rec_Usd'].toDouble(),
      Invoice_Rec_Lb: json['Invoice_Rec_Lb'].toDouble(),
      Invoice_Due_USD: json['Invoice_Due_USD'].toDouble(),
      Invoice_Due_LB: json['Invoice_Due_LB'].toDouble(),
      Invoice_Date: json['Invoice_Date'],
      Cus_id: json['Cus_id'],
      Cus_Name: json['Cus_Name'],
      Cus_Number: json['Cus_Number'],
      Invoice_Time: json['Invoice_Time'],
      isPaid: json['isPaid'],
      Invoice_Type: json['Invoice_Type'],
      Username: json['Username'],
      Inv_Rate: json['Inv_Rate'].toDouble(),
      Invoice_Month: json['Invoice_Month'],
      Driver_id: json['Driver_id'],
      Driver_Name: json['Driver_Name'],
      Driver_Number: json['Driver_Number'],
    );
  }
}
