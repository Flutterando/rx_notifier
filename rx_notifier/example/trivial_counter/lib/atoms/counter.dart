import 'package:rx_notifier/rx_notifier.dart';

// atom
final counterState = RxNotifier<int>(0);

// computed
String get countText => counterState.value.isEven ? 'Even' : 'Odd';
