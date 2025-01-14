// controllers/item_controller.dart
import 'package:treschic/model/category_model.dart';
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/sub_category_model.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategoryController extends GetxController {
  RxList<SubCategoryModel> sub_category = <SubCategoryModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  Rx<SubCategoryModel?> selectedSubCategory = Rx<SubCategoryModel?>(null);
  RxBool isLoading = false.obs;
void clearSelectedCat() {
    selectedSubCategory.value = null;
    sub_category.clear();
  }
  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchcategories();
  }
  List<SubCategoryModel> searchCategories(String query) {
    return sub_category.where((sub_category) =>
        sub_category.SCat_Name.toLowerCase().contains(query.toLowerCase())).toList();
  }
  void closeLoading() {}
  void fetchcategories() async {
    if (!isDataFetched) {
      try {
       isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_sub_categories.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          sub_category.assignAll(
              data.map((item) => SubCategoryModel.fromJson(item)).toList());
          //category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (sub_category.isEmpty) {
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
