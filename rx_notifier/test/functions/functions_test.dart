import 'package:flutter_test/flutter_test.dart';
import 'package:rx_notifier/rx_notifier.dart';

void main() {
  test('rxNext', () async {
    final rxNotifier = RxNotifier(0);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      rxNotifier.value++;
    });

    final value = await rxNext(rxNotifier);
    expect(value, 1);
  });
}
