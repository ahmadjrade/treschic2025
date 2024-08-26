import 'package:get/get.dart';

class PurchasePaymentModel {
  final int Purchase_Payment_id;
  final int Purchase_id;
  final int Store_id;
  final double Ammount;
  final String Payment_Date;
  final String Payment_Time;
  final double Old_Due;
  final double New_Due;
  final String Purchase_Date;
  final String Supplier_Name;
  final String Supplier_Number;
  final String Username;
  final int Payment_Month;



  PurchasePaymentModel({
    required this.Purchase_Payment_id,
    required this.Purchase_id,
    required this.Store_id,
    required this.Ammount,
    required this.Payment_Date,
    required this.Payment_Time,
    required this.Old_Due,
    required this.New_Due,
    required this.Purchase_Date,  
    required this.Supplier_Name,
    required this.Supplier_Number,
    required this.Username,
    required this.Payment_Month,

  }) ;
  factory PurchasePaymentModel.fromJson(Map<String, dynamic> json) {
    return PurchasePaymentModel(
      Purchase_Payment_id: json['Purchase_Payment_id'],
      Purchase_id: json['Purchase_id'],
      Store_id: json['Store_id'],
      Ammount: json['Ammount'].toDouble(),
      Payment_Date: json['Payment_Date'],
      Payment_Time: json['Payment_Time'],
      Old_Due: json['Old_Due'].toDouble(),
      New_Due: json['New_Due'].toDouble(),
      Purchase_Date: json['Purchase_Date'],
      Supplier_Name: json['Supplier_Name'],
      Supplier_Number: json['Supplier_Number'],
      Username: json['Username'],
      Payment_Month: json['Payment_Month'],

    );
  }
}
