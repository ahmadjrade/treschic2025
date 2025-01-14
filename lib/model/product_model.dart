import 'dart:ffi';

import 'package:get/get.dart';

class ProductModel {
  final int Product_id;
  final String Product_Name;
  final String Product_Brand;
  final String Product_Cat;
  final String PRoduct_Sub_Cat;
  RxString _Product_Code;
  RxDouble _product_Cost;
  final double Product_LPrice;
  RxDouble _product_MPrice; // Use RxDouble for reactive price
  final int Product_Cat_id;
  final int Product_Sub_Cat_id;
  final String? imageUrl;
  RxInt quantity;
  RxInt _Color_id;
  RxInt _Size_id;

  RxString _Size;
  RxString _ColorName;
  RxString _Size_shrt;
  RxString _ColorName_shrt;
  RxString _Main_code;
  RxInt _isVis;
  ProductModel({
    required this.Product_id,
    required this.Product_Name,
    required this.Product_Brand,
    required this.Product_Cat,
    required this.PRoduct_Sub_Cat,
    required String Product_Code,
    required double Product_Cost,
    required this.Product_LPrice,
    required double Product_MPrice, // Change type to double
    required this.Product_Cat_id,
    required this.Product_Sub_Cat_id,
    required this.imageUrl,
    required this.quantity,
    required int Color_id,
    required int Size_id,
    required String Size,
    required String ColorName,
    required String Size_shrt,
    required String ColorName_shrt,
    required String Main_code,
    required int isVis,
  })  : _product_MPrice = Product_MPrice.obs,
        _product_Cost = Product_Cost.obs, // Initialize RxDouble

        _Color_id = Color_id.obs,
        _Size_id = Size_id.obs,
        _Size = Size.obs,
        _ColorName = ColorName.obs,
        _Size_shrt = Size_shrt.obs,
        _ColorName_shrt = ColorName_shrt.obs,
        _Main_code = Main_code.obs,
        _Product_Code = Product_Code.obs,
        _isVis = isVis.obs;

  double get product_MPrice =>
      _product_MPrice.value; // Getter for product_MPrice

  set product_MPrice(double value) =>
      _product_MPrice.value = value; // Setter for product_MPrice
  double get product_Cost => _product_Cost.value;
  set product_Cost(double value) => _product_Cost.value = value;
  // Getter for product_MPrice
  String get Size => _Size.value;
  set Size(String value) => _Size.value = value;
  String get Size_shrt => _Size_shrt.value;
  set Size_shrt(String value) => _Size_shrt.value = value;
  int get Color_id => _Color_id.value;
  set Color_id(int value) => _Color_id.value = value;

  int get Size_id => _Size_id.value;
  set Size_id(int value) => _Size_id.value = value;

  String get ColorName => _ColorName.value; // Getter for color name
  set ColorName(String value) => _ColorName.value = value;

  String get Main_code => _Main_code.value; // Getter for color name
  set Main_code(String value) => _Main_code.value = value;
  String get ColorName_shrt => _ColorName_shrt.value; // Getter for color name
  set ColorName_shrt(String value) => _ColorName_shrt.value = value;
  int get isVis => _isVis.value; // Getter for color name
  set isVis(int value) => _isVis.value = value;

  String get Product_Code => _Product_Code.value; // Getter for color name
  set Product_Code(String value) => _Product_Code.value = value;
  ProductModel copyWith(
      {int? Product_id,
      String? Product_Name,
      String? Product_Brand,
      String? Product_Cat,
      String? PRoduct_Sub_Cat,
      String? Product_Code,
      double? Product_Cost,
      double? Product_LPrice,
      double? Product_MPrice,
      int? Product_Cat_id,
      int? Product_Sub_Cat_id,
      String? imageUrl,
      RxInt? quantity,
      int? Color_id,
      int? Size_id,
      String? Size,
      String? ColorName,
      String? Size_shrt,
      String? ColorName_shrt,
      String? Main_code,
      int? isVis
// Allow updating color name in copyWith
      }) {
    return ProductModel(
      Product_id: Product_id ?? this.Product_id,
      Product_Name: Product_Name ?? this.Product_Name,
      Product_Brand: Product_Brand ?? this.Product_Brand,
      Product_Cat: Product_Cat ?? this.Product_Cat,
      PRoduct_Sub_Cat: PRoduct_Sub_Cat ?? this.PRoduct_Sub_Cat,
      Product_Code: Product_Code ?? this.Product_Code,

      Product_Cost: Product_Cost ?? this.product_Cost,
      Product_LPrice: Product_LPrice ?? this.Product_LPrice,
      Product_MPrice: Product_MPrice ?? this.product_MPrice,
      Product_Cat_id: Product_Cat_id ?? this.Product_Cat_id,

      Product_Sub_Cat_id: Product_Sub_Cat_id ?? this.Product_Sub_Cat_id,
      imageUrl: imageUrl ?? this.imageUrl,

      quantity: quantity ?? this.quantity,
      Color_id: Color_id ?? this.Color_id,
      Size_id: Size_id ?? this.Size_id,

      Size: Size ?? this.Size,
      ColorName: ColorName ?? this.ColorName,
      Size_shrt: Size ?? this.Size_shrt,
      ColorName_shrt: ColorName_shrt ?? this.ColorName_shrt,
      Main_code: Main_code ?? this.Main_code,

      isVis: isVis ?? this.isVis,
// Update color name if provided
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      Product_id: json['Product_id'],
      Product_Name: json['Product_Name'],
      Product_Brand: json['Product_Brand'],
      Product_Cat: json['Product_Cat'],
      PRoduct_Sub_Cat: json['Product_Sub_Cat'],
      Product_Code: json['Product_Code'] ?? '',
      Product_Cost: json['Product_Cost'].toDouble(),
      Product_LPrice: json['Product_LPrice'].toDouble(),
      Product_MPrice: json['Product_MPrice'].toDouble(), // Convert to double
      Product_Cat_id: json['Product_Cat_id'],
      Product_Sub_Cat_id: json['Product_Sub_Cat_id'],
      quantity: 1.obs,
      imageUrl: json['Product_Image'],
      Color_id: json['Color_id'] ?? 0,
      Size_id: json['Size_id'] ?? 0,
      Size: json['Size'] ?? '',

      ColorName: json['ColorName'] ?? '',
      Size_shrt: json['Size_shrt'] ?? '',
      Main_code: json['Main_code'] ?? '',

      ColorName_shrt: json['ColorName_shrt'] ?? '',
      isVis: json['isVis'] ?? 0,
    );
  }
}
