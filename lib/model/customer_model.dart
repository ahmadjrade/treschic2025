class CustomerModel {
  final int Cus_id;
  final String Cus_Name;
  final String Cus_Number;
  final double Cus_Due_USD;
  final double Cus_Due_LB;
  CustomerModel({
    required this.Cus_id,
    required this.Cus_Name,
    required this.Cus_Number,
    required this.Cus_Due_USD,
    required this.Cus_Due_LB,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      Cus_id: json['Cus_id'],
      Cus_Name: json['Cus_Name'],
      Cus_Number: json['Cus_Number'],
      Cus_Due_USD: json['Cus_Due_USD'].toDouble(),
      Cus_Due_LB: json['Cus_Due_LB'].toDouble(),
    );
  }
}
