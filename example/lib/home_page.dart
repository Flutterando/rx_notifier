import 'package:example/app_store.dart';
import 'package:example/other_page.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final home = appStore.components.home;
    context.select(
      () => [home.other],
    );
    context.select(
      () => [home.count],
    );

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => OtherPage(),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => home.count++,
      ),
    );
  }
}
