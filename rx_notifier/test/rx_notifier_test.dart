import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rx_notifier/rx_notifier.dart';

void main() {
  test('concat operator extension', () {
    final rx1 = RxNotifier(0);
    final rx2 = RxNotifier(0);
    final listenables = rx1 + rx2;
    final list = [];
    listenables.addListener(() {
      list.add(rx1.value);
    });
    rx1.value = 1;
    rx2.value = 2;
    expect(list, equals([1, 1]));
  });

  test('should dispatch rx value', () {
    final c = RxNotifier<int>(0);
    final list = <int>[];
    rxObserver(() {
      list.add(c.value);
    });
    c.value = 1;
    c.value = 2;
    c.value = 3;
    c.value = 4;
    c.value = 5;

    expect(list, equals([0, 1, 2, 3, 4, 5]));
  });

  test('should dispatch rx value and listen effect', () {
    final c = RxNotifier<int>(0);
    final list = <int>[];
    rxObserver<int>(
      () => c.value,
      effect: (value) {
        list.add(value!);
      },
    );
    c.value = 1;
    c.value = 2;
    c.value = 3;
    c.value = 4;
    c.value = 5;
    expect(list, equals([1, 2, 3, 4, 5]));
  });
  test('convert ValueListenable to Rx', () {
    final c = ValueNotifier(0).asRx();
    final list = <int>[];
    rxObserver(() {
      list.add(c.value);
    });
    c.value = 1;
    c.value = 2;
    c.value = 3;
    c.value = 4;
    c.value = 5;

    expect(list, equals([0, 1, 2, 3, 4, 5]));
  });
  test('filter rx', () {
    final c = ValueNotifier(0).asRx();
    final list = <int>[];
    rxObserver(
      () {
        list.add(c.value);
      },
      filter: () => c.value != 3,
    );
    c.value = 1;
    c.value = 2;
    c.value = 3;
    c.value = 4;
    c.value = 5;

    expect(list, equals([0, 1, 2, 4, 5]));
  });

  test('computed values', () {
    final a = RxNotifier(0);
    final b = ValueNotifier(0).asRx();
    final listA = <int>[];
    final listB = <int>[];
    rxObserver(() {
      log('A: ${a.value} | B: ${b.value}');
      listA.add(a.value);
      listB.add(b.value);
    });
    a.value = 1;
    b.value = 2;
    b.value = 3;

    expect(listA, equals([0, 1, 1, 1]));
    expect(listB, equals([0, 0, 2, 3]));
  });
}
