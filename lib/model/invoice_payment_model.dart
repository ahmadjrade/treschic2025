import 'package:get/get.dart';

class InvoicePaymentModel {
  final int Invoice_Payment_id;
  final int Invoice_id;
  final int Store_id;
  final double Ammount;
  final String Payment_Date;
  final String Payment_Time;
  final double Old_Due;
  final double New_Due;
  final int Cus_id;
    final String Invoice_Date;
  final String Cus_Name;
  final String Cus_Number;
    final String Username;
    final int Payment_Month;



  InvoicePaymentModel({
    required this.Invoice_Payment_id,
    required this.Invoice_id,
    required this.Store_id,
    required this.Ammount,
    required this.Payment_Date,
    required this.Payment_Time,
    required this.Old_Due,
        required this.New_Due,
        required this.Cus_id,

    required this.Invoice_Date,  
      required this.Cus_Name,
    required this.Cus_Number,
    required this.Username,
    required this.Payment_Month,

  }) ;
  factory InvoicePaymentModel.fromJson(Map<String, dynamic> json) {
    return InvoicePaymentModel(
      Invoice_Payment_id: json['Invoice_Payment_id'],
      Invoice_id: json['invoice_id'],
      Store_id: json['Store_id'],
      Ammount: json['Ammount'].toDouble(),
      Payment_Date: json['Payment_Date'],
      Payment_Time: json['Payment_Time'],
      Old_Due: json['Old_Due'].toDouble(),
      New_Due: json['New_Due'].toDouble(),
      Cus_id: json['Cus_id'],
      Invoice_Date: json['Invoice_Date'],
       Cus_Name: json['Cus_Name'],
      Cus_Number: json['Cus_Number'],
            Username: json['Username'],
            Payment_Month: json['Payment_Month'],

    );
  }
}
