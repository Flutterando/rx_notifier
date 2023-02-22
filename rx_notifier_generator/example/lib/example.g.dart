// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RxGenerator
// **************************************************************************

class AppStore = _AppStore with _AppStoreMixin;

mixin _AppStoreMixin on _AppStore {
  ///
  /// GENERATED count(int)
  ///

  late final _countRx = RxNotifier<int>(super.count);
  ValueListenable<int> get countListenable => _countRx;

  @override
  set count(int _countValue) => _countRx.value = _countValue;
  @override
  int get count => _countRx.value;

  ///
  /// GENERATED name(String)
  ///

  late final _nameRx = RxNotifier<String>(super.name);
  ValueListenable<String> get nameListenable => _nameRx;

  @override
  set name(String _nameValue) => _nameRx.value = _nameValue;
  @override
  String get name => _nameRx.value;
}
