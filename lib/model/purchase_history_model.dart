import 'package:get/get.dart';

class PurchaseHistoryModel {
  final int Purchase_Detail_id;

  final int Purchase_id;
  final int Store_id;
  final int Product_id;
  final String Product_Name;
  final String Product_Code;
  final String Product_Color;
  final int Product_Quantity;
 

  RxDouble _Product_UC;
  RxDouble _Product_TC;


  PurchaseHistoryModel({
    required this.Purchase_Detail_id,
    required this.Purchase_id,
    required this.Store_id,
    required this.Product_id,
    required this.Product_Name,
    required this.Product_Code,
    required this.Product_Color,
    required this.Product_Quantity,
    required double product_UC, // Change type to double
    required double product_TC, // Change type to double

    
    
  })  : 
        _Product_TC = product_TC.obs,
        _Product_UC = product_TC.obs; // Initialize RxDouble



  double get product_TC => _Product_TC.value; // Getter for product_MPrice

  set product_TC(double value) => _Product_TC.value = value;

  double get product_UC =>
      _Product_UC.value; // Getter for product_MPrice

  set product_UC(double value) => _Product_UC.value = value;

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryModel(
      Purchase_Detail_id: json['purchase_detail_id'],
      Purchase_id: json['Purchase_id'],
      Store_id: json['Store_id'],
      Product_id: json['Product_id'],
      Product_Name: json['Product_Name'],
      Product_Code: json['Product_Code'],
      Product_Color: json['Product_Color'],
      Product_Quantity: json['Product_Qty'],
      product_UC: json['Product_UC'].toDouble(),

      product_TC: json['Product_TC'].toDouble(),

      
    );
  }
}
