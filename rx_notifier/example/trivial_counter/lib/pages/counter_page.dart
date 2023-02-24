import 'package:example/main.dart';
import 'package:example/pages/other_page.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.select(() => [counterStore.count]);

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
                counterStore.countText,
                style: const TextStyle(fontSize: 40),
              ),
              Text(
                '${counterStore.count}',
                style: const TextStyle(fontSize: 23),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => counterStore.increment(),
      ),
    );
  }
}
