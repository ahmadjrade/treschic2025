import 'package:get/get.dart';

class RechargeHistoryModel {
  final int Rinvoice_detail_id;

  final int Recharge_invoice_id;
  final int Store_id;
  final int Card_id;
  final String Card_Name;
  final int Card_Amount;
  final int Card_Qty;

  RxDouble _Card_UP;
  RxDouble _Card_TP;

  RechargeHistoryModel({
    required this.Rinvoice_detail_id,
    required this.Recharge_invoice_id,
    required this.Store_id,
    required this.Card_id,
    required this.Card_Name,
    required this.Card_Amount,
    required this.Card_Qty,
    required double Card_UP, // Change type to double
    required double Card_TP, // Change type to double
  })  : _Card_TP = Card_TP.obs,
        _Card_UP = Card_TP.obs; // Initialize RxDouble

  double get Card_TP => _Card_TP.value; // Getter for product_MPrice

  set Card_TP(double value) => _Card_TP.value = value;

  double get Card_UP => _Card_UP.value; // Getter for product_MPrice

  set Card_UP(double value) => _Card_UP.value = value;

  factory RechargeHistoryModel.fromJson(Map<String, dynamic> json) {
    return RechargeHistoryModel(
      Rinvoice_detail_id: json['Rinvoice_detail_id'],
      Recharge_invoice_id: json['Recharge_invoice_id'],
      Store_id: json['Store_id'],
      Card_id: json['Card_id'],
      Card_Name: json['Card_Name'],
      Card_Amount: json['Card_Amount'],
      Card_Qty: json['Card_Qty'],
      Card_UP: json['Card_UP'].toDouble(),
      Card_TP: json['Card_TP'].toDouble(),
    );
  }
}
