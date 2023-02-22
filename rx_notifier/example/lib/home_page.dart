import 'package:example/app_store.dart';
import 'package:example/other_page.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                style: const TextStyle(fontSize: 40),
              ),
              Text(
                '${home.count}',
                style: const TextStyle(fontSize: 23),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => home.count++,
      ),
    );
  }
}
