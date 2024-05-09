class PhoneModelsModel {
    final int Phone_Model_id;

  final int Brand_id;
  final String Phone_Name;

  PhoneModelsModel({
        required this.Phone_Model_id,

    required this.Brand_id,
    required this.Phone_Name,
  });

  factory PhoneModelsModel.fromJson(Map<String, dynamic> json) {
    return PhoneModelsModel(
      Phone_Model_id: json['Phone_Model_id'],
      Brand_id: json['Brand_id'],
      Phone_Name: json['Phone_Name'],
    );
  }
}
