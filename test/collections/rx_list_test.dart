import 'package:flutter_test/flutter_test.dart';
import 'package:rx_notifier/rx_notifier.dart';

main() {
  test('rx add', () async {
    RxList list = RxList(['jacob', 'sara']);
    rxObserver(() {
      print('----------------');
      for (var item in list) {
        print(item);
      }
    });
    await Future.delayed(Duration(milliseconds: 800));
    list.add('novo');
    await Future.delayed(Duration(milliseconds: 800));
    list.add('novo 2');
    await Future.delayed(Duration(milliseconds: 800));
  });
  test('rx contains', () async {
    RxList list = RxList(['jacob', 'sara']);
    assert(list.contains('jacob'));
  });

  test('rx list observer effect', () async {
    final list = RxNotifier(RxList(['jacob', 'sara']));
    bool effectHappened = false;
    rxObserver(() => list.value, effect: (val) {
      effectHappened = list.value.contains('coco');
    });
    list.value.add('coco');
    assert(effectHappened);
  });

  test('replace rxlist and keep reactivity', () async {
    final list = RxNotifier(RxList(['jacob', 'sara']));
    bool effectHappened = false;
    bool ignoreFirstReaction = true;
    rxObserver(() => list.value, effect: (val) {
      if (ignoreFirstReaction) {
        ignoreFirstReaction = false;
        return;
      }
      effectHappened = list.value.contains('coco');
    });
    list.value = RxList();
    list.value.add('coco');
    assert(effectHappened);
  });
}
