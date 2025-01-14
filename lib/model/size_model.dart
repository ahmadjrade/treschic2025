class SizeModel {
  final int Size_id;
  final String Size;
  final String Shortcut;

  SizeModel({
    required this.Size_id,
    required this.Size,
    required this.Shortcut,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      Size_id: json['Size_id'],
      Size: json['Size'],
      Shortcut: json['Shortcut'],
    );
  }
}
