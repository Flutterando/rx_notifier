# rx_notifier_generator

Generate RxNotifier getter and setter. Use annotations @store and @rx;

## OPTIONAL Code generator

If you prefer a leaner syntax for RxNotifier objects, use code generation with build_runner.

1. Add the rx_notifier_generator and build_runner packages to dev_dependencies.

```yaml

dependencies:
  rx_notifier: <current-version>

dev_dependencies:
  rx_notifier_generator: <current-version>
  build_runner: <current-version>
```

2. Use the @RxStore annotation on the class and @RxValue on the properties.

```dart
part 'app_store.g.dart';

@RxStore()
abstract class _AppStore {
  @RxValue()
  int count = 0;

  @RxValue()
  String name = 'Barney';
}
```
3. Run the build runner:
```
dart pub run build_runner --delete-conflicting-outputs
```

4. Just use:
```dart
final appStore = AppStore();

rxObserver((){
  print(appStore.count);
});

appStore.count++; // update

```

5. The class that will be annotated with @RxStore must be abstract and private. The generator will start a public instance with transparent RxNotifier.

6. Properties with @RxValue must be mutable and public.