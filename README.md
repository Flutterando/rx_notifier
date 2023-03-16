# rx_notifier

The [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) is a simple, native form of Flutter reactivity.
This extension aims to transparently apply **functional reactive programming (TFRP)**.

- [Read the documentation](https://github.com/Flutterando/rx_notifier/tree/master/rx_notifier).

## Implementing the Atomic State.

It is possible to implement [Recoil](https://recoiljs.org) Atoms pattern using `RxNotifier`.
This pattern consists of the state being an object with its own reactivity.

![atom](/assets/atom.png)


## Motivation

Developers still have trouble understanding state management in Flutter.
We had this conclusion after several research in the community fluttering and also
in partner companies.
Atomic State is a noob-friendly state management approuch at the same time
that maintains a reliable structure thinking of scalability and maintenance.

More details, read this [Medium article on the subject](https://medium.com/@jacobmoura/introdu%C3%A7%C3%A3o-ao-estado-at%C3%B4mico-no-flutter-com-rxnotifier-73ad9edf8718).


## Rules

We must take into account some architectural limits to execute this Approach:

1. All states must be an atom(`RxNotifier` instance).
2. All actions must be an atom(`RxNotifier` instance).
3. Business rules must be created in the `Reducer` and not in the Atom.


## Layers

We will have 3 main layers, they are: `Atoms`, `Reducers` and `Views`;

![atom](/assets/arch.png)

Note that the View (which is the presentation layer) does not know about the Reducer (which is the business rule execution layer).
These two layers share atoms that in turn represent the state and the dispatch of state actions.

In Flutter these layers translate to Atom(`RxNotifier`), Reducer(RxReducer) and View(Widget):

![atom](/assets/flutter-rx.png)


## Atoms (RxNotifier and RxAction)

Atom represent the reactive state of an application.
Each atom has its own reactivity.

> **IMPORTANT**: The **RxAction()** is a special `RxNotifier`
other than a value assignment to notify listeners.
Just call the `call()` method;

```dart
// atoms
final productsState = <Product>[].asRx();
final productTextFilterState = RxNotifier<String>('');

// computed
List<Product> get filteredProductsState {
     if(productTextFilterState.value.isEmpty()){
         return productsState.value;
     }

     return productsState.where(
         (p) => p.title.contains(productTextFilterState.value),
     );
}

// actions
final selectedProductState = RxNotifier<Product?>(null);
final fetchProductsState = RxAction();
```



## Reducer (RxReducer)

In this architecture you are forced to split state management
of business rules, which may seem strange at first when seen
that we are always managing and reducing state in the same layer as `BLoC` and `ChangeNotifier` for example.<br>
However, dividing state management and business rule execution will help us distribute multiple states to the same widget, and these multiple states will not need to be concatenated beforehand through a `facade` or `proxy`.

The layer responsible for making business decisions will be called `Reducer`:

```dart
class ProductReducer extends RxReducer {

    ProductReducer(){
        on(() => [fetchProductsState.action], _fetchProducts);
        on(() => [selectedProductState.value], _selectProduct);
    }

    void _fetchProducts(){
        ...
    }

    void _selectProduct(){
        ...
    }
}
```

`Reducers` can register methods/functions that listen to the reactivity of an `Atom`, be it `RxNotifier` or `RxAction`.

## View (Widget)

Any widget can listen to changes of one or many atoms,
provided they have the `RxRoot` widget as their ancestor.
For more details about RxRoot, [Read the documentation](https://github.com/Flutterando/rx_notifier/tree/master/rx_notifier).

The `context.select()` method is added via Extension to `BuildContext` and can be called on any type of Widget, `StatefulWidget` and `StatelessWidget`.

```dart

...
Widget build(BuildContext context){
     final products = context.select(
                 () => filteredProductsState.value
              );
     ...
}

```

## Examples

Flutter projects using RxNotifier

[Trivial Counter](https://github.com/Flutterando/rx_notifier/tree/master/rx_notifier/example/trivial_counter).

[Shop Cart](https://github.com/Flutterando/rx_notifier/tree/master/rx_notifier/example/shop_cart).