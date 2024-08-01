class CategoryModel {
  final int Cat_id;
  final String Cat_Name;
  final int Repair_Category;

  CategoryModel({
    required this.Cat_id,
    required this.Cat_Name,
    required this.Repair_Category,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      Cat_id: json['Cat_id'],
      Cat_Name: json['Cat_Name'],
      Repair_Category: json['Repair_Category'],
    );
  }
}
