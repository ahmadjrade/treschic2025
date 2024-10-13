// ignore_for_file: prefer_const_constructors

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/bluetooth_manager_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller_phones.dart';
import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/credit_balance_controller.dart';
import 'package:fixnshop_admin/controller/customer_address_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/driver_controller.dart';
import 'package:fixnshop_admin/controller/expense_category_controller.dart';
import 'package:fixnshop_admin/controller/expenses_controller.dart';
import 'package:fixnshop_admin/controller/imoney_controller.dart';
import 'package:fixnshop_admin/controller/insert_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/insert_product_controller.dart';
import 'package:fixnshop_admin/controller/insert_recharge_balance.dart';
import 'package:fixnshop_admin/controller/insert_repair_product_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/login_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/controller/platform_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/purchase_detail_controller.dart';
import 'package:fixnshop_admin/controller/purchase_history_controller.dart';
import 'package:fixnshop_admin/controller/purchase_payment_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/rech_invoice_payment_controller.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/controller/recharge_detail_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/supplier_controller.dart';
import 'package:fixnshop_admin/controller/topup_history_controller.dart';
import 'package:fixnshop_admin/view/Brands/add_brand.dart';
import 'package:fixnshop_admin/view/Category/add_category.dart';
import 'package:fixnshop_admin/view/Colors/add_color.dart';
import 'package:fixnshop_admin/view/Customers/add_customer.dart';
import 'package:fixnshop_admin/view/Phones/add_phone_model.dart';
import 'package:fixnshop_admin/view/Category/category_list.dart';
import 'package:fixnshop_admin/view/Repairs/buy_repair_product.dart';
import 'package:fixnshop_admin/view/Suppliers/add_supplier.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/buy_expenses.dart';
import 'package:fixnshop_admin/view/Phones/buy_phone.dart';
import 'package:fixnshop_admin/view/buy_tools.dart';
import 'package:fixnshop_admin/view/home_screen_manage.dart';
import 'package:fixnshop_admin/view/login_screen.dart';
import 'package:fixnshop_admin/view/Phones/phones_list.dart';
import 'package:fixnshop_admin/view/Product/product_list.dart';
import 'package:fixnshop_admin/view/Suppliers/supplier_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/sub_category_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Get.lazyPut<LoginController>(
    () => LoginController(),
    fenix: true,
  ); 
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //colorController.isDataFetched = false;

    //colorController.fetchcolors;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      getPages: [
        GetPage(name: "/LoginScreen", page: () => LoginScreen()),
        GetPage(name: "/HomeScreenManage", page: () => HomeScreenManage()),
        GetPage(name: "/BuyPhone", page: () => BuyPhone(Cus_id: '',Cus_Name: '',Cus_Number: '',)),
        GetPage(name: "/BuyAccessories", page: () => BuyAccessories()),
        GetPage(name: "/BuyExpenses", page: () => BuyExpenses()),
        GetPage(name: "/BuyTools", page: () => BuyTools()),
        GetPage(name: "/NewCustomer", page: () => AddCustomer()),
        GetPage(name: "/NewBrand", page: () => AddBrand()),
        GetPage(name: "/NewCat", page: () => AddCategory()),
        GetPage(name: "/NewSupplier", page: () => AddSupplier()),
        GetPage(name: "/NewPhoneModel", page: () => PhoneModelAdd()),
        GetPage(name: "/NewColor", page: () => AddColor()),
        GetPage(name: "/NewProductDetail", page: () => CategoryList()),
        GetPage(
            name: "/Products",
            page: () => ProductList(
                  isPur: 1,
                  from_home: 0,
                )),
        GetPage(name: "/Phones", page: () => PhonesList()),
        GetPage(name: "/Suppliers", page: () => SupplierList()),
        GetPage(name: "/BuyRepairProducts", page: () => BuyRepairProduct()),

        //GetPage(name: "/CatList", page: () => CatList()),

        //  GetPage(name: "/NewBrand", page: () => BuyTools()),
      ],
    );
  }
}
