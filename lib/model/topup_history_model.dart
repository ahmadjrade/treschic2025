import 'package:get/get.dart';

class TopupHistoryModel {
  final int Topup_id;

  final int Balance_id;
  final int Store_id;
  final String Date;
  final String Time;
  final double Topup_Ammount;
  final String Username;

  TopupHistoryModel({
    required this.Topup_id,
    required this.Balance_id,
    required this.Store_id,
    required this.Date,
    required this.Time,
    required this.Topup_Ammount,
    required this.Username,
    // Change type to double
  });

  factory TopupHistoryModel.fromJson(Map<String, dynamic> json) {
    return TopupHistoryModel(
      Topup_id: json['Topup_id'],
      Balance_id: json['Balance_id'],
      Store_id: json['Store_id'],
      Date: json['Date'],
      Time: json['Time'],
      Topup_Ammount: json['topup_ammount'].toDouble(),
      Username: json['Username'],
    );
  }
}
