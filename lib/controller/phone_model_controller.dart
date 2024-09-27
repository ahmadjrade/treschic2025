// controllers/item_controller.dart
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/phonemodels_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneModelController extends GetxController {
  RxList<PhoneModelsModel> phone_model = <PhoneModelsModel>[].obs;
  bool isDataFetched = false;
    RxBool isLoading = false.obs;

  String result = '';
    Rx<PhoneModelsModel?> SelectedPhoneModel = Rx<PhoneModelsModel?>(null);

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchphonemodel();
  }

  void closeLoading() {}


  List<PhoneModelsModel> searchProducts(String query) {
    return phone_model
        .where((phone) =>
            phone.Phone_Name.toLowerCase().contains(query.toLowerCase()) )
        .toList();
  }

  void fetchphonemodel() async {
    if (!isDataFetched) {
      try {
                isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_phone_model.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          phone_model.assignAll(
              data.map((item) => PhoneModelsModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          if (phone_model.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
                      isLoading.value = false;

            result == 'success';
            print(1);
          }
        } else {
          result == 'fail';
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
