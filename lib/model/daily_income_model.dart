

class DailyIncomeModel {
  final String Source;
  final int Total_usd;
 final int IRec_Usd;
  final int Rec_Lb;
   final int IDue_Usd;
  final int ISum_Rec;
  DailyIncomeModel({
    required this.Source,
    required this.Total_usd,
      required this.IRec_Usd,
    required this.Rec_Lb,
      required this.IDue_Usd,
    required this.ISum_Rec,
  });

  factory DailyIncomeModel.fromJson(Map<String, dynamic> json) {
    return DailyIncomeModel(
      Source: json['Source'],
      Total_usd: json['Total_usd'].toDouble(),
       IRec_Usd: json['IRec_Usd'].toDouble(),
      Rec_Lb: json['Rec_Lb'].toDouble(),
       IDue_Usd: json['IDue_Usd'].toDouble(),
      ISum_Rec: json['ISum_Rec'].toDouble(),
    );
  }
}

