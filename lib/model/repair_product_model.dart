import 'dart:ffi';

import 'package:get/get.dart';

class RepairProductModel {
  final int Repair_p_id;
  final String Repair_p_name;
  final String Cat_Name;
  final String Sub_Cat_Name;
  final String Color;
  final String Brand_Name;

  RxDouble _Repair_p_cost;

  RxDouble _Repair_p_price; // Use RxDouble for reactive price

  String Repair_p_code;

  RxInt quantity;

  RepairProductModel({
    required this.Repair_p_id,
    required this.Repair_p_name,
    required this.Cat_Name,
    required this.Sub_Cat_Name,
    required this.Color,
    required this.Brand_Name,
    required double Repair_p_cost,
    required double Repair_p_price,
    required this.Repair_p_code,
    required this.quantity,
  })  : _Repair_p_cost = Repair_p_cost.obs,
        _Repair_p_price = Repair_p_price.obs; // Initialize RxDouble

  double get Repair_p_price =>
      _Repair_p_price.value; // Getter for product_MPrice

  set Repair_p_price(double value) =>
      _Repair_p_price.value = value; // Setter for product_MPrice

  double get Repair_p_cost => _Repair_p_cost.value; // Getter for product_MPrice

  set Repair_p_cost(double value) => _Repair_p_cost.value = value;

  factory RepairProductModel.fromJson(Map<String, dynamic> json) {
    return RepairProductModel(
        Repair_p_id: json['Repair_p_id'],
        Repair_p_name: json['Repair_p_name'],
        Cat_Name: json['Cat_Name'],
        Sub_Cat_Name: json['Sub_Cat_Name'],
        Color: json['Color'],
        Brand_Name: json['Brand_Name'],
        Repair_p_cost: json['Repair_p_cost'].toDouble(),
        Repair_p_price: json['Repair_p_price'].toDouble(),
        // Convert to double
        Repair_p_code: json['Repair_p_code'],
        quantity: 1.obs);
  }
}
