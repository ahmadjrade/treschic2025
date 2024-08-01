// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/homescreen_manage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StocksScreen extends StatelessWidget {
  StocksScreen({super.key});
  final HomeController homeController = Get.find<HomeController>();

  static const List Variables = [
    'Customers',
    'Brands',
    'New/Used Phone',
    'Accessories',
    'Tools',
    'Expenses',
    'Suppliers',
    'Categories',
    'Phone Model',
    'New Color',
    'Product Details',
    'Products',
    'Phones',
    'Suppliers',
    'Repair Product',
  ];

  static const List Pathes = [
    '/NewCustomer',
    '/NewBrand',
    '/BuyPhone',
    '/BuyAccessories',
    '/BuyTools',
    '/BuyExpenses',
    '/NewSupplier',
    '/NewCat',
    '/NewPhoneModel',
    '/NewColor',
    '/NewProductDetail',
    '/Products',
    '/Phones',
    '/Suppliers',
    '/BuyRepairProducts'
  ];
  static const List btnName = [
    'Add',
    'Add',
    'Buy',
    'Buy',
    'Buy',
    'Buy',
    'Add',
    'Add',
    'Add',
    'Add',
    'Add',
    'See',
    'See',
    'See',
    'Buy'
  ];
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenWidth = mediaQuery.size.width;
    var screenHeight = mediaQuery.size.height;
    var padding = mediaQuery.padding;
    var safeWidth = screenWidth - padding.horizontal;
    var safeHeight = screenHeight - padding.vertical;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks Screen'),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          homeController.selectedPageIndex.value = 0;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: safeWidth * 0.01, vertical: safeHeight * 0.01),
          child: GridView.builder(
            itemCount: 15,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.deepPurple.shade300,
                  ),
                  height: safeHeight * 0.8,
                  width: safeWidth * 0.8,
                  // color: Colors.deepPurple.shade300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(Variables[index]),
                      SizedBox(
                        height: safeHeight / 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(double.maxFinite, 20),
                              backgroundColor: Colors.white,
                              side: BorderSide(width: 2.0, color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              String name = Pathes[index];
                              Get.toNamed('$name');
                            },
                            child: Text(
                              btnName[index],
                              style: TextStyle(fontSize: 15),
                            )),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
