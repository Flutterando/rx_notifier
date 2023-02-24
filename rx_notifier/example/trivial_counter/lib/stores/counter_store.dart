import 'package:rx_notifier/rx_notifier.dart';

class CounterStore {
  final _countValue = RxNotifier<int>(0);
  int get count => _countValue.value;
  set count(int value) => _countValue.value = value;

  // computed
  String get countText => count.isEven ? 'Even' : 'Odd';

  // Actions
  final increment = RxAction();
  final decrement = RxAction();
}
