// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_import, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/barcode_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller.dart';
import 'package:fixnshop_admin/controller/brand_controller_phones.dart';
import 'package:fixnshop_admin/controller/buy_phone_controller.dart';
import 'package:fixnshop_admin/controller/color_controller.dart';
import 'package:fixnshop_admin/controller/customer_controller.dart';
import 'package:fixnshop_admin/controller/phone_controller.dart';
import 'package:fixnshop_admin/controller/phone_model_controller.dart';
import 'package:fixnshop_admin/model/brand_model.dart';
import 'package:fixnshop_admin/model/brand_model_phones.dart';
import 'package:fixnshop_admin/model/color_model.dart';
import 'package:fixnshop_admin/model/customer_model.dart';
import 'package:fixnshop_admin/model/phonemodels_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyPhone extends StatefulWidget {
  String Cus_id,Cus_Name,Cus_Number;
  BuyPhone({super.key,required this.Cus_id,required this.Cus_Name,required this.Cus_Number});

  @override
  State<BuyPhone> createState() => _BuyPhoneState();
}

class _BuyPhoneState extends State<BuyPhone> {
//  final ColorController colorController = Get.put(ColorController());
  final ColorController colorController = Get.find<ColorController>();
  final PhoneModelController phoneModelController =
      Get.find<PhoneModelController>();

  // final BarcodeController controller = Get.put(BarcodeController());
  final CustomerController customerController = Get.find<CustomerController>();
    final BarcodeController barcodeController = Get.find<BarcodeController>();
  final PhoneController phoneController = Get.find<PhoneController>();

  String Phone_Condition = 'Used';

  bool havePassword = false;

  DateTime now = DateTime.now();
  String formattedDate = '';
  String formattedTime = '';

  TextEditingController Note = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController Price = TextEditingController();

  TextEditingController Imei = TextEditingController();
  List<String> capacity = [
    '32G',
    '64G',
    '128G',
    '256G',
    '512G',
    '1TB',
    '2TB',
  ];
  //int? SelectMonth = 1;
  int SelectedCapacityIndex = 0;
  String SelectedCapacity = '';
  
  //int? SelectMonth = 1;

  BrandModelPhones? SelectedBrand;
  int SelectedBrandId = 0;

  PhoneModelsModel? SelectedPhone;
  int SelectedPhoneId = 0;

  ColorModel? SelectedColor;
  int SelectedColorId = 0;

  final BrandControllerPhones brandController =
      Get.find<BrandControllerPhones>();

  final BuyPhoneController buyPhoneController = Get.put(BuyPhoneController());
  @override
  void initState() {
    formattedDate = DateFormat('yyyy/MM/dd').format(now);
    formattedTime = DateFormat('HH:mm a').format(now);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> NavOut() async {
      Navigator.of(context).pop();
    }

    Future<void> showToast(result) async {
      final snackBar2 = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        //leading: Text('$formattedDate'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Buy Phone'),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 00, 0),
                  child: Text(
                    '$formattedDate',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
               
              ],
            ),
            IconButton(
              color: Colors.blue.shade900,
              iconSize: 24.0,
              onPressed: () {
                customerController.isDataFetched = false;
                customerController.fetchcustomers();
                colorController.isDataFetched = false;
                colorController.fetchcolors();
                phoneModelController.SelectedPhoneModel.value = null;
                brandController.selectedBrand.value = null;
                phoneModelController.phone_model.clear();
                brandController.brands.clear();
                phoneModelController.isDataFetched = false;
                phoneModelController.fetchphonemodel();
                brandController.isDataFetched = false;
                brandController.fetchbrands();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
              child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      
        Column(
          children: [
            SizedBox(
          height: 20,
        ),
       
        Padding(
          padding: const EdgeInsets.symmetric(horizontal :25.0),
          child: TextFormField(
                        readOnly: true,
                        initialValue: widget.Cus_Name + ' || ' + widget.Cus_Number,
                        // controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Customer Name ",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          fillColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                'Condition ? ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text('Used'),
                  value: 'Used',
                  groupValue: Phone_Condition,
                  onChanged: (value) {
                    setState(() {
                      // havePassword = false;
                      Phone_Condition = value.toString();
                      // Password.text = 'No Password';
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  //selected: true,
                  title: Text('New'),
                  value: 'New',
                  groupValue: Phone_Condition,
                  onChanged: (value) {
                    setState(() {
                      //havePassword = true;
                      // Password.clear();
                      Phone_Condition = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Obx(
            () => brandController.brands.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        // Text('Fetching Rate! Please Wait'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : DropdownButtonFormField<BrandModelPhones>(
                    decoration: InputDecoration(
                      labelText: "Brands",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      fillColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    iconDisabledColor: Colors.blue.shade100,
                    iconEnabledColor: const Color.fromARGB(255, 20, 15, 29),
                    //  value: categoryController.category.first,
                    onChanged: (BrandModelPhones? value) {
                      brandController.selectedBrand.value = value;
                      phoneModelController.SelectedPhoneModel.value = null;
                      SelectedBrand = value;
                      SelectedBrandId = (SelectedBrand?.Brand_id)!;
                      print(SelectedBrandId);
                    },
                    items: brandController.brands
                        .map((brand) => DropdownMenuItem<BrandModelPhones>(
                              value: brand,
                              child: Text(brand.Brand_Name),
                            ))
                        .toList(),
                  ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Obx(
                  () {
                    final phonemodelForSelectedBrand = phoneModelController
                        .phone_model
                        .where((subCat) =>
                            subCat.Brand_id ==
                            brandController.selectedBrand.value?.Brand_id)
                        .toList();
      
                    if (phonemodelForSelectedBrand.isEmpty) {
                      return TextFormField(
                        readOnly: true,
                        initialValue: 'No Phone Models For Selected Brand',
                        //controller: Product_Name,
                        decoration: InputDecoration(
                          labelText: "Phone Models ",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          fillColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                      );
                    }
      
                    return DropdownButtonFormField<PhoneModelsModel>(
                      iconDisabledColor: Colors.blue.shade100,
                      iconEnabledColor: Colors.blue.shade100,
                      decoration: InputDecoration(
                        labelText: "Phone Models",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      value: phoneModelController.SelectedPhoneModel.value,
                      onChanged: (PhoneModelsModel? value) {
                        phoneModelController.SelectedPhoneModel.value =
                            SelectedPhone = value;
                        SelectedPhoneId = (SelectedPhone?.Phone_Model_id)!;
                        print(SelectedPhoneId);
                      },
                      items: phonemodelForSelectedBrand
                          .map((subCat) =>
                              DropdownMenuItem<PhoneModelsModel>(
                                value: subCat,
                                child: Text(subCat.Phone_Name),
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Capacity ",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
                iconDisabledColor: Colors.blue.shade100,
                iconEnabledColor: Colors.blue.shade100,
                value: SelectedCapacityIndex,
                onChanged: (newIndex) {
                  setState(() {
                    SelectedCapacity = capacity[newIndex];
                    SelectedCapacityIndex = newIndex;
                    print(SelectedCapacity);
                    //  selectedMonthIndex = newIndex!;
                    //  SelectMonth = newIndex + 1;
                  });
                },
                items: capacity.asMap().entries.map<DropdownMenuItem>(
                  (entry) {
                    int index = entry.key;
                    String monthName = entry.value;
                    return DropdownMenuItem(
                      value: index,
                      child: Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Obx(
                () => colorController.colors.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            // Text('Fetching Rate! Please Wait'),
                            CircularProgressIndicator(),
                          ],
                        ),
                      )
                    : DropdownButtonFormField<ColorModel>(
                        decoration: InputDecoration(
                          labelText: "Color",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          fillColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                        ),
                        iconDisabledColor: Colors.blue.shade100,
                        iconEnabledColor: Colors.blue.shade100,
                        //   value: colorController.colors.first,
                        onChanged: (ColorModel? value) {
                          SelectedColor = value;
                          SelectedColorId = (SelectedColor?.Color_id)!;
                          print(SelectedColorId);
                        },
                        items: colorController.colors
                            .map((color) => DropdownMenuItem<ColorModel>(
                                  value: color,
                                  child: Text(color.Color),
                                ))
                            .toList(),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(00, 0, 0, 0),
            child: Row(
              children: [
                IconButton(
                  color: Colors.black,
                  iconSize: 24.0,
                  icon: Icon(CupertinoIcons.add),
                  onPressed: () {
                    //customerController.searchCustomer(numberController);
                    Get.toNamed('/NewColor');
                  },
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          )
        ]),
        SizedBox(
          height: 10,
        ),
         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
         Expanded(
              child: Obx(() {
                Imei.text = barcodeController.barcode4.value;
                return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  maxLength: 15,
                  //readOnly: fa,
                  controller: Imei,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: "Phone IMEI / SN",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    fillColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              );
            
              }),
             ),
           Padding(
             padding: const EdgeInsets.fromLTRB(0,0,15,25),
             child: Visibility(
                visible: true,
                child:  IconButton(
                  icon: Icon(Icons.qr_code_scanner_rounded),
                  color: Colors.black,
                  onPressed: () {
                    barcodeController
                        .scanBarcodePhone()
                        .then((value) => null);
                  },
                ),),
           )
        ]),
        SizedBox(
          height: 5,
        ),
      
        SizedBox(
          height: 10,
        ),
        /* Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            maxLines: 1,
            //controller: Product_Name,
            decoration: InputDecoration(
              hintText: 'List all the problems that the customer is facing',
              labelText: "Issue",
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),*/
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: TextFormField(
            maxLines: 1,
            controller: Note,
            decoration: InputDecoration(
              labelText: "Note",
              hintText: 'Any Note you want to write it ! ',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              fillColor: Colors.black,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  //initialValue: '0',
                  controller: Price,
                  decoration: InputDecoration(
                    labelText: "Price",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    fillColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
      
              //Checkbox(),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
          ],
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: OutlinedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, 50),
                backgroundColor: Colors.blue.shade100,
                side: BorderSide(
                    width: 2.0, color: Colors.blue.shade100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                if (widget.Cus_id!= '' &&
                    widget.Cus_Name != '' &&
                    widget.Cus_Number != '') {
                  showDialog(
                      // The user CANNOT close this dialog  by pressing outsite it
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return Dialog(
                          // The background color
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // The loading indicator
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 15,
                                ),
                                // Some text
                                Text('Loading')
                              ],
                            ),
                          ),
                        );
                      });
                  buyPhoneController.UploadPhone(
                          int.tryParse(widget.Cus_id)! ,
                          widget.Cus_Name,
                          widget.Cus_Number,
                          SelectedBrandId,
                          SelectedPhoneId,
                          SelectedColorId,
                          Phone_Condition,
                          SelectedCapacity,
                          Imei.text,
                          Note.text,
                          Price.text)
                      .then((value) => Navigator.of(context).pop())
                      .then((value) => phoneController.isDataFetched =false)
                      .then((value) => phoneController.fetchphones())
                      .then((value) => showToast(buyPhoneController.result))
                      .then((value) => NavOut());
                } else if (SelectedBrandId == 0) {
                  showToast('Please Select Brand !');
                } else if (SelectedPhoneId == 0) {
                  showToast('Please Select Phone Model !');
                } else if (SelectedCapacity == '') {
                  showToast('Please Select Capacity !');
                } else if (SelectedColorId == 0) {
                  showToast('Please Select Color !');
                } else if (Imei.text == '') {
                  showToast('Please Add Imei');
                } else if (Price.text == '') {
                  showToast('Please Add Price');
                } else {
                  showToast('Please Add Customer!');
                }
              },
              child: Text(
                'Submit Purchase',
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              )),
        ),
        SizedBox(
          height: 20,
        )
      ],
              ),
            ),
    );
  }

  void MakeRefresh() {}
}
