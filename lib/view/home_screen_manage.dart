// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/controller/homescreen_manage_controller.dart';
import 'package:treschic/view/Customers/customer_list.dart';
import 'package:treschic/view/home_screen.dart';
import 'package:treschic/view/Product/product_list.dart';
import 'package:treschic/view/management.dart';
import 'package:treschic/view/search_screen.dart';
import 'package:treschic/view/settings_screen.dart';
import 'package:treschic/view/extra_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../model/customer_model.dart';

class HomeScreenManage extends StatefulWidget {
  HomeScreenManage({super.key});

  @override
  State<HomeScreenManage> createState() => _HomeScreenManageState();
}

class _HomeScreenManageState extends State<HomeScreenManage> {
  final HomeController homeController = Get.put(HomeController());

  final List<Widget> _homeScreenPages = [
    HomeScreen(),
    ProductList(
      isPur: 1,
      from_home: 1,
    ),
    CustomerList(
      from_home: 1,
    ),
    ExtraSettings(),
    Management(),
  ];

  double isIos() {
    return Platform.isIOS ? 30 : 20;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              //  homeController.selectedPageIndex.value = 0;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _homeScreenPages[
                        homeController.selectedPageIndex.value]),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade300,
                )
              ],
            )),
        bottomNavigationBar: GNav(
          duration: Duration(milliseconds: 200),
          // backgroundColor: Colors.white,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          haptic: true,
          gap: 8,
          color: Colors.black,
          activeColor: Colors.blue.shade900,
          iconSize: 24,
          tabBackgroundColor: Colors.grey[100]!,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: isIos()),
          onTabChange: (index) {
            homeController.changePage(index);
          },
          selectedIndex: homeController.selectedPageIndex.value,
          tabs: [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.search, text: 'Search'),
            GButton(icon: Icons.add, text: 'Invoice'),
            GButton(icon: Icons.repartition, text: 'Manage'),
            GButton(icon: Icons.settings, text: 'Management'),
          ],
        ),
      );
    });
  }
}
