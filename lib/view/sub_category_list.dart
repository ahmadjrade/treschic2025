// ignore_for_file: prefer_const_constructors

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/sub_category_model.dart';
import 'package:fixnshop_admin/view/Accessories/buy_accessories.dart';
import 'package:fixnshop_admin/view/Product/product_list_by_scat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryList extends StatelessWidget {

   SubCategoryList({super.key});
  final SubCategoryController subcategoryController = Get.find<SubCategoryController>();
    final CategoryController categoryController = Get.find<CategoryController>();
  TextEditingController SCategory_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final selectedCategory = categoryController.SelectedCategory.value;
      String? CatName = selectedCategory?.Cat_Name;
    List<SubCategoryModel> filteredSubCategories(String query) {
      return subcategoryController.sub_category
          .where((subCategory) =>
              subCategory.Cat_id == selectedCategory?.Cat_id &&
              subCategory.SCat_Name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Sub Categories of $CatName',style: TextStyle(fontSize: 17), )),
             IconButton(
              color: Colors.deepPurple  ,
              iconSize: 24.0,
              onPressed: () {
                  Get.toNamed('/NewCat');
              },
              icon: Icon(CupertinoIcons.add),
            ),
           IconButton(
              color: Colors.deepPurple  ,
              iconSize: 24.0,
              onPressed: () {
                  subcategoryController.isDataFetched =false;
                  subcategoryController.fetchcategories();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: SCategory_Name,
              onChanged: (query) {
                subcategoryController.sub_category.refresh();
              },
              decoration: InputDecoration(
                labelText: 'Search by Sub Category Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                final List<SubCategoryModel> subCategories =
                    filteredSubCategories(SCategory_Name.text);
                if(subcategoryController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (subcategoryController.sub_category.isEmpty)  {
                  return Center(
                    child: Text('No Sub Category Found!'),
                  );
                }  
                else {
                  if(subCategories.isEmpty) {
                    return Center(
                    child: Text('No Sub Category Found !'),
                  );
                  }
                   else {
                    return ListView.builder(
                  itemCount: subCategories.length,
                  itemBuilder: (context, index) {
                    final SubCategoryModel subCategory = subCategories[index];
                    return ListTile(
                      title: Text(subCategory.SCat_Name),
                      trailing: OutlinedButton(
                        onPressed: () {
                          // Handle selection

                        subcategoryController.selectedSubCategory.value = subCategory;
                             //    null;
                      

                                  Get.to(() => ProductListBySCat());
                        },
                        child: Text('Select'),
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