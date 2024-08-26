import 'package:get/get.dart';

class ExpensesModel {
  final int Expense_id;
  final int Store_id;
  final String Exp_Cat_Name;
  final String Expense_Desc;
  final double Expense_Value;
  final String Expense_Date;
  final String Expense_Time;
  
    final String Username;
  final int Expense_Month;



  ExpensesModel({
    required this.Expense_id,
    required this.Store_id,
    required this.Exp_Cat_Name,
    required this.Expense_Desc,
    required this.Expense_Value,
    required this.Expense_Date,
        required this.Expense_Time,
      
    required this.Username,
    required this.Expense_Month,

  }) ;
  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
      Expense_id: json['Expense_id'],
      Store_id: json['Store_id'],
      Exp_Cat_Name: json['Exp_Cat_Name'],
      Expense_Desc: json['Expense_Desc'],
      Expense_Value: json['Expense_Value'].toDouble(),
      Expense_Date: json['Expense_Date'],
      Expense_Time: json['Expense_Time'],
           Username: json['Username'],
           Expense_Month: json['Expense_Month'],


    );
  }
}
