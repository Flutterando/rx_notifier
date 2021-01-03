library value_notifier_extension;

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
export 'extensions/rx_extensions.dart';

part 'rx_mixin.dart';
part 'collections/rx_list.dart';
part 'collections/rx_map.dart';
part 'collections/rx_set.dart';
part 'async/rx_future.dart';
part 'async/rx_stream.dart';

final _rxMainContext = _RxContext();

class RxNotifier<T> = ValueNotifier<T> with _Transparent<T>;

typedef RxDisposer = void Function();

mixin _Transparent<T> on ValueListenable<T> {
  @override
  get value {
    _rxMainContext.reportRead(this);
    return super.value;
  }
}

class _RxContext {
  bool isTracking = false;
  List<Set<Listenable>> _listOfListenable = [];

  void track() {
    isTracking = true;
    _listOfListenable.add({});
  }

  Listenable? untrack() {
    isTracking = false;
    final listenables = _listOfListenable.last;
    _listOfListenable.removeLast();
    if (listenables.isNotEmpty) {
      final listenable = listenables.length == 1
          ? listenables.first
          : Listenable.merge(listenables.toList());
      return listenable;
    }
    print('--- No Rx variables in that space.');
    return null;
  }

  void reportRead(Listenable listenable) {
    if (!isTracking) return;
    _listOfListenable.last.add(listenable);
  }
}

RxDisposer rxObserver(void Function() fn, {bool Function()? filter}) {
  _rxMainContext.track();
  fn();
  final listenable = _rxMainContext.untrack();
  void Function() dispach = () {
    if (filter?.call() ?? true) {
      fn();
    }
  };

  listenable?.addListener(dispach);

  return () {
    listenable?.removeListener(dispach);
  };
}

class RxBuilder extends StatelessWidget with RxMixin {
  final Widget Function(BuildContext context) builder;
  late final bool Function()? _filter;

  RxBuilder({
    Key? key,
    required this.builder,
    bool Function()? filter,
  }) : super(key: key) {
    _filter = filter;
  }

  @override
  bool filter() => _filter?.call() ?? true;

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
