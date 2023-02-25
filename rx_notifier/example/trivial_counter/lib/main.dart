import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'pages/counter_page.dart';
import 'reducers/counter_reducer.dart';
import 'stores/counter_store.dart';

late final CounterStore counterStore;
late final CounterReducer homeReducer;

void main() {
  counterStore = CounterStore();
  homeReducer = CounterReducer(counterStore);

  runApp(RxRoot(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: DefaultTextStyle(
          style: TextStyle(fontSize: 50), child: CounterPage()),
    );
  }
}
