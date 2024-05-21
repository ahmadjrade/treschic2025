// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/view/Customers/customer_list.dart';
import 'package:fixnshop_admin/view/home_screen.dart';
import 'package:fixnshop_admin/view/Repairs/insertion_screen.dart';
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:fixnshop_admin/view/search_screen.dart';
import 'package:fixnshop_admin/view/settings_screen.dart';
import 'package:fixnshop_admin/view/stocks_screen.dart';
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
  int SelectedPageIndex = 0;

  void _BottomNavAction(int index) {
    setState(() {
      SelectedPageIndex = index;
    });
  }

  final List<Widget> _HomeScreenpages = [
    HomeScreen(),
    ProductList(
      isPur: 1,
    ),
    CustomerList(),
    StocksScreen(),
    InsertionScreen(),
  ];

  double isIos() {
    double Height;
    if (Platform.isIOS) {
      Height = 25;
    } else {
      Height = 20;
    }
    return Height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
        title: Text('FixNShop'),
        backgroundColor: Colors.deepPurple.shade300,
      ),*/
      body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {},
          child: _HomeScreenpages[SelectedPageIndex]),
      backgroundColor: Colors.white,
      bottomNavigationBar: GNav(
          duration: Duration(milliseconds: 200),
          backgroundColor: Colors.white,
          rippleColor:
              Colors.grey[300]!, // tab button ripple color when pressed
          hoverColor: Colors.grey[100]!, // tab button hover color
          haptic: true, // haptic feedback
          // tabBorderRadius: 15,
          // tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
          // tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
          // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
          // curve: Curves.easeOutExpo, // tab animation curves
          // duration: Duration(milliseconds: 100), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.black, // unselected icon color
          activeColor: Colors.red.shade900, // selected icon and text color
          iconSize: 24, // tab button icon size

          tabBackgroundColor:
              Colors.grey[100]!, // selected tab background color
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: isIos(),
          ), // navigation bar padding
          onTabChange: (value) {
            setState(() {
              SelectedPageIndex = value;
            });
          },
          selectedIndex: SelectedPageIndex,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.add,
              text: 'Invoice',
            ),
            GButton(
              icon: Icons.warehouse,
              text: 'Data',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Repair',
            ),
            //     GButton(
            // icon: Icons.search,
            // text: 'Search',
            //     ),
            //     GButton(
            // icon: Icons.account_balance,
            // text: 'Profile',
            //     )
          ]),

      // CurvedNavigationBar(
      //     height: isIos(),
      //     backgroundColor: Colors.white,
      //     color: Colors.deepPurple.shade300,
      //     animationDuration: Duration(milliseconds: 200),
      //     onTap: (index) {
      //       _BottomNavAction(index);
      //     },
      //     items: [
      //   Icon(
      //     Icons.home,
      //     color: Colors.white,
      //   ),
      //   Icon(
      //     Icons.search,
      //     color: Colors.white,
      //   ),
      //   Icon(
      //     CupertinoIcons.add,
      //     color: Colors.white,
      //     size: 24.0,
      //     //semanticLabel: 'Text to announce in accessibility modes',
      //   ),
      //   Icon(
      //     Icons.warehouse,
      //     color: Colors.white,
      //   ),
      //   Icon(
      //     Icons.settings,
      //     color: Colors.white,
      //   ),
      // ]),
    );
  }
}
