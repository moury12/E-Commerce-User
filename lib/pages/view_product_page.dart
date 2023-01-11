import 'package:ecommerce_user/customwidgets/cart_bubble_view.dart';
import 'package:ecommerce_user/customwidgets/product_grid_view.dart';
import 'package:ecommerce_user/providers/shopping_cart_provider.dart';
import 'package:ecommerce_user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/main_drawer.dart';
import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';

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
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    Provider.of<OrderProvider>(context,listen: false).getAllOrderByUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                shadowColor: Colors.deepPurple.shade200,
                foregroundColor: Colors.black,
                backgroundColor: Colors.transparent,
                actions: [
                  CartBubbleView()
                ],

                expandedHeight: 250,
                pinned: true,
                floating: true,
                title: Text('Products'),
                flexibleSpace: FlexibleSpaceBar(title: Container(child: Text(''
                ),),),
              ),
              SliverGrid(delegate: SliverChildBuilderDelegate(childCount: provider.productList.length,(context, index){
                final product=provider.productList[index];
                return ProductGridView(productModel: product);
              }), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.65))
            ],
          );
        },
      ),
    );
  }

  Column buildColumn(ProductProvider provider) {
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
                      crossAxisCount: 2, childAspectRatio: 0.6),
                  itemCount: provider.productList.length,
                  itemBuilder: (context, index) {
                    final product = provider.productList[index];
                    return ProductGridView(productModel: product);
                  },
                ),
              ),
      ],
    );
  }
}
