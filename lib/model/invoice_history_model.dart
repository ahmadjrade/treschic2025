import 'package:get/get.dart';

class InvoiceHistoryModel {
  final int Invoice_Detail_id;

  final int Invoice_id;
  final int Store_id;
  final int Product_id;
  final String Product_Name;
  final String Product_Code;
  final String Product_Color;
  final int Product_Quantity;

  RxDouble _Product_UP;
  RxDouble _Product_TP;
  final String Invoice_Date;
  final int isPaid;
  final String Username;

  InvoiceHistoryModel({
    required this.Invoice_Detail_id,
    required this.Invoice_id,
    required this.Store_id,
    required this.Product_id,
    required this.Product_Name,
    required this.Product_Code,
    required this.Product_Color,
    required this.Product_Quantity,
    required double product_UP, // Change type to double
    required double product_TP, // Change type to double
    required this.Invoice_Date,  
      required this.isPaid,
      required this.Username,

  })  : _Product_TP = product_TP.obs,
        _Product_UP = product_TP.obs; // Initialize RxDouble

  double get product_TP => _Product_TP.value; // Getter for product_MPrice

  set product_TP(double value) => _Product_TP.value = value;

  double get product_UP => _Product_UP.value; // Getter for product_MPrice

  set product_UP(double value) => _Product_UP.value = value;

  factory InvoiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return InvoiceHistoryModel(
      Invoice_Detail_id: json['Invoice_detail_id'],
      Invoice_id: json['invoice_id'],
      Store_id: json['Store_id'],
      Product_id: json['Product_id'],
      Product_Name: json['Product_Name'],
      Product_Code: json['Product_Code'],
      Product_Color: json['Product_Color'],
      Product_Quantity: json['Product_Qty'],
      product_UP: json['Product_UP'].toDouble(),
      product_TP: json['Product_TP'].toDouble(),
      Invoice_Date: json['Invoice_Date'],
            isPaid: json['isPaid'],
            Username: json['Username'],

    );
  }
}
