part of '../rx_notifier.dart';

/// Merge [Listenable] objects.
/// ```dart
/// final newListenable = listenable1 + listenable2;
/// ```
extension ListenableMergeExtension on Listenable {
  /// Merge [Listenable] objects.
  /// ```dart
  /// final newListenable = listenable1 + listenable2;
  /// ```

  Listenable operator +(Listenable listenable) => Listenable.merge([
        this,
        listenable,
      ]);
}

/// Convert a [ValueListenable] to [RxNotifier].
extension ValueNotifierParse<T> on ValueListenable<T> {
  /// Convert a [ValueListenable] to [RxNotifier].
  RxNotifier<T> asRx() => RxNotifier<T>(value);
}

/// Convert a [Stream] to [RxStream].
extension RxStreamExtension<T> on Stream<T> {
  /// Convert a [Stream] to [RxStream].
  RxStream<T> asRx() => RxStream.of<T>(this);
}

/// Convert a [Future] to [RxFuture].
extension RxFutureExtension<T> on Future<T> {
  /// Convert a [Future] to [RxFuture].
  RxFuture<T> asRx() => RxFuture.of<T>(this);
}

/// Convert a [List] to [RxList].
extension RxListExtension<T> on List<T> {
  /// Convert a [List] to [RxList].
  RxList<T> asRx() => RxList.of<T>(this);
}

/// Convert a [Set] to [RxSet].
extension RxSetExtension<T> on Set<T> {
  /// Convert a [Set] to [RxSet].
  RxSet<T> asRx() => RxSet.of<T>(this);
}

/// Convert a [Map] to [RxMap].
extension RxMapExtension<K, V> on Map<K, V> {
  /// Convert a [Map] to [RxMap].
  RxMap<K, V> asRx() => RxMap.of<K, V>(this);
}

/// Propagates the changes of the RxNotifier placed in the
/// body function in this widget.<br>
/// To use this feature, you need to add [RxRoot]
/// at the beginning of your application's Widget tree.
extension ContextSelectionExtension on BuildContext {
  /// Propagates the changes of the RxNotifier placed in the
  /// body function in this widget.<br>
  /// To use this feature, you need to add [RxRoot]
  /// at the beginning of your application's Widget tree.
  T select<T>(T Function() selectFunc, {bool Function()? filter}) {
    return RxRoot._select<T>(this, selectFunc, filter: filter);
  }
}
