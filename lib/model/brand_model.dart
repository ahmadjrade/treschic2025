class BrandModel {
  final int Brand_id;
  final String Brand_Name;
  final int Repair_Brand;

  BrandModel({
    required this.Brand_id,
    required this.Brand_Name,
    required this.Repair_Brand,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      Brand_id: json['Brand_id'],
      Brand_Name: json['Brand_Name'],
      Repair_Brand: json['Repair_Brand'],
    );
  }
}
