import 'package:flutter/foundation.dart';

import '../rx_notifier.dart';

extension ValueNotifierParse<T> on ValueListenable<T> {
  RxNotifier<T> asRx() => RxNotifier<T>(value);
}
