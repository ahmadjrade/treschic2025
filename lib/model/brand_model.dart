class BrandModel {
  final int Brand_id;
  final String Brand_Name;

  BrandModel({
    required this.Brand_id,
    required this.Brand_Name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      Brand_id: json['Brand_id'],
      Brand_Name: json['Brand_Name'],
    );
  }
}
