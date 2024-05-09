// ignore_for_file: unnecessary_this

import 'package:get/get.dart';

class InvoiceProductModel {
  final int Product_id;
  final String Product_Name;
  final String Product_Brand;
  final String Product_Cat;
  final String PRoduct_Sub_Cat;
  final String Product_Code;
  final String Product_Color;
  final int Product_LPrice;
  final int Product_MPrice;
  final int Product_Cat_id;
  final int Product_Sub_Cat_id;
  RxDouble price; // Make price observable

  InvoiceProductModel(
      {
      required this.Product_id,
      required this.Product_Name,
      required this.Product_Brand,
      required this.Product_Cat,
      required this.PRoduct_Sub_Cat,
      required this.Product_Code,
      required this.Product_Color,
      required this.Product_LPrice,
      required this.Product_MPrice,
      required this.Product_Cat_id,
      required this.Product_Sub_Cat_id,
      required double price})
      : this.price = price.obs;
}
