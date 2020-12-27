library value_notifier_extension;

import 'package:flutter/foundation.dart';

final _rxMainContext = RxContext();

class Rx<T> = ValueNotifier<T> with _Transparent<T>;

typedef RxDisposer = void Function();

extension ValueNotifierParse<T> on ValueListenable<T> {
  Rx<T> get rx => Rx<T>(value);
}

mixin _Transparent<T> on ValueListenable<T> {
  @override
  get value {
    _rxMainContext.reportRead(this);
    return super.value;
  }
}

class RxContext {
  bool isTracking = false;
  Set<Listenable> _listOfListenable = {};

  void track() {
    isTracking = true;
  }

  Listenable untrack() {
    isTracking = false;
    if (_listOfListenable.isNotEmpty) {
      final listenable = _listOfListenable.length == 1
          ? _listOfListenable.first
          : Listenable.merge(_listOfListenable.toList());
      _listOfListenable.clear();
      return listenable;
    }
    print('--- No Rx variables in that space.');
    return null;
  }

  void reportRead(Listenable listenable) {
    if (!isTracking) return;
    _listOfListenable.add(listenable);
  }
}

RxDisposer transparent(Function fn, {bool Function() filter}) {
  _rxMainContext.track();
  filter?.call();
  fn();
  final listenable = _rxMainContext.untrack();
  void Function() dispach = () {
    if (filter?.call() ?? true) {
      fn();
    }
  };

  if (listenable != null) {
    listenable.addListener(dispach);
  }
  return () {
    if (listenable != null) {
      listenable.removeListener(dispach);
    }
  };
}
