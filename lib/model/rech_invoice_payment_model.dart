import 'package:get/get.dart';

class RechInvoicePaymentModel {
  final int Recharge_Payment_id;
  final int Recharge_Invoice_id;
  final int Store_id;
  final double Ammount;
  final String Payment_Date;
  final String Payment_Time;
 
    final String Invoice_Date;
  final String Cus_Name;
  final String Cus_Number;
    final String Username;
    final int Payment_Month;



  RechInvoicePaymentModel({
    required this.Recharge_Payment_id,
    required this.Recharge_Invoice_id,
    required this.Store_id,
    required this.Ammount,
    required this.Payment_Date,
    required this.Payment_Time,
  

    required this.Invoice_Date,  
      required this.Cus_Name,
    required this.Cus_Number,
    required this.Username,
    required this.Payment_Month,

  }) ;
  factory RechInvoicePaymentModel.fromJson(Map<String, dynamic> json) {
    return RechInvoicePaymentModel(
      Recharge_Payment_id: json['Recharge_Payment_id'],
      Recharge_Invoice_id: json['Recharge_Invoice_id'],
      Store_id: json['Store_id'],
      Ammount: json['Ammount'].toDouble(),
      Payment_Date: json['Payment_Date'],
      Payment_Time: json['Payment_Time'],
      Invoice_Date: json['Invoice_Date'],
       Cus_Name: json['Cus_Name'],
      Cus_Number: json['Cus_Number'],
            Username: json['Username'],
            Payment_Month: json['Payment_Month'],

    );
  }
}
