import 'package:get/get.dart';

class RepairDetailModel {
  final int Repair_detail_id;

  final int Repair_id;
  final int Store_id;
  final int RProduct_id;
  final String RProduct_Name;
  final String RProduct_Code;
  final String RProduct_Color;
  final int RProduct_Qty;

  RxDouble _RProduct_UP;
  RxDouble _RProduct_TP;
  RxDouble _RProduct_Cost;
  final String Username;
  final String Repair_Rec_Date;

  RepairDetailModel({
    required this.Repair_detail_id,
    required this.Repair_id,
    required this.Store_id,
    required this.RProduct_id,
    required this.RProduct_Name,
    required this.RProduct_Code,
    required this.RProduct_Color,
    required this.RProduct_Qty,
    required double product_UP, // Change type to double
    required double product_TP, // Change type to double
    required double product_Cost, // Change type to double

    required this.Username,
    required this.Repair_Rec_Date,
  })  : _RProduct_TP = product_TP.obs,
        _RProduct_UP = product_UP.obs,
        _RProduct_Cost = product_Cost.obs; // Initialize RxDouble

  double get product_TP => _RProduct_TP.value; // Getter for product_MPrice

  set product_TP(double value) => _RProduct_TP.value = value;

  double get product_UP => _RProduct_UP.value; // Getter for product_MPrice

  set product_UP(double value) => _RProduct_UP.value = value;

  double get product_Cost => _RProduct_Cost.value; // Getter for product_MPrice

  set product_Cost(double value) => _RProduct_Cost.value = value;

  factory RepairDetailModel.fromJson(Map<String, dynamic> json) {
    return RepairDetailModel(
      Repair_detail_id: json['Repair_detail_id'],
      Repair_id: json['Repair_id'],
      Store_id: json['Store_id'],
      RProduct_id: json['RProduct_id'],
      RProduct_Name: json['RProduct_Name'],
      RProduct_Code: json['RProduct_Code'],
      RProduct_Color: json['RProduct_Color'],
      RProduct_Qty: json['RProduct_Qty'],
      product_UP: json['RProduct_UP'].toDouble(),
      product_TP: json['RProduct_TP'].toDouble(),
      product_Cost: json['RProduct_Cost'].toDouble(),
      Username: json['Username'],
      Repair_Rec_Date: json['Repair_Rec_Date'],
    );
  }
}
