library value_notifier_extension;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _rxMainContext = RxContext();

class RxNotifier<T> = ValueNotifier<T> with _Transparent<T>;

typedef RxDisposer = void Function();

extension ValueNotifierParse<T> on ValueListenable<T> {
  RxNotifier<T> get rx => RxNotifier<T>(value);
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

  Listenable? untrack() {
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

RxDisposer rxObserver(Function fn, {bool Function()? filter}) {
  _rxMainContext.track();
  filter?.call();
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

class RxBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final bool Function()? filter;
  const RxBuilder({
    Key? key,
    required this.builder,
    this.filter,
  }) : super(key: key);

  @override
  _RxBuilderState createState() => _RxBuilderState();
}

class _RxBuilderState extends State<RxBuilder> {
  Widget? child;
  Listenable? listenable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initTrack();
  }

  void _initTrack() {
    listenable?.removeListener(_listenerFunc);
    _rxMainContext.track();
    widget.filter?.call();
    child = widget.builder(context);
    listenable = _rxMainContext.untrack();

    if (listenable != null) {
      listenable?.addListener(_listenerFunc);
    }
  }

  void _listenerFunc() {
    if (widget.filter?.call() ?? true) {
      setState(() {
        child = widget.builder(context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    listenable?.removeListener(_listenerFunc);
  }

  @override
  Widget build(BuildContext context) {
    return child!;
  }
}
