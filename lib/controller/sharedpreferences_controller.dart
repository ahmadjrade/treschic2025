import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController extends GetxController {
  RxString username = ''.obs;

  void setUsername(String newUsername) {
    username.value = newUsername;
    // Save the username to SharedPreferences
    saveUsernameToSharedPreferences(newUsername);
  }

  Future<void> saveUsernameToSharedPreferences(String username) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('username', username);
  }

  Future<void> loadUsernameFromSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    username.value = preferences.getString('username') ?? '';
  }
}