import 'package:flutter/foundation.dart';

import '../rx_notifier.dart';

extension ListenableMergeExtension on Listenable {
  Listenable operator +(Listenable listenable) =>
      Listenable.merge([this, listenable]);
}

extension ValueNotifierParse<T> on ValueListenable<T> {
  RxNotifier<T> asRx() => RxNotifier<T>(value);
}

extension RxStreamExtension<T> on Stream<T> {
  RxStream<T> asRx() => RxStream.of<T>(this);
}

extension RxFutureExtension<T> on Future<T> {
  RxFuture<T> asRx() => RxFuture.of<T>(this);
}

extension RxListExtension<T> on List<T> {
  RxList<T> asRx() => RxList.of<T>(this);
}

extension RxSetExtension<T> on Set<T> {
  RxSet<T> asRx() => RxSet.of<T>(this);
}

extension RxMapExtension<K, V> on Map<K, V> {
  RxMap<K, V> asRx() => RxMap.of<K, V>(this);
}
