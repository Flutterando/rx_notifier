import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../stores/app_store.dart';

class HomePage extends StatefulWidget {
  final ShopState shopState;
  const HomePage({super.key, required this.shopState});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ShopState get shopState => widget.shopState;

  @override
  void initState() {
    super.initState();
    shopState.fetchProductsAction();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.select(() => shopState.filteredProducts);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: products.length,
            padding: EdgeInsets.only(top: 60),
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.title),
                subtitle: Text('price: ${product.price}'),
                onTap: () {
                  shopState.addProductAction = product;
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextFormField(
                initialValue: '',
                onChanged: (value) {
                  shopState.filterText = value;
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: RxBuilder(
          builder: (_) {
            return Text('${shopState.cartProducts.length}');
          },
        ),
      ),
    );
  }
}
