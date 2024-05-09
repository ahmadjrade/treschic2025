import 'dart:ffi';

import 'package:get/get.dart';

class CartTypeModel {
  final int Type_id;
  final String Type_Name;
  final String Type_Image;

  CartTypeModel({
    required this.Type_id,
    required this.Type_Name,
    required this.Type_Image,
  }); // Getter for product_MPrice

  factory CartTypeModel.fromJson(Map<String, dynamic> json) {
    return CartTypeModel(
      Type_id: json['Type_id'],
      Type_Name: json['Type_Name'],
      Type_Image: json['Type_Image'],
    );
  }

  get imageUrl => null;
}
