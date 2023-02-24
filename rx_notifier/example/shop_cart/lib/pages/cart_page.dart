import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../models/product_model.dart';
import '../stores/app_store.dart';

class CartPage extends StatelessWidget {
  final ShopState shopState;

  const CartPage({super.key, required this.shopState});

  @override
  Widget build(BuildContext context) {
    // !! Dart 3.0 sintaxe
    // final [products, length] = context.select(() => [
    //       shopState.cartProducts,
    //       shopState.cartProducts.length,
    //     ]);

    final destructuring = context.select(() => [
          shopState.cartProducts,
          shopState.cartProducts.length,
        ]);
    final products = destructuring[0] as RxList<ProductModel>;
    final length = destructuring[1] as int;

    return Scaffold(
      appBar: AppBar(title: Text(' Cart')),
      body: ListView.builder(
        itemCount: length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text('price: ${product.price}'),
            trailing: IconButton(
              onPressed: () {
                products.remove(product);
              },
              icon: Icon(Icons.remove_circle_outline),
            ),
          );
        },
      ),
    );
  }
}
