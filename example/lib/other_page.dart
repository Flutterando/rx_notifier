import 'package:example/app_store.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final home = appStore.components.home;
    context.select(() => [home.count, home.other]);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              home.countText,
              style: TextStyle(fontSize: 40),
            ),
            Text(
              '${home.count}',
              style: TextStyle(fontSize: 23),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => home.count++,
      ),
    );
  }
}
