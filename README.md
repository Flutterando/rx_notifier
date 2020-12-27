# rx_notifier

The [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) é uma forma simples e nativa de reatividade do Flutter.
Está extension visa aplicar de forma transparente a **functional reactive programming (TFRP)**.

## Install

Add in pubspec.yaml:

```yaml
dependencies:
  rx_notifier: <version>
```

## Entendendo a Extensão.

Está extensão acrescenta uma classe **RxNotifier** e um conversor **ValueNotifier -> RxNotifier** para que possa ser observado de forma transparente pela função **rxObserver()** e pelo [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html) **RxBuilder**.

O **RxNotifier** é diretamente  uma extensão de [ValueListenable](https://api.flutter.dev/flutter/foundation/ValueListenable-class.html) então qualquer objeto que o implemente pode ser convertido para **RxNotifier**

A única diferença do **RxNofifier** para o [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) é a função de assinatura automática nos Observadores **rxObserver()** e **RxBuilder**, muito semelhante as [reactions do MobX](https://pub.dev/packages/mobx).

## Using

Para começar instancia um RxNofifier.

```dart
final counter = RxNotifier<int>(0);

```

ou conversa um [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) já existente usando o método **.rx()**:

```dart

final counter = myValueNotifierCounter.rx();

```
> **IMPORTANT**: O método **rx()** foi adicionado ao [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) usando [Extension Methods](https://dart.dev/guides/language/extension-methods).

Atribuimos um novo valor:

```dart

final counter = RxNotifier<int>(0);

increment(){
    counter.value++;
}

```

E escutamos as alterações usando o **rxObserver**:

```dart

RxDisposer disposer = rxObserver((){
    print(counter.value);
});


disposer();

```

Ou escutamos na árvore de Widget usando o **RxBuilder**:


```dart

Widget builder(BuildContext context){
    return RxBuilder(
        builder: (_) => Text('${counter.value}'),
    );
}

```

Esse é o uso transparente de reatividade individual, porém podemos também combinar **RxNotifier Objects** produzindo um novo valor. Essa técnica se chama **Computed**

## Computed: Combinando valores reativos

Para combinar dois ou mais **RxNotifier Objects** precisamos usar um **getter** retornando um novo valor combinado:

```dart

final num1 = RxNotifier<int>(1);
final num2 = RxNotifier<int>(2);

String get result => 'num1: ${num1.value} + num2: ${num2.value} = ${num1.value + num2.value}';

...

rxObserver((){
    print(result); // print´s "num1: 1 + num2: 2 = 3
});


```

> **IMPORTANT**: É realmente necessário que os **computed** sejam **Getters** e não atribuições.

## Usando Getters

Podemos também usar **getters** nos valores reativos tornando, vamos repetir o exemplo acima:

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

## Filtros

Tanto o **rxObserver** quanto o **RxBuilder** tem a propriedade **filter** que é uma função que retorna um **bool**. Use isso para definir quando(ou não) refletir as alterações:

```dart

Widget builder(BuildContext context){
    return RxBuilder(
        filter: () => counter.value < 10,
        builder: (_) => Text('${counter.value}'),
    );
}

```

## Potencialize mais o ValueNotifier

O [functional_listener](https://pub.dev/packages/functional_listener) adiciona map, where, listen, debounce, combineLatest e várias outras funções para o ValueNotifier.
Muito obrigado [Thomas Burkhart](https://twitter.com/Thomasburkhartb) por isso!!!

## Features and bugs

Please send feature requests and bugs at the issue tracker.

This README was created based on templates made available by Stagehand under a BSD-style license.