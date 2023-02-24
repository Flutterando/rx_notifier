import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'module.dart';
import 'pages/cart_page.dart';
import 'pages/home_page.dart';
import 'stores/app_store.dart';

void main() {
  final appStore = injector<AppStore>();
  runApp(RxRoot(child: MyApp(appStore: appStore)));
}

class MyApp extends StatelessWidget {
  final AppStore appStore;

  const MyApp({super.key, required this.appStore});
  @override
  Widget build(BuildContext context) {
    final appStore = injector<AppStore>();

    final themeMode = context.select(() => appStore.config.themeMode);

    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      routes: {
        '/': (context) => HomePage(shopState: appStore.components.shop),
        '/cart': (context) => CartPage(shopState: appStore.components.shop),
      },
    );
  }
}
