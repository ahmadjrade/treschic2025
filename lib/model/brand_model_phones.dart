class BrandModelPhones {
  final int Brand_id;
  final String Brand_Name;

  BrandModelPhones({
    required this.Brand_id,
    required this.Brand_Name,
  });

  factory BrandModelPhones.fromJson(Map<String, dynamic> json) {
    return BrandModelPhones(
      Brand_id: json['Brand_id'],
      Brand_Name: json['Brand_Name'],
    );
  }
}
