import 'dart:ffi';

import 'package:get/get.dart';

class RechargeBalanceModel {
  final int Credit_id;
  final String Credit_Type;
  final double Credit_Balance;
  final double Credit_Price;
  final String Username;
  RechargeBalanceModel({
    required this.Credit_id,
    required this.Credit_Type,
    required this.Credit_Balance,
    required this.Credit_Price,
    required this.Username,
  }); // Getter for product_MPrice

  factory RechargeBalanceModel.fromJson(Map<String, dynamic> json) {
    return RechargeBalanceModel(
      Credit_id: json['Credit_id'],
      Credit_Type: json['Credit_Type'],
      Credit_Balance: json['Credit_Balance'].toDouble(),
      Credit_Price: json['Credit_Price'].toDouble(),
      Username: json['Username'],
    );
  }

  get imageUrl => null;
}
