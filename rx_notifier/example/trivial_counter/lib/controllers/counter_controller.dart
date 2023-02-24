import 'package:rx_notifier/rx_notifier.dart';

import '../stores/counter_store.dart';

class CounterController extends RxController {
  final CounterStore store;

  CounterController(this.store) {
    on(() => [store.increment], _increment);
    on(() => [store.decrement], _decrement);
  }

  void _increment() {
    store.count++;
  }

  void _decrement() {
    store.count--;
  }
}
