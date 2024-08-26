// controllers/item_controller.dart
// ignore_for_file: non_constant_identifier_names

import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/model/expense_category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseCategoryController extends GetxController {
  RxList<ExpenseCategoryModel> expense_category = <ExpenseCategoryModel>[].obs;
  bool isDataFetched = false;
  String result = '';
  RxBool isLoading = false.obs;
  Rx<ExpenseCategoryModel?> SelectedCategory = Rx<ExpenseCategoryModel?>(null);

  void clearSelectedCat() {
    SelectedCategory.value = null;
    expense_category.clear();
  }

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchcategories();
  }

  List<ExpenseCategoryModel> searchExpenseCategory(String query) {
    return expense_category
        .where((expense_category) =>
            expense_category.Exp_Cat_Name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void fetchcategories() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_expense_category.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          expense_category.assignAll(
              data.map((item) => ExpenseCategoryModel.fromJson(item)).toList());
          //expense_category = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (expense_category.isEmpty) {
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
