// controllers/item_controller.dart
import 'package:treschic/model/brand_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BrandController extends GetxController {
  RxList<BrandModel> brands = <BrandModel>[].obs;
  bool isDataFetched = false;
  String result = '';
   // Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchbrands();
  }

  void closeLoading() {}
  void fetchbrands() async {
    if (!isDataFetched) {
      try {
        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_brands.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          brands.assignAll(
              data.map((item) => BrandModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          if (brands.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
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
