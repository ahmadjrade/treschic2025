// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fixnshop_admin/controller/category_controller.dart';
import 'package:fixnshop_admin/controller/sub_category_controller.dart';
import 'package:fixnshop_admin/model/category_model.dart';
import 'package:fixnshop_admin/view/sub_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryList extends StatelessWidget {
   CategoryList({super.key});
  
    final SubCategoryController subcategoryController = Get.find<SubCategoryController>();

  final CategoryController categoryController = Get.find<CategoryController>();
  TextEditingController Category_Name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('Category List')),
          Row(
            children: [
              IconButton(
                  color: Colors.deepPurple  ,
                  iconSize: 24.0,
                  onPressed: () {
                      Get.toNamed('/NewCat');
                  },
                  icon: Icon(CupertinoIcons.add),
                ),IconButton(
              color: Colors.deepPurple  ,
              iconSize: 24.0,
              onPressed: () {
                  categoryController.isDataFetched =false;
                  categoryController.fetchcategories();
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
            ],
          ),
           
        ],
      )),

      body: Column(
        children: [
            Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: Category_Name,
            onChanged: (query) {
              categoryController.category.refresh();
            },
            decoration: InputDecoration(
              labelText: 'Search by Name',
              prefixIcon: Icon(Icons.search),
            ),
                        ),
                      ),
        Expanded(
          child: Obx(
            () {
             final List<CategoryModel> filteredCategories =
                    categoryController.searchCategories(Category_Name.text);
              if(categoryController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                  return ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final CategoryModel category = filteredCategories[index];
                  return ListTile(
                    title: Text(category.Cat_Name),
                    trailing: OutlinedButton(
                      onPressed: () {

                        categoryController.SelectedCategory.value = category;
                              subcategoryController.selectedSubCategory.value =
                                  null;
                      

                                  Get.to(() => SubCategoryList());
                      },
                      child: Text('Select')),
                    // Add more properties as needed
                  );
                },
              );
              }
              
            },
          ),
        ),
      
        ],
      ),
    );
  }
}