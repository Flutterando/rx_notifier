import 'package:example/models/product_model.dart';
import 'package:rx_notifier/rx_notifier.dart';

// atoms
final productsState = RxList<ProductModel>();
final cartProductsState = RxList<ProductModel>();
final filterTextState = RxNotifier('');

// computeds
List<ProductModel> get filteredProductsState {
  if (filterTextState.value.isEmpty) {
    return productsState;
  }
  return productsState.where((product) => product.title.contains(filterTextState.value)).toList();
}

// actions
final addProductAction = RxNotifier<ProductModel?>(null);
final fetchProductsAction = RxNotifier(null);
