// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, must_be_immutable, unused_import

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/product_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/product_model.dart';
import 'package:fixnshop_admin/model/sub_category_model.dart';
import 'package:fixnshop_admin/view/add_product_detail.dart';
import 'package:fixnshop_admin/view/buy_accessories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListBySCat extends StatelessWidget {

   ProductListBySCat({super.key});
     final  categoryController = Get.find<CategoryController>();

  final subcategoryController = Get.find<SubCategoryController>();
  final ProductController productController = Get.find<ProductController>();
  TextEditingController Product_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
      final selectedCategory2 = categoryController.SelectedCategory.value;
            String? CatName = selectedCategory2?.Cat_Name;

     final selectedCategory = subcategoryController.selectedSubCategory.value;
      String? SCatName = selectedCategory?.SCat_Name;
    List<ProductModel> filteredProducts(String query) {
      return productController.products
          .where((product) =>
              product.Product_Sub_Cat_id == selectedCategory?.SCat_id &&
              product.Product_Name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: [
            Expanded(child: Text('Products of $CatName - $SCatName',style: TextStyle(fontSize: 15), )),
            
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [ IconButton(
              color: Colors.deepPurple  ,
              iconSize: 24.0,
              onPressed: () {
                  Get.toNamed('/BuyAccessories');
              },
              icon: Icon(CupertinoIcons.add),
            ),
               IconButton(
                  color: Colors.deepPurple  ,
                  iconSize: 24.0,
                  onPressed: () {
                      productController.isDataFetched =false;
                      productController.fetchproducts();
                  },
                  icon: Icon(CupertinoIcons.refresh),
                ),
             ],
           ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: Product_Name,
              onChanged: (query) {
                productController.products.refresh();
              },
              decoration: InputDecoration(
                labelText: 'Search by Product Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                final List<ProductModel> filteredproducts =
                    filteredProducts(Product_Name.text);
                if(productController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (productController.products.isEmpty)  {
                  return Center(
                    child: Text('No Product Found!'),
                  );
                }  
                else {
                  if(filteredproducts.isEmpty) {
                    return Center(
                    child: Text('No Product Found !'),
                  );
                  }
                   else {
                    return ListView.builder(
                  itemCount: filteredproducts.length,
                  itemBuilder: (context, index) {
                    final ProductModel product = filteredproducts[index];
                    return Container(
                      color: Colors.grey.shade200,  
                        margin: EdgeInsets.fromLTRB(15,0,15,10),  
                   //     padding: EdgeInsets.all(35),  
                        alignment: Alignment.center, 
                      child: ListTile(
                        title: Text(product.Product_Name),
                        subtitle: Text('Product Code: ' + product.Product_Code,style: TextStyle(color: Colors.deepPurple ,fontSize: 15),),
                        trailing: OutlinedButton(
                          onPressed: () {
                            // Handle selection
                                    Get.to(() => AddProductDetail(Product_id: product.Product_id.toString(),Product_Name: product.Product_Name,Product_Code: product.Product_Code,Product_LPrice: product.Product_LPrice.toString(),Product_MPrice: product.product_MPrice.toString(),));
                          },
                          child: Text('Select'),
                        ),
                      ),
                    );
                  },
                );
                   }
                   
                }
               
              },
            ),
          ),
        ],
      ),
    );
  }
}