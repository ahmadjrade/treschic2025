class ExpenseCategoryModel {
  final int Exp_Cat_id;
  final String Exp_Cat_Name;

  ExpenseCategoryModel({
    required this.Exp_Cat_id,
    required this.Exp_Cat_Name,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      Exp_Cat_id: json['Exp_Cat_id'],
      Exp_Cat_Name: json['Exp_Cat_Name'],
    );
  }
}
