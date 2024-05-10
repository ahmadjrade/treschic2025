import 'package:get/get.dart';

class RechargeCartModel {
  final int Cart_id;

  final String Cart_Name;
  final double Cart_Cost;
  final double Cart_Sell;
  final String Cart_Image;
  final int Cart_Type;
  RxInt quantity;

  RechargeCartModel({
    required this.Cart_id,
    required this.Cart_Name,
    required this.Cart_Cost,
    required this.Cart_Sell,
    required this.Cart_Image,
    required this.Cart_Type,
    required this.quantity,
    // Change type to double
  });

  factory RechargeCartModel.fromJson(Map<String, dynamic> json) {
    return RechargeCartModel(
      Cart_id: json['Cart_id'],
      Cart_Name: json['Cart_Name'],
      Cart_Cost: json['Cart_Cost'].toDouble(),
      Cart_Sell: json['Cart_Sell'].toDouble(),
      Cart_Image: json['Cart_Image'],
      Cart_Type: json['Cart_Type'],
      quantity: 1.obs,
    );
  }
}
