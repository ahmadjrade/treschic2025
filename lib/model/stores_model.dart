class StoresModel {
  final int Store_id;
  final String Store_Name;
    final String Store_Number;
    final String Store_Loc;



  StoresModel({
    required this.Store_id,
    required this.Store_Name,
        required this.Store_Number,   
             required this.Store_Loc,


  });

  factory StoresModel.fromJson(Map<String, dynamic> json) {
    return StoresModel(
      Store_id: json['Store_id'],
      Store_Name: json['Store_Name'],
            Store_Number: json['Store_Number'],
            Store_Loc: json['Store_Loc'],

    );
  }
}
