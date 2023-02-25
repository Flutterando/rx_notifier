# rx_notifier

The [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) is a simple, native form of Flutter reactivity.
This extension aims to transparently apply **functional reactive programming (TFRP)**.

## Install

Add in pubspec.yaml:

```yaml
dependencies:
  rx_notifier: <version>
```

## Understanding Extension.

This extension adds a class **RxNotifier** and a converter **ValueNotifier -> RxNotifier** so that it can be observed transparently by the function **rxObserver()** and [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html) **RxBuilder**.

The **RxNotifier** is directly an extension of [ValueListenable](https://api.flutter.dev/flutter/foundation/ValueListenable-class.html) then any object that implements it can be converted to **RxNotifier**

The only difference from **RxNofifier** to [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) is the automatic signature function in Observers **rxObserver()** e **RxBuilder**, very similar to [MobX reactions](https://pub.dev/packages/mobx).

## Using

To start, instantiate an RxNofifier.

```dart
final counter = RxNotifier<int>(0);
```

or convert a  [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) already existing using the **.rx()** method:

```dart

final counter = myValueNotifierCounter.asRx();

```
> **IMPORTANT**: The **asRx()** method has been added to [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) using [Extension Methods](https://dart.dev/guides/language/extension-methods).


And listen the changes using **rxObserver**:

```dart
RxDisposer disposer = rxObserver((){
    print(counter.value);
});

disposer();
```

All declared values in the current scope **fn()** are observables and can generate a value that is listened in property **effect**.

```dart
RxDisposer disposer = rxObserver<String>((){
    return '${name.value} + ${lastName.value}';
}, effect: (String fullName){
  print(fullName);
});

disposer();
```

This is the transparent use of individual reactivity, but we can also combine **RxNotifier Objects** producing new value. This technique is called **Computed**

## Computed: Combining reactive values

To combine two or more **RxNotifier Objects** we need to use a **getter** returning a new combined value:

```dart
final num1 = RxNotifier<int>(1);
final num2 = RxNotifier<int>(2);

String get result => 'num1: ${num1.value} + num2: ${num2.value} = ${num1.value + num2.value}';

...

rxObserver((){
    print(result); // print´s "num1: 1 + num2: 2 = 3
});
```

> **IMPORTANT**: It is really necessary that **computed** are **Getters** and not assignments. The reaction will happen when any of the **RxNotifier** changes the value.

## Using Getters

We can also use **getters** in reactive values making, let's repeat the example above:

```dart

final _num1 = RxNotifier<int>(1);
int get num1 => _num1.value;

final _num2 = RxNotifier<int>(2);
int get num2 => _num2.value;

String get result => 'num1: $num1 + num2: $num2 = ${num1 + num2}';

...

rxObserver((){
    print(result); // print´s "num1: 1 + num2: 2 = 3
});


```

## Filters

All Rx listeners have a property filter **filter** which is a function that returns a **bool**. Use this to define when (or not) to reflect changes:

```dart
RxDisposer disposer = rxObserver<String>((){
    return '${name.value} + ${lastName.value}';
}, filter: (fullName) => fullName.isNotEmpty);

disposer();
```



## Flutter and RxNotifier

RxNotifeir has tools that help with state management and propagation for the Widget.

1. Add the RxRoot Widget to the root of the app:

```dart
void main(){
  runApp(RxRoot(child: AppWidget()));
}
```

2. Now just use the `context.select` method passing the RxNotifier objects:

```dart

final counter = RxNotifier(0);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final value = context.select(() => counter.value);

    return Scaffold(
      body: Center(
        child: Text(
          '${home.count}',
           style: TextStyle(fontSize: 23),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => counter.count++,
      ),
    );
  }
}
```

## Flutter and RxNotifier: OPTIONAL RxBuilder
A builder for managing state in a scoped way is also available:

```dart
Widget build(BuildContext context){
    return RxBuilder(
        builder: (_) => Text('${counter.value}'),
    );
}
```

> **IMPORTANT**: Both the `context.select` method and the builder have the `filter` property.

## Collections and Asyncs

**RxList**

An RxList gives you a deeper level of observability on a list of values. It tracks when items are added, removed or modified and notifies the observers. Use an RxList when a change in the list matters.

**RxMap**

An RxMap gives you a deeper level of observability on a map of values. It tracks when keys are added, removed or modified and notifies the observers. Use an RxMap when a change in the map matters.

**RxSet**

An RxSet gives you a deeper level of observability on a set of values. It tracks when values are added, removed or modified and notifies the observers. Use an RxSet when a change in the set matters.

**RxFuture**

The RxFuture is the reactive wrapper around a Future. You can use it to show the UI under various states of a Future, from pending to fulfilled or rejected. The status, result and error fields of an RxFuture are observable and can be consumed on the UI.
You can add a new Future using **.value**
```dart
final rxFuture = RxFuture.of(myFuture);
...

rxFuture.value = newFuture;
```

**RxStream**

The stream that is tracked for status and value changes.
T initialValue: The starting value of the stream.


## OPTIONAL Code generator

If you prefer a leaner syntax for RxNotifier objects, use code generation with build_runner.

1. Add the rx_notifier_generator and build_runner packages to dev_dependencies.

```yaml
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

## Features and bugs

Please send feature requests and bugs at the issue tracker.

This README was created based on templates made available by Stagehand under a BSD-style license.