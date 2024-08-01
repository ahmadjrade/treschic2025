import 'package:get/get.dart';

class CustomerAddressModel {
  final int Address_id;

  final int Cus_id;
  final String Address;
  final String Date_added;

  CustomerAddressModel({
    required this.Address_id,
    required this.Cus_id,
    required this.Address,
    required this.Date_added,

    // Change type to double
  });

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) {
    return CustomerAddressModel(
      Address_id: json['Address_id'],
      Cus_id: json['Cus_id'],
      Address: json['Address'],
      Date_added: json['Date_added'],
    );
  }
}
