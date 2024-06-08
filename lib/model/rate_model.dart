class RateModel {
  final int Rate_id;
  final int Rate;

  RateModel({
    required this.Rate_id,
    required this.Rate,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      Rate_id: json['Rate_id'],
      Rate: json['Rate'],
    );
  }
}


