// import 'package:flutter/material.dart';

// class CatList extends StatelessWidget {
//   const CatList({super.key});

//  late Future<List<Customer>> customerList;
//   String searchQuery = '';
//   bool isEmpty = true;

//   final CustomerController _customerController = CustomerController();

//   Future<void> addCustomer() async {
//     String refresh = await Navigator.push(
//         context, MaterialPageRoute(builder: (context) => AddNewCustomer()));
//     if (refresh == 'refresh') {
//       if (this.mounted) {
//         setState(() {
//           customerList = _customerController.fetchCustomers();
//           final snackBar2 = SnackBar(
//             content: const Text('Data Refreshed'),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(snackBar2);
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     customerList = _customerController.fetchCustomers();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //... (The rest of your existing NewSale widget code)
//   }
// }