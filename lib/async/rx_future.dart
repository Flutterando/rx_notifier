part of '../rx_notifier.dart';

enum FutureStatus { pending, rejected, fulfilled, none }

class RxFuture<T> implements Future<T> {
  late Future<T> _future;
  bool _isStartedFuture = false;

  Future<T> get value => _future;

  set value(Future<T> value) {
    _future = value;
    _isStartedFuture = false;
    _status.value = FutureStatus.pending;
  }

  final RxNotifier<FutureStatus> _status = RxNotifier<FutureStatus>(FutureStatus.pending);

  final RxNotifier<T?> _result = RxNotifier<T?>(null);
  FutureStatus get status {
    _startedFuture();
    return _status.value;
  }

  void _startedFuture() {
    if (!_isStartedFuture) {
      _isStartedFuture = true;
      this.then((_) {});
    }
  }

  final RxNotifier _error = RxNotifier(null);
  get error {
    _startedFuture();
    return _error.value;
  }

  RxFuture._(Future<T> future) : _future = future;

  static RxFuture<T> of<T>(Future<T> future) => RxFuture._(future);

  T? get data {
    _startedFuture();
    return status == FutureStatus.fulfilled ? _result.value : null;
  }

  @override
  Stream<T> asStream() {
    return _future.asStream();
  }

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError}) {
    return RxFuture<R>._(_future.then((T value) {
      _result.value = value;
      _status.value = FutureStatus.fulfilled;
      return onValue(value);
    }, onError: (error) {
      _error.value = error;
      _status.value = FutureStatus.rejected;
      onError?.call(error == null ? null : [error]);
    }));
  }

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) {
    return RxFuture<T>._(_future.whenComplete(action));
  }

  Future<T> catchError(Function onError, {bool test(Object error)?}) {
    return RxFuture<T>._(_future.catchError(onError, test: test));
  }

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) {
    return RxFuture<T>._(_future.timeout(timeLimit, onTimeout: onTimeout));
  }
}
