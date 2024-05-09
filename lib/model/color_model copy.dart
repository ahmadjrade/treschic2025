class ColorModel {
  final int Color_id;
  final String Color;

  ColorModel({
    required this.Color_id,
    required this.Color,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      Color_id: json['Color_id'],
      Color: json['Color'],
    );
  }
}
