part of '../rx_notifier.dart';

/// Listen for [RxNotifier] changes present in the body.
/// <br>
/// [body]: All RxNotifier used in this function will be automatically
/// signed and this function will be called every
/// time the value of an rxNotifier changes.
/// [filter]: Filter reactions and prevent unwanted effects.<br>
/// [effect]: The `body` function generates a value that can be
/// retrieved from the effect function.
///
/// ```dart
/// final counter = RxNotifier<int>(0);
///
/// RxDisposer disposer = rxObserver((){
///    print(counter.value);
/// });
///
/// disposer();
/// ```
RxDisposer rxObserver<T>(
  T? Function() body, {
  bool Function()? filter,
  void Function(T? value)? effect,
}) {
  _stackTrace = StackTrace.current;
  _rxMainContext.track();
  body();
  final listenables = _rxMainContext.untrack(_stackTrace);
  void dispatch() {
    if (filter?.call() ?? true) {
      final value = body();
      effect?.call(value);
    }
  }

  if (listenables.isNotEmpty) {
    final listenable = Listenable.merge(listenables.toList());
    listenable.addListener(dispatch);

    return RxDisposer(() {
      listenable.removeListener(dispatch);
    });
  }
  return RxDisposer(() {});
}

/// Remove all listeners of rxObserver;
class RxDisposer {
  final void Function() _disposer;

  /// Remove all listeners of rxObserver;
  RxDisposer(this._disposer);

  /// Remove all listeners of rxObserver;
  void call() => _disposer();
}
