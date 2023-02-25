import 'package:auto_injector/auto_injector.dart';

import 'controllers/shop_controller.dart';
import 'stores/app_store.dart';

final injector = AutoInjector(
  on: (i) {
    i.addSingleton(AppStore.new);
    i.addSingleton(ShopReducer.new);
    i.commit();
  },
);
