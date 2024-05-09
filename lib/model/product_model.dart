import 'dart:ffi';

import 'package:get/get.dart';

class ProductModel {
  final int Product_id;
  final String Product_Name;
  final String Product_Brand;
  final String Product_Cat;
  final String PRoduct_Sub_Cat;
  final String Product_Code;
  final String Product_Color;
  RxDouble _product_Cost;

  final double Product_LPrice;
  RxDouble _product_MPrice; // Use RxDouble for reactive price
  final int Product_Cat_id;
  final int Product_Sub_Cat_id;
  final String? imageUrl;

  RxInt quantity;

  ProductModel({
    required this.Product_id,
    required this.Product_Name,
    required this.Product_Brand,
    required this.Product_Cat,
    required this.PRoduct_Sub_Cat,
    required this.Product_Code,
    required this.Product_Color,
    required double Product_Cost,
    required this.Product_LPrice,
    required double Product_MPrice, // Change type to double
    required this.Product_Cat_id,
    required this.Product_Sub_Cat_id,
    required this.imageUrl,
    required this.quantity,
  })  : _product_MPrice = Product_MPrice.obs,
        _product_Cost = Product_Cost.obs; // Initialize RxDouble

  double get product_MPrice =>
      _product_MPrice.value; // Getter for product_MPrice

  set product_MPrice(double value) =>
      _product_MPrice.value = value; // Setter for product_MPrice
  double get product_Cost => _product_Cost.value; // Getter for product_MPrice

  set product_Cost(double value) => _product_Cost.value = value;
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        Product_id: json['Product_id'],
        Product_Name: json['Product_Name'],
        Product_Brand: json['Product_Brand'],
        Product_Cat: json['Product_Cat'],
        PRoduct_Sub_Cat: json['Product_Sub_Cat'],
        Product_Code: json['Product_Code'],
        Product_Color: json['Product_Color'],
        Product_Cost: json['Product_Cost'].toDouble(),
        Product_LPrice: json['Product_LPrice'].toDouble(),
        Product_MPrice: json['Product_MPrice'].toDouble(), // Convert to double
        Product_Cat_id: json['Product_Cat_id'],
        Product_Sub_Cat_id: json['Product_Sub_Cat_id'],
        quantity: 1.obs,
        imageUrl: json['Product_Image']);
  }
}
