// controllers/item_controller.dart
import 'package:treschic/model/color_model.dart';
import 'package:treschic/model/domain.dart';
import 'package:treschic/model/size_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SizeController extends GetxController {
  RxList<SizeModel> sizes = <SizeModel>[].obs;
  bool isDataFetched = false;
  String result = '';

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchcolors();
  }

  void closeLoading() {}
  void fetchcolors() async {
    if (!isDataFetched) {
      try {
        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_sizes.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          sizes
              .assignAll(data.map((item) => SizeModel.fromJson(item)).toList());
          //sizes = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          if (sizes.isEmpty) {
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
