import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../main.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select(() => [counterStore.count]);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              counterStore.countText,
              style: TextStyle(fontSize: 40),
            ),
            Text(
              '${counterStore.count}',
              style: TextStyle(fontSize: 23),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.remove),
        onPressed: () => counterStore.decrement(),
      ),
    );
  }
}
