import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'controllers/shop_controller.dart';
import 'pages/cart_page.dart';
import 'pages/home_page.dart';
import 'stores/app_store.dart';

final injector = AutoInjector(
  on: (i) {
    i.addSingleton(AppStore.new);
    i.addSingleton(ShopController.new);
    i.commit();
  },
);

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
