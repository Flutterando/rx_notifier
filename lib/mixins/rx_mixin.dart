part of '../rx_notifier.dart';

/// Deprecated
@Deprecated('Use RxRoot Widget with context.select')
mixin RxMixin on StatelessWidget {
  /// Deprecated
  bool filter() => true;

  @override
  StatelessElement createElement() => _StatelessMixInElement(this);
}

class _StatelessMixInElement<W extends RxMixin> extends StatelessElement
    with _NotifierElement {
  _StatelessMixInElement(
    W widget,
  ) : super(widget);

  @override
  void update(W newWidget) {
    super.update(newWidget);
  }
}

mixin _NotifierElement on ComponentElement {
  Listenable? listenable;

  void invalidate() {
    if ((widget as RxMixin).filter()) {
      markNeedsBuild();
    }
  }

  @override
  Widget build() {
    late Widget child;
    listenable?.removeListener(invalidate);
    _rxMainContext.track();
    child = super.build();

    final listenables = _rxMainContext.untrack(_stackTrace);
    if (listenables.isNotEmpty) {
      listenable = Listenable.merge(listenables.toList());
    }

    listenable?.addListener(invalidate);

    return child;
  }

  @override
  void unmount() {
    listenable?.removeListener(invalidate);
    super.unmount();
  }
}
