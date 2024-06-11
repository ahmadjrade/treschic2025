// ignore_for_file: prefer_const_constructors

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller_phones.dart';
import 'package:fixnshop_admin/controller/cart_types_controller.dart';
import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/insert_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/insert_product_controller.dart';
import 'package:fixnshop_admin/controller/invoice_controller.dart';
import 'package:fixnshop_admin/controller/invoice_detail_controller.dart';
import 'package:fixnshop_admin/controller/invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/product_detail_controller.dart';
import 'package:fixnshop_admin/controller/purchase_detail_controller.dart';
import 'package:fixnshop_admin/controller/purchase_history_controller.dart';
import 'package:fixnshop_admin/controller/rate_controller.dart';
import 'package:fixnshop_admin/controller/recharge_cart_controller.dart';
import 'package:fixnshop_admin/controller/recharge_detail_controller.dart';
import 'package:fixnshop_admin/controller/recharge_invoice_history_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/supplier_controller.dart';
import 'package:fixnshop_admin/view/Brands/add_brand.dart';
import 'package:fixnshop_admin/view/Category/add_category.dart';
import 'package:fixnshop_admin/view/Colors/add_color.dart';
import 'package:fixnshop_admin/view/Customers/add_customer.dart';
import 'package:fixnshop_admin/view/Phones/add_phone_model.dart';
import 'package:fixnshop_admin/view/Category/category_list.dart';
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
  Get.lazyPut<ColorController>(
    () => ColorController(),
    fenix: true,
  );
  Get.lazyPut<CategoryController>(
    () => CategoryController(),
    fenix: true,
  );
  Get.lazyPut<SubCategoryController>(
    () => SubCategoryController(),
    fenix: true,
  );
  Get.lazyPut<SupplierController>(
    () => SupplierController(),
    fenix: true,
  );
  Get.lazyPut<InsertProductController>(
    () => InsertProductController(),
    fenix: true,
  );
  Get.lazyPut<CustomerController>(
    () => CustomerController(),
    fenix: true,
  );
  Get.lazyPut<BrandController>(
    () => BrandController(),
    fenix: true,
  );
  Get.lazyPut<BrandControllerPhones>(
    () => BrandControllerPhones(),
    fenix: true,
  );
  Get.lazyPut<PhoneModelController>(
    () => PhoneModelController(),
    fenix: true,
  );
  Get.lazyPut<ProductController>(
    () => ProductController(),
    fenix: true,
  );
  Get.lazyPut<InsertProductDetailController>(
    () => InsertProductDetailController(),
    fenix: true,
  );
  Get.lazyPut<SharedPreferencesController>(
    () => SharedPreferencesController(),
    fenix: true,
  );
  Get.lazyPut<ProductDetailController>(
    () => ProductDetailController(),
    fenix: true,
  );
  Get.lazyPut<InvoiceDetailController>(
    () => InvoiceDetailController(),
    fenix: true,
  );
  Get.lazyPut<BarcodeController>(
    () => BarcodeController(),
    fenix: true,
  );
  Get.lazyPut<RateController>(
    () => RateController(),
    fenix: true,
  );
  Get.lazyPut<PhoneController>(
    () => PhoneController(),
    fenix: true,
  );
  Get.lazyPut<InvoiceHistoryController>(
    () => InvoiceHistoryController(),
    fenix: true,
  );
  Get.lazyPut<InvoiceController>(
    () => InvoiceController(),
    fenix: true,
  );
  Get.lazyPut<RepairsController>(
    () => RepairsController(),
    fenix: true,
  );
  Get.lazyPut<CartTypesController>(
    () => CartTypesController(),
    fenix: true,
  );
  Get.lazyPut<RechargeCartController>(
    () => RechargeCartController(),
    fenix: true,
  );
  Get.lazyPut<RechargeInvoiceHistoryController>(
    () => RechargeInvoiceHistoryController(),
    fenix: true,
  );
  Get.lazyPut<PurchaseHistoryController>(
    () => PurchaseHistoryController(),
    fenix: true,
  );
  Get.lazyPut<RechargeDetailController>(
    () => RechargeDetailController(),
    fenix: true,
  );
    Get.lazyPut<PurchaseDetailController>(
    () => PurchaseDetailController(),
    fenix: true,
  );
  
   final PurchaseDetailController purchaseDetailController =
      Get.find<PurchaseDetailController>();
  final RechargeDetailController rechargeDetailController =
      Get.find<RechargeDetailController>();
  final PurchaseHistoryController purchaseHistoryController =
      Get.find<PurchaseHistoryController>();
  final RechargeCartController rechargeCartController =
      Get.find<RechargeCartController>();
  final PhoneController phoneController = Get.find<PhoneController>();
  final InvoiceController invoiceController = Get.find<InvoiceController>();
  final RepairsController repairsController = Get.find<RepairsController>();
  final CartTypesController cartTypesController =
      Get.find<CartTypesController>();

  //final InvoiceController invoiceController = Get.find<InvoiceController>();
  final RateController rateController = Get.find<RateController>();
  final RechargeInvoiceHistoryController rechargeInvoiceHistoryController =
      Get.find<RechargeInvoiceHistoryController>();

  final BarcodeController barcodeController = Get.find<BarcodeController>();
  final InvoiceDetailController invoiceDetailController =
      Get.find<InvoiceDetailController>();

  final ProductDetailController productDetailController =
      Get.find<ProductDetailController>();

  final InsertProductDetailController insertProductDetailController =
      Get.find<InsertProductDetailController>();
  final SharedPreferencesController sharedPreferencesController =
      Get.find<SharedPreferencesController>();

  final ProductController productController = Get.find<ProductController>();

  final BrandControllerPhones brandControllerPhones =
      Get.find<BrandControllerPhones>();

  final BrandController brandController = Get.find<BrandController>();
  final PhoneModelController phoneModelController =
      Get.find<PhoneModelController>();

  final SubCategoryController subcategoryController =
      Get.find<SubCategoryController>();
  final InvoiceHistoryController invoiceHistoryController =
      Get.find<InvoiceHistoryController>();
  final CustomerController customerController = Get.find<CustomerController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final SupplierController supplierController = Get.find<SupplierController>();
  final ColorController colorController = Get.find<ColorController>();
  final InsertProductController insertProductController =
      Get.find<InsertProductController>();

  await Get.putAsync<SharedPreferencesController>(
      () async => SharedPreferencesController());
  final sharedPreferenecesController = Get.find<SharedPreferencesController>();
  await sharedPreferenecesController.loadUsernameFromSharedPreferences();

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
        GetPage(name: "/BuyPhone", page: () => BuyPhone()),
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
                )),
        GetPage(name: "/Phones", page: () => PhonesList()),
        GetPage(name: "/Suppliers", page: () => SupplierList()),

        //GetPage(name: "/CatList", page: () => CatList()),

        //  GetPage(name: "/NewBrand", page: () => BuyTools()),
      ],
    );
  }
}
