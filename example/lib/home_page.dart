import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

final counter = RxNotifier<int>(0);

class HomePage extends StatelessWidget with RxMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${counter.value}',
          style: TextStyle(fontSize: 23),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => counter.value++,
      ),
    );
  }
}
