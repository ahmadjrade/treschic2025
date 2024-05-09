class SupplierModel {
  final int Supplier_id;
  final String Supplier_Name;
    final String Supplier_Number;



  SupplierModel({
    required this.Supplier_id,
    required this.Supplier_Name,
        required this.Supplier_Number,

  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      Supplier_id: json['Supplier_id'],
      Supplier_Name: json['Supplier_Name'],
            Supplier_Number: json['Supplier_Number'],

    );
  }
}
