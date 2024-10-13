import 'package:get/get.dart';

class TransferDetailsModel {
  final int Transfer_detail_id;

  final int Transfer_id;
  final int Product_id;
  final int Product_Detail_id;

  final String Product_Name;
  final int Product_Qty;

  final String Product_Code;
  final String Product_Color;

  final int from_store;
  final int to_store;
  final String Transfer_FStore_Name;
  final int is_Phone;
  final String Transfer_TStore_Name;

  TransferDetailsModel({
    required this.Transfer_detail_id,
    required this.Transfer_id,
    required this.Product_id,
    required this.Product_Detail_id,
    required this.Product_Name,
    required this.Product_Qty,
    required this.Product_Code,
    required this.Product_Color,
    required this.from_store, // Change type to double
    required this.to_store, // Change type to double
    required this.Transfer_FStore_Name,
    required this.is_Phone,
    required this.Transfer_TStore_Name,
  });
  factory TransferDetailsModel.fromJson(Map<String, dynamic> json) {
    return TransferDetailsModel(
      Transfer_detail_id: json['Transfer_detail_id'],
      Transfer_id: json['Transfer_id'],
      Product_id: json['Product_id'],
      Product_Detail_id: json['Product_Detail_id'],
      Product_Name: json['Product_Name'],
      Product_Qty: json['Product_Qty'],
      Product_Code: json['Product_Code'],
      Product_Color: json['Product_Color'],
      from_store: json['from_store'],
      to_store: json['to_store'],
      Transfer_FStore_Name: json['Transfer_FStore_Name'],
      is_Phone: json['is_Phone'],
      Transfer_TStore_Name: json['Transfer_TStore_Name'],
    );
  }
}
