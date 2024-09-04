import 'package:get/get.dart';

class ImoneyModel {
  final int i_m_id;
  final int Store_id;

  final double dollar_money;
  final double lebanese_money;
  final String date;

  final String Username;

  ImoneyModel({
    required this.i_m_id,
    required this.Store_id,
    required this.dollar_money,
    required this.lebanese_money,
    required this.date,
    required this.Username,
  });
  factory ImoneyModel.fromJson(Map<String, dynamic> json) {
    return ImoneyModel(
      i_m_id: json['i_m_id'],
      Store_id: json['Store_id'],
      dollar_money: json['dollar_money'].toDouble(),
      lebanese_money: json['lebanese_money'].toDouble(),
      date: json['date'],
      Username: json['Username'],
    );
  }
}
