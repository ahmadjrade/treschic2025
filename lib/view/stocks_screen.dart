// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({super.key});
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
    'Products','Phones','Suppliers'
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
    '/Products','/Phones','/Suppliers'
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
    'See','See','See'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks Screen'),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: GridView.builder(
          itemCount: 14,
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
                height: 50,
                width: 50,
                // color: Colors.deepPurple.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(Variables[index]),
                    SizedBox(
                      height: 10,
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
    );
  }
}
