class UserModel {
  final int User_id;
  final String Username;
  final String Role;
  final int store_id;

  UserModel({
    required this.User_id,
    required this.Username,
    required this.Role,
    required this.store_id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      User_id: json['User_id'],
      Username: json['Username'],
      Role: json['Role'],
      store_id: json['Store_id'],
    );
  }
}
