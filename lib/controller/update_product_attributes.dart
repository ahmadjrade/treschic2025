// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:fixnshop_admin/model/domain.dart';
import 'package:fixnshop_admin/view/buy_accessories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateProductController extends GetxController {
  // RxList<CustomerModel> customerModel = <CustomerModel>[].obs;

  DomainModel domainModel = DomainModel();
  String result = '';

  Future<void> UpdatePhone(
      String Product_id,
      String P_Code,
      String Lprice,
      String Mprice,
      String Cprice,
      String cat,
      String scat,
      String color,
      String brand) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'update_product.php';
      print(Product_id);
      print(P_Code);
      print(Lprice);
      print(Mprice);
      print(Cprice);
      print(cat);
      print(scat);
      print(color);
      print(brand);
      var res = await http.post(Uri.parse(uri), body: {
        "Product_id": Product_id,
        "P_Code": P_Code,
        "Lprice": Lprice,
        "Mprice": Mprice,
        "Cprice": Cprice,
        "Cat": cat,
        "Scat": scat,
        "Color": color,
        "Brand": brand,
      });

      var response = json.decode(json.encode(res.body));
      Product_id = '';
      P_Code = '';
      Lprice = '';
      Mprice = '';
      Cprice = '';
      cat = '';
      scat = '';
      color = '';
      print(response);
      result = response;
      if (response.toString().trim() == 'Product Updated successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() ==
          'Product Code already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
