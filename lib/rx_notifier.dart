library value_notifier_extension;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part 'async/rx_future.dart';
part 'async/rx_stream.dart';
part 'collections/rx_list.dart';
part 'collections/rx_map.dart';
part 'collections/rx_set.dart';
part 'extensions/rx_extensions.dart';
part 'functions/functions.dart';
part 'mixins/rx_mixin.dart';
part 'widgets/rx_builder.dart';
part 'widgets/rx_root.dart';

final _rxMainContext = _RxContext();

/// Extension to ValueNotifier by transparently applying
/// functional reactive programming (TFRP).
class RxNotifier<T> extends ValueNotifier<T> {
  @override
  T get value {
    _rxMainContext.reportRead(this);
    if (_value is Listenable) {
      _rxMainContext.reportRead(super.value as Listenable);
    }
    return _value;
  }

  T _value;

  ///  Extension to ValueNotifier by transparently applying
  /// functional reactive programming (TFRP).
  RxNotifier(this._value) : super(_value);

  @override
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class _RxContext {
  bool isTracking = false;
  final List<Set<Listenable>> _listOfListenable = [];

  void track() {
    isTracking = true;
    _listOfListenable.add({});
  }

  Set<Listenable> untrack([StackTrace? stackTrace]) {
    isTracking = false;
    final listenables = _listOfListenable.last;
    _listOfListenable.removeLast();
    if (listenables.isNotEmpty) {
      return listenables;
    }

    final stackTraceString = stackTrace == null ? '' : _stackTrace.toString();
    final stackFrame = LineSplitter //
            .split(stackTraceString)
        .skip(1)
        .firstWhere(
          (frame) =>
              !frame.contains('new RxBuilder') && //
              !frame.contains('rxObserver'),
          orElse: () => '',
        );

    debugPrintStack(
      stackTrace: StackTrace.fromString(stackFrame),
      label: '\u001b[31m' 'No Rx variables in that space.',
    );
    return {};
  }

  void reportRead(Listenable listenable) {
    if (!isTracking) return;
    _listOfListenable.last.add(listenable);
  }
}

StackTrace _stackTrace = StackTrace.empty;
