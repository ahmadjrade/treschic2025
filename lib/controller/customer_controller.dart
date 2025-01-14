// controllers/item_controller.dart
import 'package:treschic/model/customer_model.dart';
import 'package:treschic/model/domain.dart';
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
  RxString result5 = ''.obs;
  RxString result6 = ''.obs;

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
            customer.Cus_Number.toLowerCase().contains(query.toLowerCase()) ||
            customer.Cus_Name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void searchCustomer(searchController) {
    String customerNumber = searchController.text;
    // Find the customer in the list by number
    CustomerModel foundCustomer = customers.firstWhere(
        (customer) => customer.Cus_Number == customerNumber,
        orElse: () => CustomerModel(
            Cus_id: -1,
            Cus_Name: 'Not Found',
            Cus_Number: '',
            Cus_Due_LB: 0.0,
            Cus_Due_USD: 0.0));

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
        orElse: () => CustomerModel(
            Cus_id: -1,
            Cus_Name: 'Not Found',
            Cus_Number: '',
            Cus_Due_LB: 0.0,
            Cus_Due_USD: 0.0));

    // Display the result
    if (foundCustomer.Cus_id != -1) {
      result3.value = '${foundCustomer.Cus_Name}';
      result4.value = '${foundCustomer.Cus_id}';
      result5.value = '${foundCustomer.Cus_Due_LB}';
      result6.value = '${foundCustomer.Cus_Due_USD}';

      print(result);
    } else {
      result3.value = 'Customer name not found';
      result4.value = 'Customer  idnot found';
      result5.value = '0';
      result6.value = '0';

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

  String address_result = '';
  Future<void> InsertAddress(String Cus_id, String Address) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'insert_customer_address.php';

      var res = await http.post(Uri.parse(uri), body: {
        "Cus_id": Cus_id,
        "Address": Address,
      });

      var response = json.decode(json.encode(res.body));
      Cus_id = '';
      Address = '';

      print(response);
      address_result = response;
      if (response.toString().trim() ==
          'Customer Address Added Successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == '') {}
    } catch (e) {
      print(e);
    }
  }

  String Update_result = '';
  Future<void> UpdateCustomer(String Cus_id, Cus_Name, Cus_Number) async {
    try {
      String domain = domainModel.domain;
      String uri = '$domain' + 'update_customer_info.php';

      var res = await http.post(Uri.parse(uri), body: {
        "Cus_id": Cus_id,
        "Cus_Name": Cus_Name,
        "Cus_Number": Cus_Number,
      });

      var response = json.decode(json.encode(res.body));
      Cus_id = '';
      Cus_Name = '';
      Cus_Number = '';

      print(response);
      Update_result = response;
      if (response.toString().trim() == 'Customer Updated  successfully.') {
        //  result = 'refresh';
      } else if (response.toString().trim() == 'Phone IMEI already exists.') {}
    } catch (e) {
      print(e);
    }
  }
}
