library value_notifier_extension;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
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
    if (super.value is Listenable) {
      _rxMainContext.reportRead(super.value as Listenable);
    }
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

  Listenable? untrack([StackTrace? stackTrace]) {
    isTracking = false;
    final listenables = _listOfListenable.last;
    _listOfListenable.removeLast();
    if (listenables.isNotEmpty) {
      final listenable = listenables.length == 1 ? listenables.first : Listenable.merge(listenables.toList());
      return listenable;
    }

    final stackTraceString = stackTrace == null ? '' : _stackTrace.toString();
    final stackFrame = LineSplitter.split(stackTraceString).skip(1).firstWhere(
          (frame) => !frame.contains('new RxBuilder') && !frame.contains('rxObserver'),
          orElse: () => '',
        );

    debugPrintStack(stackTrace: StackTrace.fromString(stackFrame), label: '\u001b[31m' + 'No Rx variables in that space.');
    return null;
  }

  void reportRead(Listenable listenable) {
    if (!isTracking) return;
    _listOfListenable.last.add(listenable);
  }
}

RxDisposer rxObserver<T>(T? Function() fn, {bool Function()? filter, void Function(T? value)? effect}) {
  _stackTrace = StackTrace.current;
  _rxMainContext.track();
  fn();
  final listenable = _rxMainContext.untrack(_stackTrace);
  void Function() dispach = () {
    if (filter?.call() ?? true) {
      final value = fn();
      effect?.call(value);
    }
  };

  listenable?.addListener(dispach);

  return () {
    listenable?.removeListener(dispach);
  };
}

StackTrace _stackTrace = StackTrace.empty;

class RxBuilder extends StatelessWidget with RxMixin {
  final Widget Function(BuildContext context) builder;
  late final bool Function()? _filter;

  RxBuilder({
    Key? key,
    required this.builder,
    bool Function()? filter,
  }) : super(key: key) {
    _filter = filter;
    _stackTrace = StackTrace.current;
  }

  @override
  bool filter() => _filter?.call() ?? true;

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
