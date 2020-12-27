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

or chat an  [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) already existing using the **.rx()** method:

```dart

final counter = myValueNotifierCounter.rx();

```
> **IMPORTANT**: The **rx()** method has been added to [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) using [Extension Methods](https://dart.dev/guides/language/extension-methods).

We assign a new value:

```dart

final counter = RxNotifier<int>(0);

increment(){
    counter.value++;
}

```

And we hear the changes using **rxObserver**:

```dart

RxDisposer disposer = rxObserver((){
    print(counter.value);
});


disposer();

```

Or we listen in the Widget tree using **RxBuilder**:


```dart

Widget builder(BuildContext context){
    return RxBuilder(
        builder: (_) => Text('${counter.value}'),
    );
}

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

Both **rxObserver** and **RxBuilder** have a property filter **filter** which is a function that returns a **bool**. Use this to define when (or not) to reflect changes:

```dart

Widget builder(BuildContext context){
    return RxBuilder(
        filter: () => counter.value < 10,
        builder: (_) => Text('${counter.value}'),
    );
}

```

## Empower more the ValueNotifier

The [functional_listener](https://pub.dev/packages/functional_listener) add map, where, listen, debounce, combineLatest and several other functions for  ValueNotifier.
Thank you very much [Thomas Burkhart](https://twitter.com/Thomasburkhartb) for that!!!

## Features and bugs

Please send feature requests and bugs at the issue tracker.

This README was created based on templates made available by Stagehand under a BSD-style license.