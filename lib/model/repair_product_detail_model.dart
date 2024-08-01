import 'package:get/get.dart';

class RepairProductDetailModel {
  final int R_product_details_id;

  final int R_product_id;
  final String Repair_p_name;
  final String Repair_p_code;
  final String Color;
  final int R_product_quantity;
  final int R_product_max_quantity;
  final int R_product_sold_quantity;
  final String Product_Store;
  final String Username;

  RxDouble _r_product_cost;

  RxDouble _r_product_price;
  RxInt quantity;

  RepairProductDetailModel({
    required this.R_product_details_id,
    required this.R_product_id,
    required this.Repair_p_name,
    required this.Repair_p_code,
    required this.Color,
    required this.R_product_quantity,
    required this.R_product_max_quantity,
    required this.R_product_sold_quantity,
    required double R_product_cost, // Change type to double
    required double R_product_price, // Change type to double

    required this.Product_Store,
    required this.Username,
    required this.quantity,
  })  : _r_product_cost = R_product_cost.obs,
        _r_product_price = R_product_price.obs; // Initialize RxDouble

  double get R_product_price =>
      _r_product_price.value; // Getter for R_product_price

  set R_product_price(double value) =>
      _r_product_price.value = value; // Setter for R_product_price

  double get R_product_cost =>
      _r_product_cost.value; // Getter for R_product_price

  set R_product_cost(double value) => _r_product_cost.value = value;

  factory RepairProductDetailModel.fromJson(Map<String, dynamic> json) {
    return RepairProductDetailModel(
      R_product_details_id: json['R_product_details_id'],

      R_product_id: json['R_product_id'],
      Repair_p_name: json['Repair_p_name'],
      Repair_p_code: json['Repair_p_code'],
      Color: json['Color'],
      R_product_quantity: json['R_product_quantity'],
      R_product_max_quantity: json['R_product_max_quantity'],
      R_product_sold_quantity: json['R_product_sold_quantity'],
      R_product_cost: json['R_product_cost'].toDouble(),

      R_product_price: json['R_product_price'].toDouble(), // Convert to double

      Product_Store: json['Store_Name'],
      Username: json['Username'],
      quantity: 1.obs,
    );
  }
}
