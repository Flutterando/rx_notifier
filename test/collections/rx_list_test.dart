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
  test('rx containe', () async {
    RxList list = RxList(['jacob', 'sara']);
    print(list.contains('jacob'));
  });
}
