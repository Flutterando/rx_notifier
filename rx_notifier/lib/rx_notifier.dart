library value_notifier_extension;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

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
part 'widgets/rx_callback.dart';
part 'widgets/rx_root.dart';

final _rxMainContext = _RxContext();

/// An interface for subclasses of [Listenable] that expose a [value].
abstract class RxValueListenable<T> implements ValueListenable<T> {
  /// Wait the next change of a [RxNotifier].
  /// The [timeLimit] is 10 seconds by default.
  /// [onAction] callback execute after register listener.
  Future<T> next(
    Function onAction, {
    Duration timeLimit = const Duration(seconds: 10),
  });
}

/// Extension to ValueNotifier by transparently applying
/// functional reactive programming (TFRP).
class RxNotifier<T> extends ValueNotifier<T> implements RxValueListenable<T> {
  @override
  T get value {
    _rxMainContext.reportRead(this);
    if (_value is Listenable) {
      _rxMainContext.reportRead(super.value as Listenable);
    }
    return _value;
  }

  T _value;

  /// Extension to ValueNotifier by transparently applying
  /// functional reactive programming (TFRP).
  RxNotifier(this._value) : super(_value);

  /// Factory that return a RxNotifier<RxVoid> instance.
  /// ```dart
  /// RxNotifier<RxVoid>(rxVoid); => RxNotifier.action();
  /// ```
  static RxNotifier<RxVoid> action() => RxNotifier(rxVoid);

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

  /// Re-call all the registered listeners.
  void call() => notifyListeners();

  @override
  Future<T> next(
    Function onAction, {
    Duration timeLimit = const Duration(seconds: 10),
  }) {
    return rxNext<T>(
      this,
      onAction: onAction,
      timeLimit: timeLimit,
    );
  }
}

/// Send action
@Deprecated('Use [RxNotifier] instead.')
class RxAction extends RxNotifier<RxVoid> {
  /// Send action
  @Deprecated('Use [RxNotifier] instead.')
  RxAction() : super(rxVoid);

  /// Track action listener
  RxVoid get action => value;
}

/// The layer responsible for making business decisions
/// to perform actions and modify RxNotifiers;
/// ```dart
///
/// final counterState = RxNotifier<int>(0);
/// final incrementState = RxAction();
///
/// class CounterReducer extends RxReducer {
///   final HomeState state;
///
///   CounterReducer(this.state) {
///     on(() => [counterState], _increment);
///   }
///
///   void _increment() {
///     counterState.value++;
///   }
/// }
///
/// // in widget:
///
/// Text('$counter.value'),
/// ...
/// onPressed: () => increment();
/// ```
abstract class RxReducer {
  final _rxDisposers = <RxDisposer>[];

  /// reducer register:
  /// ```dart
  /// on(() => [state], _incrementReducer);
  /// ```
  void on(
    List<Object?> Function() rxValues,
    void Function() reducer, {
    bool Function()? filter,
  }) {
    final rxDisposer = rxObserver<void>(
      () {
        for (final value in rxValues()) {
          if (value is RxNotifier) {
            value.value;
          }
        }
      },
      effect: (_) => reducer(),
      filter: filter,
    );
    _rxDisposers.add(rxDisposer);
  }

  /// dispose all registers
  void dispose() {
    for (final disposer in _rxDisposers) {
      disposer();
    }
    _rxDisposers.clear();
  }
}

/// Void return
class RxVoid {
  /// Void return
  const RxVoid();
}

/// Void return
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
