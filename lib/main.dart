// ignore_for_file: prefer_const_constructors

import 'package:treschic/controller/barcode_controller.dart';
import 'package:treschic/controller/bluetooth_manager_controller.dart';
import 'package:treschic/controller/brand_controller.dart';
import 'package:treschic/controller/brand_controller_phones.dart';
import 'package:treschic/controller/category_controller.dart';
import 'package:treschic/controller/color_controller.dart';
import 'package:treschic/controller/customer_address_controller.dart';
import 'package:treschic/controller/customer_controller.dart';
import 'package:treschic/controller/driver_controller.dart';
import 'package:treschic/controller/expense_category_controller.dart';
import 'package:treschic/controller/expenses_controller.dart';
import 'package:treschic/controller/imoney_controller.dart';
import 'package:treschic/controller/insert_product_detail_controller.dart';
import 'package:treschic/controller/insert_product_controller.dart';
import 'package:treschic/controller/invoice_controller.dart';
import 'package:treschic/controller/invoice_detail_controller.dart';
import 'package:treschic/controller/invoice_history_controller.dart';
import 'package:treschic/controller/invoice_payment_controller.dart';
import 'package:treschic/controller/login_controller.dart';
import 'package:treschic/controller/platform_controller.dart';
import 'package:treschic/controller/product_controller.dart';
import 'package:treschic/controller/product_detail_controller.dart';
import 'package:treschic/controller/purchase_detail_controller.dart';
import 'package:treschic/controller/purchase_history_controller.dart';
import 'package:treschic/controller/purchase_payment_controller.dart';
import 'package:treschic/controller/rate_controller.dart';

import 'package:treschic/controller/sharedpreferences_controller.dart';
import 'package:treschic/controller/size_controller.dart';
import 'package:treschic/controller/stores_controller.dart';
import 'package:treschic/controller/supplier_controller.dart';
import 'package:treschic/controller/transfer_controller.dart';
import 'package:treschic/controller/transfer_detail_controller.dart';
import 'package:treschic/controller/transfer_history_controller.dart';
import 'package:treschic/controller/users_controller.dart';
import 'package:treschic/view/Brands/add_brand.dart';
import 'package:treschic/view/Category/add_category.dart';
import 'package:treschic/view/Colors/add_color.dart';
import 'package:treschic/view/Customers/add_customer.dart';
import 'package:treschic/view/Category/category_list.dart';
import 'package:treschic/view/Suppliers/add_supplier.dart';
import 'package:treschic/view/Product/buy_accessories.dart';
import 'package:treschic/view/Expenses/buy_expenses.dart';
import 'package:treschic/view/buy_tools.dart';
import 'package:treschic/view/home_screen_manage.dart';
import 'package:treschic/view/login_screen.dart';
import 'package:treschic/view/Product/product_list.dart';
import 'package:treschic/view/Suppliers/supplier_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/sub_category_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut<ColorController>(
    () => ColorController(),
    fenix: true,
  );
  Get.lazyPut<StoresController>(
    () => StoresController(),
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

  Get.lazyPut<ProductController>(
    () => ProductController(),
    fenix: true,
  );
  Get.lazyPut<InsertProductDetailController>(
    () => InsertProductDetailController(),
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

  Get.lazyPut<InvoiceHistoryController>(
    () => InvoiceHistoryController(),
    fenix: true,
  );
  Get.lazyPut<InvoiceController>(
    () => InvoiceController(),
    fenix: true,
  );
  Get.lazyPut<ExpenseCategoryController>(
    () => ExpenseCategoryController(),
    fenix: true,
  );

  Get.lazyPut<PurchaseHistoryController>(
    () => PurchaseHistoryController(),
    fenix: true,
  );

  Get.lazyPut<PurchaseDetailController>(
    () => PurchaseDetailController(),
    fenix: true,
  );
  Get.lazyPut<BluetoothController>(
    () => BluetoothController(),
    fenix: true,
  );

  Get.lazyPut<CustomerAddressController>(
    () => CustomerAddressController(),
    fenix: true,
  );

  Get.lazyPut<InvoicePaymentController>(
    () => InvoicePaymentController(),
    fenix: true,
  );

  Get.lazyPut<PurchasePaymentController>(
    () => PurchasePaymentController(),
    fenix: true,
  );
  Get.lazyPut<ExpensesController>(
    () => ExpensesController(),
    fenix: true,
  );
  Get.lazyPut<PlatformController>(
    () => PlatformController(),
    fenix: true,
  );
  Get.lazyPut<ImoneyController>(
    () => ImoneyController(),
    fenix: true,
  );
  Get.lazyPut<DriverController>(
    () => DriverController(),
    fenix: true,
  );
  Get.lazyPut<UsersControllers>(
    () => UsersControllers(),
    fenix: true,
  );
  Get.lazyPut<TransferController>(
    () => TransferController(),
    fenix: true,
  );
  Get.lazyPut<TransferHistoryController>(
    () => TransferHistoryController(),
    fenix: true,
  );
  Get.lazyPut<TransferDetailController>(
    () => TransferDetailController(),
    fenix: true,
  );
  Get.lazyPut<LoginController>(
    () => LoginController(),
    fenix: true,
  );
  Get.lazyPut<SharedPreferencesController>(
    () => SharedPreferencesController(),
    fenix: true,
  );
  Get.lazyPut<SizeController>(
    () => SizeController(),
    fenix: true,
  );
  final SizeController sizeController = Get.find<SizeController>();
  final TransferHistoryController transferHistoryController =
      Get.find<TransferHistoryController>();
  final TransferDetailController transferDetailController =
      Get.find<TransferDetailController>();
  final UsersControllers usersControllers = Get.find<UsersControllers>();
  final DriverController driverController = Get.find<DriverController>();
  final ImoneyController imoneyController = Get.find<ImoneyController>();
  final PlatformController platformController = Get.find<PlatformController>();
  final ExpensesController expensesController = Get.find<ExpensesController>();
  final PurchasePaymentController purchasePaymentController =
      Get.find<PurchasePaymentController>();

  final InvoicePaymentController invoicePaymentController =
      Get.find<InvoicePaymentController>();

  final CustomerAddressController customerAddressController =
      Get.find<CustomerAddressController>();
  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();

  final PurchaseDetailController purchaseDetailController =
      Get.find<PurchaseDetailController>();

  final PurchaseHistoryController purchaseHistoryController =
      Get.find<PurchaseHistoryController>();

  final InvoiceController invoiceController = Get.find<InvoiceController>();

  //final InvoiceController invoiceController = Get.find<InvoiceController>();
  final RateController rateController = Get.find<RateController>();

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

  final StoresController storesController = Get.find<StoresController>();

  // Initialize the SharedPreferencesController

  // Load session data from SharedPreferences

  // Load all stored data from SharedPreferences
  await sharedPreferencesController.loadAllData();

  // Check if session exists
  bool hasSession = sharedPreferencesController.session.value.isNotEmpty;

  runApp(MainApp(
    hasSession: hasSession,
  ));
}

class MainApp extends StatelessWidget {
  final bool hasSession;

  const MainApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context) {
    //colorController.isDataFetched = false;

    //colorController.fetchcolors;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      initialRoute: hasSession ? 'HomeScreenManage' : 'LoginScreen',

      getPages: [
        GetPage(name: "/LoginScreen", page: () => LoginScreen()),
        GetPage(name: "/HomeScreenManage", page: () => HomeScreenManage()),

        GetPage(name: "/BuyAccessories", page: () => BuyAccessories()),
        GetPage(name: "/BuyExpenses", page: () => BuyExpenses()),
        GetPage(name: "/BuyTools", page: () => BuyTools()),
        GetPage(name: "/NewCustomer", page: () => AddCustomer()),
        GetPage(name: "/NewBrand", page: () => AddBrand()),
        GetPage(name: "/NewCat", page: () => AddCategory()),
        GetPage(name: "/NewSupplier", page: () => AddSupplier()),
        GetPage(name: "/NewColor", page: () => AddColor()),
        GetPage(name: "/NewProductDetail", page: () => CategoryList()),
        GetPage(
            name: "/Products",
            page: () => ProductList(
                  isPur: 1,
                  from_home: 0,
                )),

        GetPage(name: "/Suppliers", page: () => SupplierList()),
        //GetPage(name: "/BuyRepairProducts", page: () => BuyRepairProduct()),

        //GetPage(name: "/CatList", page: () => CatList()),

        //  GetPage(name: "/NewBrand", page: () => BuyTools()),
      ],
    );
  }
}
