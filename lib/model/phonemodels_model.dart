import 'package:get/get.dart';

class PhoneModelsModel {
  final int Phone_Model_id;
  final int Brand_id;
  final String Phone_Name;

  RxString _IMEI;
  RxDouble _Purchase_Price;
  RxInt quantity;
  RxInt _Color_id;
  RxString _Capacity;
  RxString _ColorName; // Add color name as a reactive field

  PhoneModelsModel({
    required this.Phone_Model_id,
    required this.Brand_id,
    required this.Phone_Name,
    required String IMEI,
    required double Purchase_Price,
    required this.quantity,
    required int Color_id,
    required String Capacity,
    required String ColorName, // Add color name in constructor
  })  : _IMEI = IMEI.obs,
        _Purchase_Price = Purchase_Price.obs,
        _Capacity = Capacity.obs,
        _Color_id = Color_id.obs,
        _ColorName = ColorName.obs; // Initialize color name as reactive

  // Getters and setters for the reactive fields
  String get IMEI => _IMEI.value;
  set IMEI(String value) => _IMEI.value = value;

  double get Purchase_Price => _Purchase_Price.value;
  set Purchase_Price(double value) => _Purchase_Price.value = value;

  String get Capacity => _Capacity.value;
  set Capacity(String value) => _Capacity.value = value;

  int get Color_id => _Color_id.value;
  set Color_id(int value) => _Color_id.value = value;

  String get ColorName => _ColorName.value; // Getter for color name
  set ColorName(String value) => _ColorName.value = value; // Setter for color name

  // Method to create a new instance of the same object with updated fields
  PhoneModelsModel copyWith({
    int? Phone_Model_id,
    int? Brand_id,
    String? Phone_Name,
    String? IMEI,
    double? Purchase_Price,
    RxInt? quantity,
    int? Color_id,
    String? Capacity,
    String? ColorName, // Allow updating color name in copyWith
  }) {
    return PhoneModelsModel(
      Phone_Model_id: Phone_Model_id ?? this.Phone_Model_id,
      Brand_id: Brand_id ?? this.Brand_id,
      Phone_Name: Phone_Name ?? this.Phone_Name,
      IMEI: IMEI ?? this.IMEI,
      Purchase_Price: Purchase_Price ?? this.Purchase_Price,
      quantity: quantity ?? this.quantity,
      Color_id: Color_id ?? this.Color_id,
      Capacity: Capacity ?? this.Capacity,
      ColorName: ColorName ?? this.ColorName, // Update color name if provided
    );
  }

  // Factory method to create an instance from a JSON object
  factory PhoneModelsModel.fromJson(Map<String, dynamic> json) {
    return PhoneModelsModel(
      Phone_Model_id: json['Phone_Model_id'],
      Brand_id: json['Brand_id'],
      Phone_Name: json['Phone_Name'],
      IMEI: json['IMEI'] ?? '',
      Purchase_Price: json['Purchase_Price'] ?? 0,
      quantity: RxInt(json['quantity'] ?? 1),
      Capacity: json['Capacity'] ?? '',
      Color_id: json['Color_id'] ?? 0,
      ColorName: json['ColorName'] ?? '', // Parse color name from JSON
    );
  }
}
