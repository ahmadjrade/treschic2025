class DriverModel {
  final int Driver_id;
  final String Driver_Name;
  final String Driver_Number;
  final double Driver_Due_usd;
  final double Driver_Due_lb;

  DriverModel({
    required this.Driver_id,
    required this.Driver_Name,
    required this.Driver_Number,
    required this.Driver_Due_usd,
    required this.Driver_Due_lb,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      Driver_id: json['Driver_id'],
      Driver_Name: json['Driver_Name'],
      Driver_Number: json['Driver_Number'],
      Driver_Due_usd: json['Driver_Due_USD'].toDouble(),
      Driver_Due_lb: json['Driver_Due_LB'].toDouble(),
    );
  }
}
