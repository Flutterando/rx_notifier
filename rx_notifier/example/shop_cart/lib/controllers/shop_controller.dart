import 'package:example/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../stores/app_store.dart';

class ShopReducer extends RxReducer {
  final AppStore appStore;
  ShopState get shop => appStore.components.shop;

  ShopReducer(this.appStore) {
    on(() => [shop.fetchProductsAction], _fetchProductsReducer);
    on(() => [shop.addProductAction], addProductReducer);
  }

  @visibleForTesting
  void addProductReducer() {
    if (shop.addProductAction != null) {
      shop.cartProducts.add(shop.addProductAction!);
    }
  }

  void _fetchProductsReducer() {
    shop.products = [
      ProductModel(
        title: 'Product 1',
        imageUrl: '',
        price: 1000,
      ),
      ProductModel(
        title: 'Product 2',
        imageUrl: '',
        price: 1000,
      ),
      ProductModel(
        title: 'Product 3',
        imageUrl: '',
        price: 1000,
      ),
      ProductModel(
        title: 'Product 4',
        imageUrl: '',
        price: 1000,
      ),
    ];
  }
}