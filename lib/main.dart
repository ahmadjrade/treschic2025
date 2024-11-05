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
import 'package:fixnshop_admin/controller/repair_controller.dart';
import 'package:fixnshop_admin/controller/repair_detail_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_controller.dart';
import 'package:fixnshop_admin/controller/repair_product_detail_controller.dart';
import 'package:fixnshop_admin/controller/repairs_controller.dart';
import 'package:fixnshop_admin/controller/sharedpreferences_controller.dart';
import 'package:fixnshop_admin/controller/stores_controller.dart';
import 'package:fixnshop_admin/controller/supplier_controller.dart';
import 'package:fixnshop_admin/controller/topup_history_controller.dart';
import 'package:fixnshop_admin/controller/transfer_controller.dart';
import 'package:fixnshop_admin/controller/transfer_detail_controller.dart';
import 'package:fixnshop_admin/controller/transfer_history_controller.dart';
import 'package:fixnshop_admin/controller/users_controller.dart';
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
  Get.lazyPut<ExpenseCategoryController>(
    () => ExpenseCategoryController(),
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
  Get.lazyPut<InsertRepairProductController>(
    () => InsertRepairProductController(),
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
  Get.lazyPut<BluetoothController>(
    () => BluetoothController(),
    fenix: true,
  );
  Get.lazyPut<RechargeBalanceController>(
    () => RechargeBalanceController(),
    fenix: true,
  );
  Get.lazyPut<InsertRechargeBalance>(
    () => InsertRechargeBalance(),
    fenix: true,
  );
  Get.lazyPut<TopupHistoryController>(
    () => TopupHistoryController(),
    fenix: true,
  );
  Get.lazyPut<CustomerAddressController>(
    () => CustomerAddressController(),
    fenix: true,
  );

  Get.lazyPut<RepairProductController>(
    () => RepairProductController(),
    fenix: true,
  );
  Get.lazyPut<RepairProductDetailController>(
    () => RepairProductDetailController(),
    fenix: true,
  );
  Get.lazyPut<InvoicePaymentController>(
    () => InvoicePaymentController(),
    fenix: true,
  );
  Get.lazyPut<RechInvoicePaymentController>(
    () => RechInvoicePaymentController(),
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
  Get.lazyPut<RepairController>(
    () => RepairController(),
    fenix: true,
  );
  Get.lazyPut<RepairDetailController>(
    () => RepairDetailController(),
    fenix: true,
  );
  final RepairDetailController repairDetailController =
      Get.find<RepairDetailController>();
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
  final RechInvoicePaymentController rechInvoicePaymentController =
      Get.find<RechInvoicePaymentController>();
  final InvoicePaymentController invoicePaymentController =
      Get.find<InvoicePaymentController>();
  final RepairProductDetailController repairProductDetailController =
      Get.find<RepairProductDetailController>();
  final RepairProductController repairProductController =
      Get.find<RepairProductController>();
  final CustomerAddressController customerAddressController =
      Get.find<CustomerAddressController>();
  final BluetoothController bluetoothController =
      Get.find<BluetoothController>();
  final RechargeBalanceController rechargeBalanceController =
      Get.find<RechargeBalanceController>();

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
  final InsertRechargeBalance insertRechargeBalance =
      Get.find<InsertRechargeBalance>();
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
  final InsertRepairProductController insertRepairProductController =
      Get.find<InsertRepairProductController>();
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
        GetPage(
            name: "/BuyPhone",
            page: () => BuyPhone(
                  Cus_id: '',
                  Cus_Name: '',
                  Cus_Number: '',
                )),
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
        GetPage(
            name: "/Phones",
            page: () => PhonesList(
                  isTransfer: false,
                )),
        GetPage(name: "/Suppliers", page: () => SupplierList()),
        GetPage(name: "/BuyRepairProducts", page: () => BuyRepairProduct()),

        //GetPage(name: "/CatList", page: () => CatList()),

        //  GetPage(name: "/NewBrand", page: () => BuyTools()),
      ],
    );
  }
}
