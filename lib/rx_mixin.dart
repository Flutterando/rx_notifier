part of 'rx_notifier.dart';

mixin RxMixin on StatelessWidget {
  bool filter() => true;

  @override
  StatelessElement createElement() => _StatelessMixInElement(this);
}

class _StatelessMixInElement<W extends RxMixin> extends StatelessElement with _NotifierElement {
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
  @override
  void mount(Element? parent, newSlot) {
    super.mount(parent, newSlot);
  }

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

    listenable = _rxMainContext.untrack(_stackTrace);
    listenable?.addListener(invalidate);

    return child;
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
  }

  @override
  void unmount() {
    listenable?.removeListener(invalidate);
    super.unmount();
  }
}
