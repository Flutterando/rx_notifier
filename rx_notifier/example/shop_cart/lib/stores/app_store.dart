import 'package:example/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

part 'app_store.g.dart';

class AppStore {
  final components = Components();
  final config = Configurations();
}

@RxStore()
abstract class _Configurations {
  @RxValue()
  ThemeMode themeMode = ThemeMode.light;
}

class Components {
  final shop = ShopState();
}

@RxStore()
abstract class _ShopState {
  @RxValue()
  var products = <ProductModel>[];

  @RxValue()
  var cartProducts = <ProductModel>[].asRx();

  @RxValue()
  var filterText = '';

  List<ProductModel> get filteredProducts {
    if (filterText.isEmpty) {
      return products;
    }
    return products
        .where((product) => product.title.contains(filterText))
        .toList();
  }

  // actions
  @RxValue()
  ProductModel? addProductAction;

  final fetchProductsAction = RxAction();
}
