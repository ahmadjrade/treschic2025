import 'package:get/get.dart';

class RechargeCartModel {
  final int Card_id;

  final String Card_Name;
  final double Card_Cost;
  final double Card_Price;
  final String? Card_Image;
  final int Card_Type;
  RxInt quantity;

  RechargeCartModel({
    required this.Card_id,
    required this.Card_Name,
    required this.Card_Cost,
    required this.Card_Price,
    required this.Card_Image,
    required this.Card_Type,
    required this.quantity,
    // Change type to double
  });

  factory RechargeCartModel.fromJson(Map<String, dynamic> json) {
    return RechargeCartModel(
      Card_id: json['Card_id'],
      Card_Name: json['Card_Name'],
      Card_Cost: json['Card_Cost'].toDouble(),
      Card_Price: json['Card_Sell'].toDouble(),
      Card_Image: json['Card_Image'],
      Card_Type: json['Card_Type'],
      quantity: 1.obs,
    );
  }
}
