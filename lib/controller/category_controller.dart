// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryController extends GetxController {
  RxList<CategoryModel> category = <CategoryModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<CategoryModel?> SelectedCategory = Rx<CategoryModel?>(null);

  void clearSelectedCat() {
    SelectedCategory.value = null;
    category.clear();
  }

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchcategories();
  }

  List<CategoryModel> searchCategories(String query) {
    return category
        .where((category) =>
            category.Cat_Name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void fetchcategories() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_categories.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          category.assignAll(
              data.map((item) => CategoryModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (category.isEmpty) {
            print(0);
          } else {
            isDataFetched = true;
            result == 'success';
            print('cat');
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
