class SubCategoryModel {
  final int SCat_id;
  final String SCat_Name;
  final int Cat_id;

  SubCategoryModel({
    required this.SCat_id,
    required this.SCat_Name,
    required this.Cat_id,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      SCat_id: json['Sub_Cat_id'],
      SCat_Name: json['Sub_Cat_Name'],
      Cat_id: json['Cat_id'],
    );
  }
}
