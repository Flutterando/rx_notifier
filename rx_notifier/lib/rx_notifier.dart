library value_notifier_extension;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

export 'package:flutter/foundation.dart' show ValueListenable;
export 'package:rx_notifier_annotation/rx_notifier_annotation.dart';

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

  /// The current value stored in this notifier.
  @override
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  /// Tear-offs for set value in this notifier.
  void setValue(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}

/// Send action
/// ```dart
/// final counter = RxNotifier<int>();
/// final increment = RxAction();
///
/// rxObserver(
///     () => increment.action,
///     effect: (_) => counter.value++,
/// );
///
/// // dispatch action
/// increment();
///
/// ```
class RxAction extends ChangeNotifier {
  /// Track action listener
  RxVoid get action {
    _rxMainContext.reportRead(this);
    return rxVoid;
  }

  /// dispatch action
  void call() {
    notifyListeners();
  }
}

/// A standalone control that registers various reducers
/// to perform actions and modify RxNotifiers;
/// ```dart
///
/// final counter = RxNotifier<int>(0);
/// final increment = RxAction();
///
/// class CounterController extends RxController {
///   final HomeState state;
///
///   CounterController(this.state) {
///     on(() => [increment], _incrementReducer);
///   }
///
///   void _incrementReducer() {
///     counter.value++;
///   }
/// }
///
/// // in widget:
///
/// Text('$counter.value'),
/// ...
/// onPressed: () => increment();
/// ```
abstract class RxController {
  final _rxDisposers = <RxDisposer>[];

  /// reducer register:
  /// ```dart
  /// on(() => [state.increment], _incrementReducer);
  /// ```
  void on(
    List<Object?> Function() rxValues,
    void Function() reducer, {
    bool Function()? filter,
  }) {
    final rxDisposer = rxObserver<void>(
      () {
        for (final value in rxValues()) {
          _prexec(value);
        }
      },
      effect: (_) => reducer(),
      filter: filter,
    );
    _rxDisposers.add(rxDisposer);
  }

  void _prexec(Object? object) {
    if (object is RxAction) {
      object.action;
    } else if (object is RxNotifier) {
      object.value;
    }
  }

  /// dispose all registers
  void dispose() {
    for (final disposer in _rxDisposers) {
      disposer();
      _rxDisposers.clear();
    }
  }
}

/// Void return
class RxVoid {
  /// Void return
  const RxVoid();
}

const rxVoid = RxVoid();

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
