// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// RxGenerator
// **************************************************************************

class Configurations = _Configurations with _ConfigurationsMixin;

mixin _ConfigurationsMixin on _Configurations {
  ///
  /// GENERATED themeMode(ThemeMode)
  ///

  late final _themeModeRx = RxNotifier<ThemeMode>(super.themeMode);
  ValueListenable<ThemeMode> get themeModeListenable => _themeModeRx;

  @override
  set themeMode(ThemeMode _themeModeValue) =>
      _themeModeRx.value = _themeModeValue;
  @override
  ThemeMode get themeMode => _themeModeRx.value;
}

class ShopState = _ShopState with _ShopStateMixin;

mixin _ShopStateMixin on _ShopState {
  ///
  /// GENERATED products(List<ProductModel>)
  ///

  late final _productsRx = RxNotifier<List<ProductModel>>(super.products);
  ValueListenable<List<ProductModel>> get productsListenable => _productsRx;

  @override
  set products(List<ProductModel> _productsValue) =>
      _productsRx.value = _productsValue;
  @override
  List<ProductModel> get products => _productsRx.value;

  ///
  /// GENERATED cartProducts(RxList<ProductModel>)
  ///

  late final _cartProductsRx =
      RxNotifier<RxList<ProductModel>>(super.cartProducts);
  ValueListenable<RxList<ProductModel>> get cartProductsListenable =>
      _cartProductsRx;

  @override
  set cartProducts(RxList<ProductModel> _cartProductsValue) =>
      _cartProductsRx.value = _cartProductsValue;
  @override
  RxList<ProductModel> get cartProducts => _cartProductsRx.value;

  ///
  /// GENERATED filterText(String)
  ///

  late final _filterTextRx = RxNotifier<String>(super.filterText);
  ValueListenable<String> get filterTextListenable => _filterTextRx;

  @override
  set filterText(String _filterTextValue) =>
      _filterTextRx.value = _filterTextValue;
  @override
  String get filterText => _filterTextRx.value;

  ///
  /// GENERATED addProductAction(ProductModel?)
  ///

  late final _addProductActionRx =
      RxNotifier<ProductModel?>(super.addProductAction);
  ValueListenable<ProductModel?> get addProductActionListenable =>
      _addProductActionRx;

  @override
  set addProductAction(ProductModel? _addProductActionValue) =>
      _addProductActionRx.value = _addProductActionValue;
  @override
  ProductModel? get addProductAction => _addProductActionRx.value;
}
