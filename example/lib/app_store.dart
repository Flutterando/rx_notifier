import 'package:rx_notifier/rx_notifier.dart';

final appStore = AppStore();

class AppStore {
  final components = Components();
}

class Components {
  final home = HomeState();
}

class HomeState {
  final _countValue = RxNotifier<int>(0);
  int get count => _countValue.value;
  set count(int value) => _countValue.value = value;

  String get countText => count.isEven ? 'Par' : 'Impar';

  final _other = RxNotifier<int>(0);
  int get other => _other.value;
  set other(int value) => _other.value = value;
}
