import 'package:flutter/foundation.dart';
import 'package:rx_notifier/rx_notifier.dart';

part 'example.g.dart';

@RxStore()
abstract class _AppStore {
  @RxValue()
  int count;

  @RxValue()
  String name;

  _AppStore(this.count, this.name);
}
