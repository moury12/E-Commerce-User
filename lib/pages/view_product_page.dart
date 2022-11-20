import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_user/customwidgets/product_grid_view.dart';
import 'package:ecommerce_user/providers/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/main_drawer.dart';
import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import 'product_details_page.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<CategoryModel>(
                  hint: const Text('Select Category'),
                  value: categoryModel,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: provider
                      .getCategoryListForFiltering()
                      .map((catModel) => DropdownMenuItem(
                          value: catModel, child: Text(catModel.categoryName)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryModel = value;
                    });
                    provider.getAllProductsByCategory(categoryModel!);
                  },
                ),
              ),
              provider.productList.isEmpty
                  ? const Expanded(
                      child: Center(
                      child: Text('No item found'),
                    ))
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6
                        ),
                        itemCount: provider.productList.length,
                        itemBuilder: (context, index) {
                          final product = provider.productList[index];
                          return ProductGridView(productModel: product);
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
