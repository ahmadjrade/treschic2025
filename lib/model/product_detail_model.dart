import 'package:get/get.dart';

class ProductDetailModel {
  final int PD_id;

  final int Product_id;
  final String Product_Name;
  final String Product_Code;
  final String Product_Color;
  final int Product_Quantity;
  final int Product_Max_Quantity;
  final int Product_Sold_Quantity;
  final String Product_Store;
  final String Username;

  RxDouble _Product_LPrice;
  RxDouble _product_Cost;

  RxDouble _product_MPrice;
  RxInt quantity;
    final int isPhone;


  ProductDetailModel({
    required this.PD_id,
    required this.Product_id,
    required this.Product_Name,
    required this.Product_Code,
    required this.Product_Color,
    required this.Product_Quantity,
    required this.Product_Max_Quantity,
    required this.Product_Sold_Quantity,
    required double Product_LPrice,
    required double Product_MPrice, // Change type to double
    required double Product_Cost, // Change type to double

    required this.Product_Store,
    required this.Username,
    required this.quantity,
        required this.isPhone,

  })  : _product_MPrice = Product_MPrice.obs,
        _product_Cost = Product_Cost.obs,
        _Product_LPrice = Product_Cost.obs; // Initialize RxDouble

  double get product_MPrice =>
      _product_MPrice.value; // Getter for product_MPrice

  set product_MPrice(double value) =>
      _product_MPrice.value = value; // Setter for product_MPrice

  double get product_Cost => _product_Cost.value; // Getter for product_MPrice

  set product_Cost(double value) => _product_Cost.value = value;

  double get product_LPrice =>
      _Product_LPrice.value; // Getter for product_MPrice

  set product_LPrice(double value) => _Product_LPrice.value = value;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      PD_id: json['PD_id'],

      Product_id: json['Product_id'],
      Product_Name: json['Product_Name'],
      Product_Code: json['Product_Code'],
      Product_Color: json['Product_Color'],
      Product_Quantity: json['Product_Quantity'],
      Product_Max_Quantity: json['Product_Max_Quantity'],
      Product_Sold_Quantity: json['Product_Sold_Quantity'],
      Product_LPrice: json['Product_LPrice'].toDouble(),
      Product_MPrice: json['Product_MPrice'].toDouble(), // Convert to double
      Product_Store: json['Store_Name'],
      Username: json['Username'],
      Product_Cost: json['Product_Cost'].toDouble(),

      quantity: 1.obs,

            isPhone: json['isPhone'],

    );
  }
}
