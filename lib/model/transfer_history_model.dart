// ignore_for_file: empty_constructor_bodies

import 'dart:ffi';

import 'package:get/get.dart';

class TransferHistoryModel {
  final int Transfer_id;
  final String Transfer_FStore_Name;
  final String Transfer_TStore_Name;
  final int Item_Count;
  final String Transfer_Date;
  final String Transfer_Time;
  final int Transfer_FStore;
  final int Transfer_TStore;
  final String Username;
  final String RUsername;
  final int month;

  // RxDouble _product_MPrice; // Use RxDouble for reactive price
  // final int Product_Cat_id;
  // final int Product_Sub_Cat_id;
  // final String? imageUrl;

  // RxInt quantity;

  TransferHistoryModel({
    required this.Transfer_id,
    required this.Transfer_FStore_Name,
    required this.Transfer_TStore_Name,
    required this.Item_Count,
    required this.Transfer_Date,
    required this.Transfer_Time,
    required this.Transfer_FStore,
    required this.Transfer_TStore,
    required this.Username,
    required this.RUsername,
    required this.month,
  });
  // :
  //  _product_MPrice = Product_MPrice.obs; // Initialize RxDouble

  // double get product_MPrice =>
  //     _product_MPrice.value; // Getter for product_MPrice

  // set product_MPrice(double value) =>
  //     _product_MPrice.value = value; // Setter for product_MPrice

  factory TransferHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransferHistoryModel(
      Transfer_id: json['Transfer_id'],
      Transfer_FStore_Name: json['Transfer_FStore_Name'],
      Transfer_TStore_Name: json['Transfer_TStore_Name'],
      Item_Count: json['Item_Count'],
      Transfer_Date: json['Transfer_Date'],
      Transfer_Time: json['Transfer_Time'],
      Transfer_FStore: json['Transfer_FStore'],
      Transfer_TStore: json['Transfer_TStore'],
      Username: json['Username'],
      RUsername: json['RUsername'],
      month: json['month'],
    );
  }
}
