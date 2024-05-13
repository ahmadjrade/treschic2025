// controllers/item_controller.dart
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/domain.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerController extends GetxController {
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  bool isDataFetched = false;
  RxString result = ''.obs;
  RxString result2 = ''.obs;

  RxString result3 = ''.obs;
  RxString result4 = ''.obs;
  RxBool isLoading = false.obs;

  DomainModel domainModel = DomainModel();
  @override
  void onInit() {
    super.onInit();
    print(isDataFetched);
    fetchcustomers();
  }

  void resetResult() {
    result.value = '';
    result2.value = ''; // Reset the result to an empty string
  }

  List<CustomerModel> searchProducts(String query) {
    return customers
        .where((customer) =>
            customer.Cus_Number.toLowerCase().contains(query.toLowerCase()) || customer.Cus_Name.toLowerCase().contains(query.toLowerCase()))
        .toList()  ;
  }

  void searchCustomer(searchController) {
    String customerNumber = searchController.text;
    // Find the customer in the list by number
    CustomerModel foundCustomer = customers.firstWhere(
        (customer) => customer.Cus_Number == customerNumber,
        orElse: () =>
            CustomerModel(Cus_id: -1, Cus_Name: 'Not Found', Cus_Number: '',Cus_Due_LB: 0.0,Cus_Due_USD: 0.0));

    // Display the result
    if (foundCustomer.Cus_id != -1) {
      result.value = '${foundCustomer.Cus_Name}';
      result2.value = '${foundCustomer.Cus_id}';

      print(result);
    } else {
      result.value = 'Customer name not found';
      result2.value = 'Customer  idnot found';

      print(result);
    }
  }
  void searchCustomerforDue(searchController) {
    String customerNumber = searchController.text;
    // Find the customer in the list by number
    CustomerModel foundCustomer = customers.firstWhere(
        (customer) => customer.Cus_Number == customerNumber,
        orElse: () =>
            CustomerModel(Cus_id: -1, Cus_Name: 'Not Found', Cus_Number: '',Cus_Due_LB: 0.0,Cus_Due_USD: 0.0));

    // Display the result
    if (foundCustomer.Cus_id != -1) {
      result3.value = '${foundCustomer.Cus_Name}';
      result4.value = '${foundCustomer.Cus_id}';

      print(result);
    } else {
      result3.value = 'Customer name not found';
      result4.value = 'Customer  idnot found';

      print(result);
    }
  }

  void closeLoading() {}
  void fetchcustomers() async {
    if (!isDataFetched) {
      try {
        isLoading.value = true;

        String domain = domainModel.domain;
        final response =
            await http.get(Uri.parse('$domain' + 'fetch_customers.php'));

        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          final List<dynamic> data = jsonData;
          //  final List<dynamic> data = json.decode(response.body);
          customers.assignAll(
              data.map((item) => CustomerModel.fromJson(item)).toList());
          //colors = data.map((item) => Product_Details.fromJson(item)).toList();
          isDataFetched = true;
          isLoading.value = false;

          if (customers.isEmpty) {
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
