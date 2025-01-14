class ColorModel {
  final int Color_id;
  final String Color;
  final String Color_name;

  ColorModel({
    required this.Color_id,
    required this.Color,
    required this.Color_name,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      Color_id: json['Color_id'],
      Color: json['Color'],
      Color_name: json['Color_name'],
    );
  }
}
