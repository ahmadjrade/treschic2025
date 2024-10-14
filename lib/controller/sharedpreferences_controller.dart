import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController extends GetxController {
  RxString username = ''.obs;
  RxString session = ''.obs;
  RxString storeNumber = ''.obs;
  RxString location = ''.obs;
  RxString storeName = ''.obs;
  RxString userRole = ''.obs; // Add user role

  // Save the username
  void setUsername(String newUsername) {
    username.value = newUsername;
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

  // Save the session
  void setSession(String newSession) {
    session.value = newSession;
    saveSessionToSharedPreferences(newSession);
  }

  Future<void> saveSessionToSharedPreferences(String session) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('session', session);
  }

  Future<void> loadSessionFromSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    session.value = preferences.getString('session') ?? '';
  }

  // Save the store number
  void setStoreNumber(String newStoreNumber) {
    storeNumber.value = newStoreNumber;
    saveStoreNumberToSharedPreferences(newStoreNumber);
  }

  Future<void> saveStoreNumberToSharedPreferences(String storeNumber) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('storeNumber', storeNumber);
  }

  Future<void> loadStoreNumberFromSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    storeNumber.value = preferences.getString('storeNumber') ?? '';
  }

  // Save the location
  void setLocation(String newLocation) {
    location.value = newLocation;
    saveLocationToSharedPreferences(newLocation);
  }

  Future<void> saveLocationToSharedPreferences(String location) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('location', location);
  }

  Future<void> loadLocationFromSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    location.value = preferences.getString('location') ?? '';
  }

  // Save the store name
  void setStoreName(String newStoreName) {
    storeName.value = newStoreName;
    saveStoreNameToSharedPreferences(newStoreName);
  }

  Future<void> saveStoreNameToSharedPreferences(String storeName) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('storeName', storeName);
  }

  Future<void> loadStoreNameFromSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    storeName.value = preferences.getString('storeName') ?? '';
  }

  // Save the user role
  void setUserRole(String newUserRole) {
    userRole.value = newUserRole;
    saveUserRoleToSharedPreferences(newUserRole);
  }

  Future<void> saveUserRoleToSharedPreferences(String userRole) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('userRole', userRole);
  }

  Future<void> loadUserRoleFromSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    userRole.value = preferences.getString('userRole') ?? '';
  }

  bool isAdmin() {
    return userRole.value.toLowerCase() == 'Admin';
  }

  // Load all data during initialization
  Future<void> loadAllData() async {
    await loadUsernameFromSharedPreferences();
    await loadSessionFromSharedPreferences();
    await loadStoreNumberFromSharedPreferences();
    await loadLocationFromSharedPreferences();
    await loadStoreNameFromSharedPreferences();
    await loadUserRoleFromSharedPreferences(); // Load user role
  }

  // Delete all data on logout
  Future<void> deleteAllData() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear(); // Clear all saved preferences
    username.value = '';
    session.value = '';
    storeNumber.value = '';
    location.value = '';
    storeName.value = '';
    userRole.value = ''; // Clear user role
  }

  @override
  void onInit() {
    super.onInit();
    loadAllData(); // Load all stored data when the controller is initialized
  }
}
