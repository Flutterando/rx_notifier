part of '../rx_notifier.dart';

/// Responsible for propagating RxNotifier values
/// as a dependency of a child Widget.<br>
/// RxRoot should be one of the first Widgets in the Flutter tree.
/// ```dart
/// void main(){
///   runApp(RxRoot(child: AppWidget()));
/// }
/// ```
class RxRoot extends InheritedWidget {
  /// Responsible for propagating RxNotifier values
  /// as a dependency of a child Widget.<br>
  /// RxRoot should be one of the first Widgets in the Flutter tree.
  /// ```dart
  /// void main(){
  ///   runApp(RxRoot(child: AppWidget()));
  /// }
  /// ```
  const RxRoot({super.key, required super.child});

  static T _select<T>(
    BuildContext context,
    T Function() selectFunc, {
    bool Function()? filter,
  }) {
    _stackTrace = StackTrace.current;
    _rxMainContext.track();
    final value = selectFunc();
    final listenables = _rxMainContext.untrack(_stackTrace);

    final registre = _Register<T>(listenables, filter);
    final inherited = context.dependOnInheritedWidgetOfExactType<RxRoot>(
      aspect: registre,
    );
    if (inherited == null) {
      final stackTraceString = StackTrace.current.toString();
      final stackFrame = LineSplitter //
              .split(stackTraceString)
          .skip(1)
          .firstWhere(
            (frame) => !frame.contains('RxRoot'),
            orElse: () => '',
          );

      debugPrintStack(
        stackTrace: StackTrace.fromString(stackFrame),
        label: '\u001b[31m'
            'Please, add the *RxRoot*'
            ' widget as your first widget.',
      );
    }
    inherited?.updateShouldNotify(inherited);

    return value;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  @override
  InheritedElement createElement() => _RxRootElement(this);
}

class _RxRootElement extends InheritedElement {
  _RxRootElement(InheritedWidget widget) : super(widget);

  bool _dirty = false;

  _Register? currentRegister;

  @override
  void updateDependencies(Element dependent, covariant _Register register) {
    final registers = getDependencies(dependent) as Set<_Register>? ?? {};

    final listener = Listenable.merge(register.listenables.toList());

    register.mutableCallback.dispose = () {
      listener.removeListener(register.listener);
    };

    register.mutableCallback.callback = () {
      if (dependent.mounted) {
        if (register.filter?.call() ?? true) _handleUpdate(register);
      } else {
        listener.removeListener(register.listener);
      }
    };
    listener.addListener(register.listener);

    registers.add(register);
    setDependencies(dependent, registers);
  }

  @override
  Widget build() {
    if (_dirty) notifyClients(widget);
    return super.build();
  }

  void _handleUpdate(_Register _register) {
    currentRegister = _register;
    _dirty = true;
    markNeedsBuild();
  }

  @override
  void notifyClients(covariant Widget oldWidget) {
    super.notifyClients(oldWidget as InheritedWidget);
    _dirty = false;
    currentRegister = null;
  }

  @override
  void notifyDependent(covariant InheritedWidget oldWidget, Element dependent) {
    final registers = getDependencies(dependent) as Set<_Register>? ?? {};
    if (registers.contains(currentRegister)) {
      _removeListeners(registers);
      setDependencies(dependent, <_Register>{});
      dependent.didChangeDependencies();
    }
  }

  void _removeListeners(Set<_Register> registers) {
    for (final register in registers) {
      register.mutableCallback.dispose?.call();
    }
  }
}

class _MutableCallback {
  void Function()? callback;
  void Function()? dispose;
}

class _Register<T> extends Equatable {
  final Set<Listenable> listenables;
  final mutableCallback = _MutableCallback();
  final bool Function()? filter;
  _Register(this.listenables, this.filter);

  void listener() {
    mutableCallback.callback?.call();
  }

  @override
  List<Object?> get props => [listenables];
}
